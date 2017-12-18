_md5 = Digest::MD5.hexdigest(@data.to_s)

json.cache! ['api/web/constant_setting/enum_field', _md5], expires_in: 60.minutes do
  json.(@data, *@data.keys)

  json.md5 _md5
end