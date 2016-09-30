uri = URI.parse(ENV['REDIS_URL']) if ENV['REDIS_URL']
REDIS = uri.nil? ? Redis.new : Redis.new(url: uri, driver: :hiredis)