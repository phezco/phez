Recaptcha.configure do |config|
  config.public_key  = Figaro.env.recaptcha_public_key
  config.private_key = Figaro.env.recaptcha_private_key
  # Uncomment if you want to use the newer version of the API,
  # only works for versions >= 0.3.7:
  # config.api_version = 'v2'
end
