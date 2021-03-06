desc "Fetch Google Cloud Secret"
task :google_cloud_secret do
  name = ENV["NAME"].strip

  fail "#{name} not found" unless GoogleCloudEnvSecrets.exist?(name)

  $stdout.sync = true
  print GoogleCloudEnvSecrets.find(name)
end
