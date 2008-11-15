namespace :typus do

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
      puts "=> Role `#{role.first}` has access to:"
      role.last.each { |key, value| puts "** #{key}: #{value}" }
    end
  end

  desc "Generate specdoc-style documentation from tests"
  task :specs do

    puts 'Started'
    timer, count = Time.now, 0

    File.open(RAILS_ROOT + '/doc/TYPUS_SPECDOC', 'w') do |file|
      Dir.glob('vendor/plugins/typus/test/**/*_test.rb').each do |test|
        test =~ /.*\/([^\/].*)_test.rb$/
        file.puts "#{$1.gsub('_', ' ').capitalize} should" if $1
        File.read(test).map { |line| /test_should_(.*)$/.match line }.compact.each do |spec|
          file.puts "- #{spec[1].gsub('_', ' ')}"
          sleep 0.001; print '.'; $stdout.flush; count += 1
        end
        file.puts
      end
    end

    puts "\nFinished in #{Time.now - timer} seconds.\n"
    puts "#{count} specifications documented"

  end

end