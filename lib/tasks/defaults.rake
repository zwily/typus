namespace :typus do

  desc "List current roles."
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "\n#{role.first.capitalize} role has access to:"
      role.last.each { |key, value| puts "- #{key}: #{value}" }
    end
    puts "\n"
  end

end
