module ArtirixFaker
  class Railtie < ::Rails::Railtie
    rake_tasks do
      desc "Generates the Faked data for teh database"
      task :artirix => :environmant do
        puts "You're in my_gem"
      end
    end
  end
end
