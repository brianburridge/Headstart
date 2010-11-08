require 'yaml'

begin
  configuration = YAML.load_file("#{Rails.root}/config/headstart.yml")[Rails.env]
  configuration = HashWithIndifferentAccess.new(configuration)
  
  Headstart.configure do |config|
    config.mailer_sender        = configuration[:mailer_sender]
    config.impersonation_hash   = configuration[:impersonation_hash]
    config.use_facebook_connect = configuration[:use_facebook_connect]
    config.use_delayed_job      = configuration[:use_delayed_job]
    config.facebook_api_key     = configuration[:facebook_api_key]
    config.facebook_secret_key  = configuration[:facebook_secret_key]
    config.facebook_app_id      = configuration[:facebook_app_id]
    config.url_after_create      = configuration[:url_after_create]
    config.session_failure_template      = configuration[:session_failure_template]
  end

  if configuration[:madmimi_username].present? && configuration[:madmimi_api_key].present?
    MadMimiMailer.api_settings = {
       :username  => configuration[:madmimi_username],
       :api_key   => configuration[:madmimi_api_key]
    }
  else
  end
rescue LoadError
  puts "The /config/headstart.yml file is missing or broken."
end
