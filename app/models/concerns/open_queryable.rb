module OpenQueryable
  extend ActiveSupport::Concern

  included do
  end

  def phone_belong_to_k780(phone: )
    url = "http://api.k780.com:88/?app=phone.get&phone=#{phone}&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"
    result = HashWithIndifferentAccess.new(HTTParty.get(url))

    if result[:success].eql?('1')
      style_citynm = result[:result][:style_citynm]
      citynms = style_citynm.split(',')
      citynms.delete_at(0)

      citynms.uniq.join(' ')
    end
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  def ip_belong_to_k780(ip: )
    url = "http://ip.taobao.com/service/getIpInfo.php?ip=#{ip}"
    result = HashWithIndifferentAccess.new(JSON.parse(HTTParty.get(url)))

    if result[:code].eql?(0)
      data = result[:data]
      [[data[:region], data[:city]].uniq, data[:isp]].flatten.compact.join(' ') if data[:isp_id].present?
    end
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  def phone_belong_to_juhe(phone: )
    phone_belong_to_juhe_hash(phone: phone).slice("province", "city").compact.values.uniq.join(' ') rescue nil
  end

  def phone_belong_to_juhe_hash(phone: )
    url = "http://apis.juhe.cn/mobile/get?&phone=#{phone}&dtype=json&key=0f57227acba110ebfdbf86973a53bcab"
    result = HashWithIndifferentAccess.new(HTTParty.get(url))

    result[:resultcode].eql?("200") ? result["result"] : nil
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  def tel_phone_belong_to_juhe(number: )
    url = "http://op.juhe.cn/onebox/phone/query?&tel=#{number}&dtype=json&key=33e4b1ad06c588c93a359fc9e741ffc0"
    result = HashWithIndifferentAccess.new(HTTParty.get(url))

    if result[:error_code].eql?(0)
      result["result"].slice("province", "city").compact.values.uniq.join(' ')
    end
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  def ip_belong_to_juhe(ip: )
    url = "http://apis.juhe.cn/ip/ip2addr?ip=#{ip}&dtype=json&key=6af79b90bc9ce81b06b0e26e2dbc6509"
    result = HashWithIndifferentAccess.new(HTTParty.get(url))

    if result[:resultcode].eql?("200")
      result["result"]["area"] if result["result"]["area"] != "IANA"
    end
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  #showji.com 手机号归属地、区号查询接口
  def phone_belong_to_showji_hash(phone: )
    url = "http://api.showji.com/locating/sh_wwj_20170929.aspx?m=#{phone}&outfmt=json&outenc=UTF-8"

    HashWithIndifferentAccess.new(JSON.parse(HTTParty.get(url).body))
  rescue => e
    Rails.logger.error "exception: #{e.message}"
  end

  module ClassMethods
  end
end
