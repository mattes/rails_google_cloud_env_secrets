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
    h = { "foo" => "bar" }
    GoogleCloudEnvSecrets.inject_env!({ "foo": "updated" }, true, h)
    assert_equal 1, h.size
    assert_equal "updated", h["foo"]
  end

  test "inject_env! without force" do
    h = { "foo" => "bar", "bar" => nil, "abc" => "" }
    GoogleCloudEnvSecrets.inject_env!({ "foo": "updated", "bar": "updated", "abc" => "updated" }, false, h)
    assert_equal 3, h.size
    assert_equal "bar", h["foo"]
    assert_equal "updated", h["bar"]
    assert_equal "", h["abc"]
  end

  test "inject_env! injects into ENV" do
    GoogleCloudEnvSecrets.inject_env!({ "GOOGLE_SECRET_TEST": "foobar" }, true)
    assert_equal "foobar", ENV["GOOGLE_SECRET_TEST"]
  end
end
