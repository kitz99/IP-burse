# APP_ID = '5d14cdaf-fb7d-4766-aac7-aefed999eaea'
# APP_SECRET = '344050ef964701cf0db18af6e2f5883335c91a41cae5c40f18'
# CUSTOM_PROVIDER_URL = 'http://fmi-api.herokuapp.com'

  APP_ID = '7ebb62c8-b53c-42a8-b0a8-ee99d9a962f9'
  APP_SECRET = '3b50f742df6db7eceee9786c039f2683209538e49659305946'
  CUSTOM_PROVIDER_URL = 'http://193.226.51.30'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :autentificare, APP_ID, APP_SECRET
end
