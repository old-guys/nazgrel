# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, {:error => 'log/whenever_error.log', :standard => 'log/whenever_standard.log'}

every 2.weeks do
  runner "SesameMall::Source::SeekRecord.prune_old_records"
end

every 2.months do
  runner "ReportChannelShopNewer.prune_old_records"
  runner "ReportShopActivity.prune_old_records"
  runner "ReportCityShopActivity.prune_old_records"
  runner "ReportChannelShopActivity.prune_old_records"
end

every 1.months do
  runner "ShareJournal.prune_old_records"
  runner "ViewJournal.prune_old_records"

  runner "ProductShop.prune_old_records"
end