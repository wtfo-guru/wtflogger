# frozen_string_literal: true

require 'wtflogger/version'
#
# #module Wtflogger
#
module Wtflogger
  class Error < StandardError; end

  def self.main(basenm)
    ## NB: only load (require) cli code if called
    require 'wtflogger/cli/runner'

    # allow env variable to set RUBYOPT-style default command line options
    #   e.g. -o site
    env_opts = ENV['WTFLOGGER']

    if env_opts
      env_opts.split.reverse.each do |a|
        ARGV.unshift a
      end
    end

    Runner.new.run basenm
  end
end
