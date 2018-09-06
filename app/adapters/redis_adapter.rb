module RedisAdapter
  def self.redis_instance
    @redis ||= Redis.new
  end
end
