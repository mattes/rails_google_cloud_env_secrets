module GoogleCloudEnvSecrets
  def self.all
    @secrets = nil unless self.configuration.cache_secrets
    @secrets ||= begin
        # Skip if not running on Google Cloud and credentials are not set explicitly
        if self.configuration.credentials.nil? && Google::Cloud.env.project_id.nil?
          return {}
        end

        # Configure and initialize
        # https://googleapis.dev/ruby/google-cloud-secret_manager/latest/Google/Cloud/SecretManager.html
        Google::Cloud::SecretManager.configure do |config|
          if File.exist?(self.configuration.credentials)
            config.credentials = self.configuration.credentials # load by file
          else
            config.credentials = JSON.parse(self.configuration.credentials) # load data
          end
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

    @secrets || {}
  end

  def self.find(name)
    self.all[name.to_s]
  end

  def self.exist?(name)
    self.all.has_key?(name.to_s)
  end

  def self.inject_env!(secrets = {}, overload = true, env = ENV)
    secrets.each do |name, value|
      name = name.to_s
      if overload
        env[name] = value
      else
        env[name] ||= value
      end
    end
  end
end
