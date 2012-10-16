namespace :cockroach do
  desc "Validate your Cockroach config before load it."
  task :validate, [:config_path] => [:environment] do |task, args|
    if Cockroach.config && args[:config_path]
      Cockroach.config.config_path = args[:config_path]
    elsif args[:config_path]
      Cockroach.setup do |c|
        c.config_path = args[:config_path]
      end
    end

    puts "Considering factory location as: #{Cockroach.config.fixtures_path || Cockroach::Config.root}"

    Cockroach.profiler.load
    puts "Config file is valid!"
  end

  desc "Run Cockroach generator"
  task :generate, [:config_path] => [:environment] do |task, args|
    Rake::Task["cockroach:validate"].invoke(args[:config_path])

    Cockroach.profiler.load!

    stats_collector = Cockroach::Statistics.new
    stats_collector.print_stats!
  end

  desc "Trancate the database, load seeds and run Cockroach generator"
  task :reload, [:config_path] => [:environment] do |task, args|
    args.with_defaults(:config_path => 'config/faker.yml')

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["cockroach:generate"].invoke(args[:config_path])
  end
end