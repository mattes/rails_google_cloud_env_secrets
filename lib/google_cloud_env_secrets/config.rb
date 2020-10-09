module GoogleCloudEnvSecrets
  class Configuration
    attr_accessor :project
    attr_accessor :credentials
    attr_accessor :cache_secrets
    attr_accessor :prefix

    def initialize
      @cache_secrets = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
