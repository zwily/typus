require "typus"

Typus.boot!
Typus.reload! if Rails.env.production?
