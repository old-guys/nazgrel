module OpenQueryable
  extend ActiveSupport::Concern

  included do
    delegate :open_query_logger, to: "self.class"
  end

  def phone_belong_to_juhe(phone: )
    phone_belong_to_juhe_hash(phone: phone).slice("province", "city").compact.values.uniq.join(' ') rescue nil
  end

  def phone_belong_to_juhe_hash(phone: )
    url = "http://apis.juhe.cn/mobile/get?&phone=#{phone}&dtype=json&key=0f57227acba110ebfdbf86973a53bcab"
    result = HashWithIndifferentAccess.new(open_query_get(url))

    result[:resultcode].eql?("200") ? result["result"] : nil
  rescue => e
    open_query_logger.error "exception: #{e.message}"

    nil
  end

  def tel_phone_belong_to_juhe(number: )
    url = "http://op.juhe.cn/onebox/phone/query?&tel=#{number}&dtype=json&key=33e4b1ad06c588c93a359fc9e741ffc0"
    result = HashWithIndifferentAccess.new(open_query_get(url))

    if result[:error_code].eql?(0)
      result["result"].slice("province", "city").compact.values.uniq.join(' ')
    end
  rescue => e
    open_query_logger.error "exception: #{e.message}"

    nil
  end

  def ip_belong_to_juhe(ip: )
    url = "http://apis.juhe.cn/ip/ip2addr?ip=#{ip}&dtype=json&key=6af79b90bc9ce81b06b0e26e2dbc6509"
    result = HashWithIndifferentAccess.new(open_query_get(url))

    if result[:resultcode].eql?("200")
      result["result"]["area"] if result["result"]["area"] != "IANA"
    end
  rescue => e
    open_query_logger.error "exception: #{e.message}"

    nil
  end

  #showji.com 手机号归属地、区号查询接口
  def phone_belong_to_showji_hash(phone: )
    url = "http://api.showji.com/locating/sh_wwj_20170929.aspx?m=#{phone}&outfmt=json&outenc=UTF-8"

    HashWithIndifferentAccess.new(JSON.parse(open_query_get(url).body))
  rescue => e
    open_query_logger.error "exception: #{e.message}"

    nil
  end

  private
  def open_query_get(url)
    response = HTTParty.get(url, timeout: 2)
    open_query_logger.info "open query #{url}: reponse #{response.body}"

    response
  end
  module ClassMethods
    def open_query_logger
      @open_query_logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/open_query.log", "weekly"))
    end
  end
end