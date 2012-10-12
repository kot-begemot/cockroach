# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cockroach"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["E-Max"]
  s.date = "2012-10-12"
  s.description = "In order to simplify the life of the Artirix developers, this gem was build.\n  It allows to generate the data, and fill teh database with fake records."
  s.email = "max.zab@artirix.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rvmrc",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "cockroach.gemspec",
    "lib/cockroach.rb",
    "lib/cockroach/base/load_nodes.rb",
    "lib/cockroach/base/node.rb",
    "lib/cockroach/base/node_structure.rb",
    "lib/cockroach/config.rb",
    "lib/cockroach/config/loader.rb",
    "lib/cockroach/fixtures/factory_girl.rb",
    "lib/cockroach/fixtures/factory_girl/loader.rb",
    "lib/cockroach/fixtures/factory_girl/node.rb",
    "lib/cockroach/fixtures/factory_girl/profiler.rb",
    "lib/cockroach/railtie.rb",
    "lib/cockroach/source.rb",
    "lib/cockroach/source/model.rb",
    "lib/cockroach/source/node.rb",
    "lib/cockroach/version.rb",
    "lib/generators/cockroach/install_generator.rb",
    "lib/generators/cockroach/templates/cockroach.rb",
    "lib/generators/cockroach/templates/faker.yml",
    "lib/tasks/faker.rake",
    "test/config/config_test.rb",
    "test/config/loader_test.rb",
    "test/fixturers/factory_girl/aliasing_test.rb",
    "test/fixturers/factory_girl/loading_test.rb",
    "test/fixturers/factory_girl/node_test.rb",
    "test/fixturers/factory_girl/profiler_test.rb",
    "test/fixturers/source_test.rb",
    "test/generators/install_generator_test.rb",
    "test/support/active_record.rb",
    "test/support/data/correct_with_option.yml",
    "test/support/data/correct_without_option.yml",
    "test/support/data/dummy_structure/config/faker.yml",
    "test/support/data/dummy_structure/config/user_only.yml",
    "test/support/data/dummy_structure/config/witness.yml",
    "test/support/data/dummy_structure/test/factories/user_factory.rb",
    "test/support/database_cleaner.rb",
    "test/support/factory_girl_mocked.rb",
    "test/support/models/user.rb",
    "test/test_helper.rb"
  ]
  s.homepage = "http://google.it"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "This gem allows one to fake all the date for the Artirix project"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<faker>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<faker>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<faker>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
  end
end

