namespace :typus do

  desc 'Install tiny_mce.'
  task :tiny_mce do
    system "script/plugin install git://github.com/kete/tiny_mce.git --force"
    load File.join Rails.root, 'vendor', 'plugins', 'tiny_mce', 'tasks', 'tiny_mce.rake'
    Rake::Task["tiny_mce:install"].invoke
  end

  desc 'Install ckeditor.'
  task :ckeditor do
    system "script/plugin install git://github.com/galetahub/rails-ckeditor.git --force"
    load File.join Rails.root, 'vendor', 'plugins', 'rails-ckeditor', 'tasks', 'ckeditor_tasks.rake'
    Rake::Task["ckeditor:install"].invoke
    Rake::Task["ckeditor:config"].invoke
  end

end