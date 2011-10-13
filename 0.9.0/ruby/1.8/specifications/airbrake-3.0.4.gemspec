# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{airbrake}
  s.version = "3.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["thoughtbot, inc"]
  s.date = %q{2011-09-12}
  s.email = %q{support@airbrakeapp.com}
  s.files = [".gitignore", ".yardopts", "CHANGELOG", "Gemfile", "INSTALL", "MIT-LICENSE", "README.md", "README_FOR_HEROKU_ADDON.md", "Rakefile", "SUPPORTED_RAILS_VERSIONS", "TESTING.md", "airbrake.gemspec", "features/metal.feature", "features/rack.feature", "features/rails.feature", "features/rails_with_js_notifier.feature", "features/rake.feature", "features/sinatra.feature", "features/step_definitions/airbrake_shim.rb.template", "features/step_definitions/file_steps.rb", "features/step_definitions/metal_steps.rb", "features/step_definitions/rack_steps.rb", "features/step_definitions/rails_application_steps.rb", "features/step_definitions/rake_steps.rb", "features/support/airbrake_shim.rb.template", "features/support/env.rb", "features/support/matchers.rb", "features/support/rails.rb", "features/support/rake/Rakefile", "features/support/terminal.rb", "features/user_informer.feature", "generators/airbrake/airbrake_generator.rb", "generators/airbrake/lib/insert_commands.rb", "generators/airbrake/lib/rake_commands.rb", "generators/airbrake/templates/airbrake_tasks.rake", "generators/airbrake/templates/capistrano_hook.rb", "generators/airbrake/templates/initializer.rb", "install.rb", "lib/airbrake.rb", "lib/airbrake/backtrace.rb", "lib/airbrake/capistrano.rb", "lib/airbrake/configuration.rb", "lib/airbrake/notice.rb", "lib/airbrake/rack.rb", "lib/airbrake/rails.rb", "lib/airbrake/rails/action_controller_catcher.rb", "lib/airbrake/rails/controller_methods.rb", "lib/airbrake/rails/error_lookup.rb", "lib/airbrake/rails/javascript_notifier.rb", "lib/airbrake/rails3_tasks.rb", "lib/airbrake/railtie.rb", "lib/airbrake/rake_handler.rb", "lib/airbrake/sender.rb", "lib/airbrake/shared_tasks.rb", "lib/airbrake/tasks.rb", "lib/airbrake/user_informer.rb", "lib/airbrake/version.rb", "lib/airbrake_tasks.rb", "lib/rails/generators/airbrake/airbrake_generator.rb", "lib/templates/javascript_notifier.erb", "lib/templates/rescue.erb", "rails/init.rb", "script/integration_test.rb", "test/airbrake_2_2.xsd", "test/airbrake_tasks_test.rb", "test/backtrace_test.rb", "test/capistrano_test.rb", "test/catcher_test.rb", "test/configuration_test.rb", "test/helper.rb", "test/javascript_notifier_test.rb", "test/logger_test.rb", "test/notice_test.rb", "test/notifier_test.rb", "test/rack_test.rb", "test/rails_initializer_test.rb", "test/recursion_test.rb", "test/sender_test.rb", "test/user_informer_test.rb"]
  s.has_rdoc = nil
  s.homepage = %q{http://www.airbrakeapp.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Send your application errors to our hosted service and reclaim your inbox.}
  s.test_files = ["features/metal.feature", "features/rack.feature", "features/rails.feature", "features/rails_with_js_notifier.feature", "features/rake.feature", "features/sinatra.feature", "features/step_definitions/airbrake_shim.rb.template", "features/step_definitions/file_steps.rb", "features/step_definitions/metal_steps.rb", "features/step_definitions/rack_steps.rb", "features/step_definitions/rails_application_steps.rb", "features/step_definitions/rake_steps.rb", "features/support/airbrake_shim.rb.template", "features/support/env.rb", "features/support/matchers.rb", "features/support/rails.rb", "features/support/rake/Rakefile", "features/support/terminal.rb", "features/user_informer.feature", "test/airbrake_2_2.xsd", "test/airbrake_tasks_test.rb", "test/backtrace_test.rb", "test/capistrano_test.rb", "test/catcher_test.rb", "test/configuration_test.rb", "test/helper.rb", "test/javascript_notifier_test.rb", "test/logger_test.rb", "test/notice_test.rb", "test/notifier_test.rb", "test/rack_test.rb", "test/rails_initializer_test.rb", "test/recursion_test.rb", "test/sender_test.rb", "test/user_informer_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_development_dependency(%q<activerecord>, ["~> 2.3.8"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_development_dependency(%q<bourne>, [">= 1.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.10.6"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_development_dependency(%q<capistrano>, ["~> 2.8.0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_dependency(%q<activerecord>, ["~> 2.3.8"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_dependency(%q<bourne>, [">= 1.0"])
      s.add_dependency(%q<cucumber>, ["~> 0.10.6"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_dependency(%q<capistrano>, ["~> 2.8.0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
    s.add_dependency(%q<activerecord>, ["~> 2.3.8"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
    s.add_dependency(%q<bourne>, [">= 1.0"])
    s.add_dependency(%q<cucumber>, ["~> 0.10.6"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
    s.add_dependency(%q<capistrano>, ["~> 2.8.0"])
  end
end
