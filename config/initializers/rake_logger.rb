# config/initializers/rake_logger.rb

require 'logger'

module Rake
  class Task
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
