require "test_helper"
require "rake"

class GoogleCloudEnvSecrets::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, GoogleCloudEnvSecrets
  end

  test "all" do
    GoogleCloudEnvSecrets.configure do |config|
      config.prefix = nil
      config.cache_secrets = false
      config.force = true
    end

    secrets = GoogleCloudEnvSecrets.all

    assert_equal 3, secrets.size
    assert_equal "value for the prefixed secret", secrets["PREFIX_SECRET"]
    assert_equal "value for my secret 1", secrets["my-secret-1"]
    assert_equal "new version for my secret 2", secrets["my-secret-2"]
  end

  test "all with prefix" do
    GoogleCloudEnvSecrets.configure do |config|
      config.prefix = "PREFIX"
      config.cache_secrets = false
      config.force = true
    end

    secrets = GoogleCloudEnvSecrets.all

    assert_equal 1, secrets.size
    assert_equal "value for the prefixed secret", secrets["SECRET"]
  end

  test "find" do
    GoogleCloudEnvSecrets.configure do |config|
      config.prefix = nil
      config.cache_secrets = true
      config.force = true
    end

    assert "value for my secret 1", GoogleCloudEnvSecrets.find("my-secret-1")
  end

  test "inject_env! with force" do
    h = {}
    GoogleCloudEnvSecrets.inject_env!({ "foo": "bar" }, true, h)
    assert_equal 1, h.size
    assert_equal "bar", h["foo"]
  end

  test "inject_env! without force" do
    h = { "foo" => "bar" }
    GoogleCloudEnvSecrets.inject_env!({ "foo": "updated" }, false, h)
    assert_equal 1, h.size
    assert_equal "bar", h["foo"]
  end
end
