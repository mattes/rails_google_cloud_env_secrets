require "json"

module GoogleCloudEnvSecrets
  class Configuration
    attr_accessor :project
    attr_accessor :credentials
    attr_accessor :cache_secrets
    attr_accessor :prefix
    attr_accessor :overload

    def initialize
      @cache_secrets = true
      @overload = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.parse_project_from_credentials(credentials)
    j = JSON.load(File.open(credentials))
    j["project_id"]
  rescue
    nil
  end
end
