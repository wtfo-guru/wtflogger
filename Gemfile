source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def check_for_journal
  return false if ENV['NEEDS_JOURNAL'] == 'no'
  return false unless RUBY_PLATFORM =~ /linux/
  
  File.directory?('/run/systemd/journal')
end

journal_require = check_for_journal

gem 'logging-journald', require: journal_require

# Specify your gem's dependencies in wtflogger.gemspec
gemspec
