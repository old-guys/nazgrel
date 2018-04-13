module Export::Processable
  extend ActiveSupport::Concern

  included do
    attr_accessor :records, :total_count, :max_size

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

    _per_page = Kaminari.config.max_per_page
    _total_pages = (total_count / _per_page.to_f).ceil
    _fields = send("#{action}_fields")

    self.gap_progress = (70.0 / _total_pages).round(2)
    1.upto(_total_pages) do |page|
      self.records = collection.page(page).per(_per_page)
      _convert_records = respond_to?("#{action}_records_convert") ? send("#{action}_records_convert") : records

      _convert_records.each_with_index {|record, i|
        if i % _per_page == 0
          self.progress = 3 + (70 * page.to_f / _total_pages).round(2)
          send_to_message
        end

        row = _fields.collect{|field|
          _method = "#{action}_record_#{field}"

          begin
            if respond_to?(_method, true)
              send(_method, record)
            else
              field.split('.').inject(record) {|obj, name|
                obj.send(name)
              }
            end
          rescue => e
            logger.error "export record #{record}, failure #{e.message}"
            log_error(e)

            ""
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
      progress: 73,
      gap_progress: 26
    )
    send_to_message
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

  def xlsx_package
    @xlsx_package ||= Axlsx::Package.new
  end

  def xlsx_package_wb
    xlsx_package.workbook
  end

  def xlsx_package_ws
    @ws ||= xlsx_package_wb.add_worksheet(name: action_name)
  end

  module ClassMethods
  end
end