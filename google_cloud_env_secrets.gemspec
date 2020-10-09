$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "google_cloud_env_secrets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "google_cloud_env_secrets"
  spec.version     = GoogleCloudEnvSecrets::VERSION
  spec.authors     = ["Matthias Kadenbach"]
  spec.homepage    = "https://github.com/mattes/rails_google_cloud_env_secrets"
  spec.summary     = "Load Google Cloud Secrets into ENV"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.4"
  spec.add_dependency "google-cloud-secret_manager", "~> 1.0.0"
  spec.add_dependency "google-cloud-env", "~> 1.3.3"
  spec.add_dependency "concurrent-ruby", "~> 1.1.7"

  spec.add_development_dependency "sqlite3"
end
