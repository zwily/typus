namespace :typus do

  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'

  desc "Create TypusUser `rake typus:seed email=foo@bar.com`"
  task :seed => :environment do

    include Authentication

    ##
    # Create the new user with the params.
    #
    email = ENV['email']
    password = ENV['password'] || generate_password

    begin
      typus_user = TypusUser.new(:email => email, 
                                 :password => password, 
                                 :password_confirmation => password, 
                                 :first_name => 'Typus', 
                                 :last_name => 'Admin', 
                                 :roles => 'admin', 
                                 :status => true)
      if typus_user.save
        puts "=> Your new password is #{password}"
      else
        puts "=> Please, provide a valid email. (rake typus:seed email=foo@bar.com)"
      end
    rescue
      puts "=> Run `script/generate typus_migration` to create required tables"
    end

  end

  desc "Install Typus plugins"
  task :plugins do

    plugins = [ "git://github.com/fesplugas/simplified_blog.git", 
                "git://github.com/fesplugas/simplified_activity_stream.git" ]

    system "script/plugin install #{plugins.join(' ')}"

  end

  desc "Install Typus dependencies (paperclip, acts_as_list, acts_as_tree)"
  task :dependencies do

    plugins = [ "git://github.com/thoughtbot/paperclip.git", 
                "git://github.com/rails/acts_as_list.git", 
                "git://github.com/rails/acts_as_tree.git" ]

    system "script/plugin install #{plugins.join(' ')}"

  end

  desc "List current roles"
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "=> #{role.first.capitalize} has access to #{role.last.keys.join(", ")}."
    end
  end

end