# frozen_string_literal: true

# more core and stlibs

require 'getoptlong'

# our own code

require 'wtflogger/scribe'

module Wtflogger
  # @class Runner
  class Runner
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def run(basenm)
      opts = GetoptLong.new(
        ['--debug', '-d', GetoptLong::NO_ARGUMENT],
        ['--verbose', '-v', GetoptLong::NO_ARGUMENT],
        ['--script', '-s', GetoptLong::REQUIRED_ARGUMENT],
        ['--error', '-e', GetoptLong::NO_ARGUMENT],
        ['--info', '-m', GetoptLong::NO_ARGUMENT],
        ['--loud', '-l', GetoptLong::NO_ARGUMENT],
        ['--notice', '-n', GetoptLong::NO_ARGUMENT],
        ['--warn', '-w', GetoptLong::NO_ARGUMENT],
        ['--version', '-V', GetoptLong::NO_ARGUMENT],
        ['--help', '--man', '-h', GetoptLong::NO_ARGUMENT]
      )

      type = 2 # default to warn level
      cscript = nil
      debug = verbose = loud = false

      # rubocop:disable Metrics/BlockLength
      opts.each do |opt, arg|
        case opt
        when '--help'
          puts <<-USG
        usage: #{@basenm} [-d] [-e] [-f] [-h] [-m] [-n] [-s script] [-v] [-V] message
          where:
            -d|--debug         - specify debug mode
            -e|--error         - specify error message type
            -f|--fatal         - specify fatal message type
            -h|--help          - show this message and exit
            -m|--info          - specify info message type
            -n|--notice        - specify notice message type
            -s|--script caller - specify caller name
            -v|--verbose       - add verbosity
            -V|--version       - show version and exit
          USG
          exit 0
        when '--loud'
          loud = true
        when '--info'
          type = 1
        when '--notice'
          type = 2
        when '--warn'
          type = 2
        when '--error'
          type = 3
        when '--fatal'
          type = 4
        when '--version'
          puts "#{basenm} #{VERSION}"
          exit 0
        when '--script'
          cscript = arg
        when '--verbose'
          verbose = true
        when '--debug'
          debug = true
          verbose = true
        end
      end
      # rubocop:enable Metrics/BlockLength

      caller = cscript.nil? ? basenm : cscript

      level = if debug
                'debug'
              elsif verbose
                'info'
              else
                'warn'
              end

      loud ||= STDOUT.isatty
      logger = Scribe.new(:caller => caller, :level => level, :screen => loud)
      logger.warn "#{basenm} You have been warned."
      logger.info "#{basenm} You have been informed."
      logger.debug "#{basenm} Done."
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
