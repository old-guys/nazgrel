json.code (@code || 0)
if @message
  json.message @message.presence
end
if @remark
  json.message @remark.presence
end

json.data JSON.parse(yield)
