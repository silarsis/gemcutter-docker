if Rails.env.test?
  Redis.current = Redis.new(db: 1, host: ENV['REDIS_HOST'])
elsif Rails.env.recovery?
  require "fakeredis"
else
  Redis.current = Redis.new(host: ENV['REDIS_HOST'])
end
