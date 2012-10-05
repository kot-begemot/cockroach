namespace :cockroach do
  desc "Validate your Cockroach config before load it."
  task :validate, [:config_path] => [:environment] do |task, args|
    args.with_defaults(:config_path => 'config/faker.yml')

    Cockroach.setup do |c|
      c.config_path = args[:config_path]
    end

    puts "Considering factory location as: #{Cockroach::Config.root}"

    @profile = Cockroach::FactoryGirl::Profiler.new
    @profile.load
    puts "Config file is valid!"
  end

  desc "Run Cockroach generator"
  task :generate, [:config_path] => [:environment] do |task, args|
    Rake::Task["cockroach:validate"].invoke(args[:config_path])

    @profile.load!
  end

  desc "Trancate the database, load seeds and run Cockroach generator"
  task :reload, [:config_path] => [:environment] do |task, args|
    args.with_defaults(:config_path => 'config/faker.yml')

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["cockroach:generate"].invoke(args[:config_path])
  end
end