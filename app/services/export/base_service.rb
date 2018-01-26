module Export
  module BaseService

    extend ActiveSupport::Concern

    include ExportLoggerable

    QUANTIFY = 1000

    included do
      attr_accessor :service, :action
      attr_accessor :user, :user_id
      attr_accessor :cache_key, :page, :per_page, :quantify
      attr_accessor :file_path, :file_size, :file_name, :qiniu_file_path
      attr_accessor :channel, :status, :async_client_id, :gap_progress, :progress
    end

    class << self

      def faye_channel(user_id)
        "/export/file/#{user_id}"
      end

      def services
        %w(ChannelShopNewer ChannelShopActivity)
      end

      def action_map_names
        {
          'ChannelShopNewer#report' => '渠道新增店主',
          'ChannelShopActivity#report' => '渠道店主行为'
        }
      end

    end

    def initialize(opts = {})
      assign_attributes(opts)
      extend_attributes
    end

    def assign_attributes(opts = {})
      opts = HashWithIndifferentAccess.new(opts)
      opts.each do |k, v|
        next unless self.respond_to?("#{k}=")
        self.send("#{k}=", v)
      end
    end

    def extend_attributes
      @channel = Export::BaseService.faye_channel(user_id)
      @user = User.find_by_id(user_id)
      @per_page = per_page || Kaminari.config.max_per_page
      @quantify = quantify || QUANTIFY
      @page = page.to_i || 1
    end

    def action_name
      @action_name ||= Export::BaseService.action_map_names["#{service}##{action}"]
    end

    def collections
      return send("#{action}_collections") if respond_to?("#{action}_collections")

      @collections ||= Rails.cache.read(cache_key) || []
    end

    def records
      return @records if not @records.nil?

      @records = collections.page(first_page).per(per_page)
    end

    def first_page
      (page - 1) * quantify / per_page + 1
    end

    def last_page
      return @last_page if @last_page

      total_pages = records.total_pages
      last_page = page * quantify / per_page

      @last_page = total_pages >= last_page ? last_page : total_pages
    end

    def total_pages
      last_page - first_page + 1
    end

    def total_count
      return @total_count if @total_count

      count = records.total_count
      start_index = (first_page - 1) * per_page + 1

      end_index = last_page * per_page
      end_index = count >= end_index ? end_index : count

      @total_count = end_index - start_index + 1
    end

    def current_page
      @records.current_page
    end

    def first_page?(page = nil)
      (page || current_page) == first_page
    end

    def last_page?
      current_page >= last_page
    end

    def current_index(page, i)
      (page - first_page) * per_page + i
    end

    def clear_attributes
      instance_variable_names.each do |variable_name|
        instance_variable_set(variable_name, nil)
      end
    end

    def remove_file
      file_path.present? && File.exists?(file_path) && File.delete(file_path)
    end

    def delete_cache
      Rails.cache.delete(cache_key)
    end

    def finally
      delete_cache
      remove_file
      clear_attributes
    end

    def message_params
      {
        status: status,
        qiniu_file_path: qiniu_file_path,
        file_size: file_size,
        progress: progress.to_f,
        service: service,
        async_client_id: async_client_id,
        gap_progress: gap_progress.to_f,
        page: page,
        count: total_count,
        action_name: action_name
      }
    end

    def send_to_message(params = {})
      FayeClient.send_message(channel, message_params.merge(params))
    end

    def file_dir
      return @file_dir if @file_dir

      @file_dir = "#{Rails.root}/tmp/export"
      Dir.mkdir(@file_dir) unless Dir.exist?(@file_dir)
      @file_dir
    end

    def generate_file_path
      file_name = "#{async_client_id || SecureRandom.uuid}.xlsx"
      @file_path = File.join(file_dir, file_name)
    end

    def xlsx_package
      @xlsx_package ||= Axlsx::Package.new
    end

    def xlsx_package_wb
      @wb ||= xlsx_package.workbook
    end

    def xlsx_package_ws
      @ws ||= xlsx_package_wb.add_worksheet(name: action_name)
    end

    def xlsx_package_serialize
      xlsx_package.serialize(file_path)
    end

    def write_head
      return send("write_#{action}_head") if respond_to?("write_#{action}_head")

      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})
      xlsx_package_ws.add_row send("#{action}_head_names"), style: title_style
    end

    def write_body
      return send("write_#{action}_body") if respond_to?("write_#{action}_body")

      single_progress = 47.to_f / total_count
      @gap_progress = single_progress * 10

      (first_page..last_page).each do |page|
        @records = @records.page(page).per(per_page) unless first_page?(page)
        @convert_records = respond_to?("#{action}_records_convert") ? send("#{action}_records_convert") : @records

        @convert_records.each_with_index {|record, i|
          if (i + 1) % 25 == 0
            # sleep 20
            @progress = 4 + current_index(page, i) * single_progress
            send_to_message
          end

          fields = send("#{action}_fields")
          row = fields.collect{|field|
            if respond_to?("#{action}_record_#{field}")
              send("#{action}_record_#{field}", record)
              # next
            else
              if field.include?('.')
                field.split('.').each_with_object([record]) {|name, arr|
                  arr << arr.last.send(:try, name)
                }.last
              else
                record.send(field)
              end
            end


          }

          xlsx_package_ws.add_row row, widths: [15] * row.size
        }
      end
    end

    def write_file
      write_head
      write_body
    end

    def mime_type
      Rack::Mime.mime_type(File.extname(file_path))
    end

    def qiniu_file_key
      "tmp/#{async_client_id}/#{action_name}_#{Time.now.strftime('%Y%m%d')}-#{page}.xlsx"
    end

    def upload_file_to_qiniu
      result = Qiniu.upload_file({
        uptoken: qiniu_upload_token,
        file: file_path,
        bucket: QINIU_CONFIG['bucket'],
        key: qiniu_file_key,
        mime_type: mime_type
      })

      @qiniu_file_path = "#{QINIU_CONFIG['host']}/#{result['key']}" if result && result.has_key?('key')
    end

    def validate?
      return true if cache_key && @user

      @status = :failure
      send_to_message
    end

    def process
      @status   = :start
      @progress = 3
      @gap_progress = 1
      send_to_message

      @status = :write
      generate_file_path

      write_file
      xlsx_package_serialize
      @status    = :before_upload
      @file_size = File.size(file_path)
      @progress  = 52
      @gap_progress = 47
      send_to_message

      @status    = upload_file_to_qiniu ? :success : :upload_failure
      @progress  = 100 if @status.eql?(:success)
      send_to_message

      finally
    end

    def perform
      process if validate?
    end

  end
end