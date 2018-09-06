class ProcessInfectationService

  REPORTERS_LIMIT = 3.freeze

  def initialize(infected, reporter, redis_adapter)
    @infected = infected
    @reporter = reporter
    @infected_set = "reporters:#{infected.id}"
    @redis = redis_adapter
  end

  def call
    reporters = reporters_from_infected
    return "Already reported by current reporter", 422 if reporters.include?(reporter.id.to_s)
    reporters_count = push_reporter
    return "Report counted", 200 if reporters_count != REPORTERS_LIMIT
    mark_as_infected
    return "Survivor marked as infected", 200
  end

  private

  attr_accessor :infected, :redis
  attr_reader   :reporter, :infected_set

  def reporters_from_infected
    redis.lrange(infected_set, 0, -1)
  end

  def push_reporter
    redis.lpush(infected_set, reporter.id)
  end

  def mark_as_infected
    infected.update(infected: true)
    redis.del(infected_set)
  end

end
