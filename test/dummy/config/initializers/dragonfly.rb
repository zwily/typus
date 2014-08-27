require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

<<<<<<< HEAD
  protect_from_dos_attacks true
  secret "7fac81075e295d08d80c5ed5c327bc11d6c42e5bd9614ac994c41bed40bbb5e9"
=======
  secret "a62cb203f9407666c5e5e2ffa739c4d1b6964bc3ea326c74a11ba75c2c2a39a6"
>>>>>>> Updated dragonfly initializer

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
