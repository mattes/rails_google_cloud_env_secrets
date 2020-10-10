module GoogleCloudEnvSecrets
  class Railtie < ::Rails::Railtie

    # load Google Secrets during Rails `before_configuration` hook
    config.before_configuration do
      GoogleCloudEnvSecrets.load
    end
  end

  # load Google Secrets into ENV
  def self.load
    GoogleCloudEnvSecrets.configure do |config|
      config.credentials = ENV["GOOGLE_APPLICATION_CREDENTIALS"] || nil
      config.project = ENV["GOOGLE_PROJECT"] || Google::Cloud.env.project_id
      config.prefix = ENV["GOOGLE_SECRETS_PREFIX"] || nil

      if ENV.has_key?("GOOGLE_SECRETS_FORCE")
        config.force = ENV["GOOGLE_SECRETS_FORCE"]&.to_s&.downcase == "true"
      end
    end

    secrets = GoogleCloudEnvSecrets.all
    GoogleCloudEnvSecrets.inject_env!(secrets, GoogleCloudEnvSecrets.configuration.force)
  end
end
