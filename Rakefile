require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "mcnamara"
    s.description = s.summary = "Rack middleware to serve up browser version/platform specific css"
    s.email = "kuccello@gmail.com"
    s.homepage = "http://github.com/kuccello/Mcnamara"
    s.authors = ['Kristan "Krispy" Uccello']
    s.files = FileList["[A-Z]*", "{lib,test}/**/*"]
#    s.version = "0.3"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*-test.rb']
  t.verbose = true
end

require 'rake/rdoctask'
desc "Generate documentation"
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = 'rdoc'
end
