require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "headstart"
    gem.summary     = %Q{Headstart provides the Rails developer a headstart in creating a Rails app providing basic user authentication features.}
    gem.description = %Q{Based on Envy Labs Blue Light Special, but modified to provide more options and features.}
    gem.email       = "brian@burridge.net"
    gem.homepage    = "http://github.com/bburridge/Headstart"
    gem.authors     = ["Bran Burridge"]
    gem.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
    
    gem.add_dependency "mini_fb", '=1.1.3'
    gem.add_dependency "delayed_job", '=1.8.4'
    gem.add_dependency "mad_mimi_mailer", '=0.0.7'
    
    gem.add_development_dependency "shoulda", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

namespace :test do
  Rake::TestTask.new(:basic => ["check_dependencies",
                                "generator:cleanup",
                                "generator:headstart",
                                "generator:headstart_tests",
                                "generator:headstart_admin"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/{controllers,models}/*_test.rb"
    task.verbose = false
  end
end

generators = %w(headstart headstart_tests headstart_admin)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["test/rails_root/db/**/*"].each do |each|
      FileUtils.rm_rf(each)
    end
    
    FileUtils.rm_rf("test/rails_root/vendor/plugins/headstart")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    headstart_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s \"#{headstart_root}\" test/rails_root/vendor/plugins/headstart")
  end
  
  desc "Run the headstart generator"
  task :headstart do
    system "cd test/rails_root && ./script/generate headstart -f && ./script/generate delayed_job && rake gems:unpack && rake db:migrate db:test:prepare"
  end

  desc "Run the headstart tests generator"
  task :headstart_tests do
    system "cd test/rails_root && ./script/generate headstart_tests -f"
  end

  desc "Run the headstart admin generator"
  task :headstart_admin do
    system "cd test/rails_root && ./script/generate headstart_admin -f"
  end
  
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => ['test:basic']

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "Headstart #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
