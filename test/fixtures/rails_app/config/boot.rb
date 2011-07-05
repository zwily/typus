require 'rubygems'

typus_gemfile = File.expand_path('../../../../../Gemfile', __FILE__)

ENV['BUNDLE_GEMFILE'] = if File.exists?(typus_gemfile)
                          typus_gemfile
                        else
                          File.expand_path('../../Gemfile', __FILE__)
                        end

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
