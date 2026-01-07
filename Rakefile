begin
  require 'voxpupuli/test/rake'
rescue LoadError
  begin
    require 'puppetlabs_spec_helper/rake_tasks'
  rescue LoadError
  end
end

# flag out some things we never use
Rake::Task["strings:gh_pages:update"].clear

# vim: syntax=ruby
