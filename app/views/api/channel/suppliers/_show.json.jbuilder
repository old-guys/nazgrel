json.(
  record,
  :id, :industry_id, :sup_no, :name, :url,
  :logo, :desc
)

json.status record.status
json.status_text record.status_i18n

json.(
  record,
  :created_at, :updated_at
)