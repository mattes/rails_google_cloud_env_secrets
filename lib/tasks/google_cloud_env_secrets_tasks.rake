desc "Fetch Google Cloud Secret"
task :google_cloud_secret do
  name = ARGV[1]
  puts GoogleCloudEnvSecrets.find(name)
end
