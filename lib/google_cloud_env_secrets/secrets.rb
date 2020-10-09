module GoogleCloudEnvSecrets
  def self.all
    @secrets = nil unless self.configuration.cache_secrets
    @secrets ||= begin
        # Configure and initialize
        # https://googleapis.dev/ruby/google-cloud-secret_manager/latest/Google/Cloud/SecretManager.html
        Google::Cloud::SecretManager.configure do |config|
          config.credentials = self.configuration.credentials
        end

        client = Google::Cloud::SecretManager.secret_manager_service

        # create worker pool to read secrets in parallel
        pool = Concurrent::FixedThreadPool.new(Concurrent.processor_count * 4)
        secrets = Concurrent::Hash.new

        # read all secrets ...
        client.list_secrets(parent: "projects/" + self.configuration.project).each do |secret|
          pool.post(secret) do |secret|
            name = secret.name.split("/").last

            # only consider prefixed secrets?
            if self.configuration.prefix
              next unless name.start_with? self.configuration.prefix

              # clean up name
              name.delete_prefix! self.configuration.prefix
              name.sub! /^[^a-z0-9]+/i, ""
            end

            secrets[name] = client.access_secret_version(name: secret.name + "/versions/latest").payload.data
          end
        end

        # shutdown worker pool
        pool.shutdown
        pool.wait_for_termination

        secrets
      end
    @secrets
  end

  def self.find(name)
    self.all # make sure we have the secrets loaded
    @secrets[name.to_s]
  end

  def self.inject_env!(secrets = {})
    secrets.each do |name, value|
      ENV[name.to_s] = value
    end
  end
end
