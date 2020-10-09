module GoogleCloudEnvSecrets
  class Railtie < ::Rails::Railtie
    initializer "google_cloud_env_secrets.initialize", after: :bootstrap_hook do |app|
      GoogleCloudEnvSecrets.configure do |config|
        config.credentials = ENV["GOOGLE_APPLICATION_CREDENTIALS"] || nil
        config.project = ENV["GOOGLE_PROJECT"] || Google::Cloud.env.project_id
        config.prefix = ENV["GOOGLE_SECRETS_PREFIX"] || nil
      end

      secrets = GoogleCloudEnvSecrets.all
      GoogleCloudEnvSecrets.inject_env!(secrets)
    end
  end
end
