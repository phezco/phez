set :output, "/home/ubuntu/cron.log"

every 5.minutes do
  runner "Ranker.rank!"
end

every 1.day, :at => '1:05 am' do
  command "backup perform --trigger phez_backup"
end