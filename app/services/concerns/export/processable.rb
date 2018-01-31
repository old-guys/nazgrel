module Export::Processable
  extend ActiveSupport::Concern

  included do
    attr_accessor :records, :total_count, :page, :max_size

    def total_count
      @total_count ||= proc {
        _value = collection.try(:size)
        _value.is_a?(Hash) ? _value.size : _value
      }.call
    end
  end

  def write_head
    return send("write_#{action}_head") if respond_to?("write_#{action}_head")

    title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})
    xlsx_package_ws.add_row send("#{action}_head_names"), style: title_style
  end

  def write_body
    return send("write_#{action}_body") if respond_to?("write_#{action}_body")

    single_progress = 47.to_f / total_count
    self.gap_progress = single_progress * 10

    _collection = collection.page.per(1000)
    1.upto(_collection.total_pages) do |page|
      self.records = _collection.page(page)
      self.page = page.to_i

      @convert_records = respond_to?("#{action}_records_convert") ? send("#{action}_records_convert") : @records

      @convert_records.each_with_index {|record, i|
        if (i + 1) % 25 == 0
          @progress = 4 + page * single_progress
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

    xlsx_package.serialize(file_pathname)

    assign_attributes(
      status: :before_upload,
      progress: 52,
      gap_progress: 47
    )
    send_to_message
  end

  def xlsx_package
    @xlsx_package ||= Axlsx::Package.new
  end

  def xlsx_package_wb
    xlsx_package.workbook
  end

  def xlsx_package_ws
    @ws ||= xlsx_package_wb.add_worksheet(name: action_name)
  end

  private
  def build_file
    assign_attributes(
      status: :start,
      progress: 3,
      gap_progress: 1,
      file_pathname: Rails.root.join("tmp/export", "#{async_client_id || SecureRandom.uuid}.xlsx")
    )
    send_to_message
  end

  def finally
    file_pathname.delete rescue nil
    Rails.cache.delete(cache_key)
  end

  module ClassMethods
  end
end