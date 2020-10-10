# Google Cloud ENV Secrets

Load Google Cloud Secrets into ENV.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'google_cloud_env_secrets'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install google_cloud_env_secrets
```

## Usage

Configure this gem with environment vars:

| Variable                         | Description                                                                                                                                                                                                                                          |
|----------------------------------|--------------------------------------------------------------------|
| `GOOGLE_APPLICATION_CREDENTIALS` | Manually set path to Google Application Credentials.               |
| `GOOGLE_PROJECT`                 | Manually set the Google project. Automatically detected otherwise. |
| `GOOGLE_SECRETS_PREFIX`          | Only load secrets that start with prefix.                          |
| `GOOGLE_SECRETS_OVERLOAD`        | Replace existing ENV vars with secret's value. Default `true`.     |

Google Secrets are available after the [before_configuration hook](https://guides.rubyonrails.org/configuring.html#initialization-events).
You can call `GoogleCloudEnvSecrets.load` if you need the ENV secrets sooner than that.

See [docs](https://www.rubydoc.info/github/mattes/rails_google_cloud_env_secrets/main), too.

## Required IAM Roles

```
Secret Manager Secret Accessor
Secret Manager Viewer
```

