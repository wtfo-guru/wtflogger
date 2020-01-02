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
        usage: #{@basenm} [-d] [-e] [-f] [-h] [-m] [-n] [-s caller] [-w] [-v] [-V] message
          where:
            -d|--debug         - specify debug mode
            -e|--error         - specify error message type
            -f|--fatal         - specify fatal message type
            -h|--help          - show this message and exit
            -m|--info          - specify info message type
            -n|--notice        - specify notice message type
            -s|--script caller - specify caller name (defaults to wtflogger)
            -w|--warn          - specify warn message type
            -v|--verbose       - add verbosity
            -V|--version       - show version and exit

              default message type is warn
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

      if ARGV.size.positive?
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

        case type
        when 4
          logger.fatal ARGV[0]
        when 3
          logger.error ARGV[0]
        when 2
          logger.warn ARGV[0]
        when 1
          logger.info ARGV[0]
        else
          logger.debug ARGV[0]
        end
        0
      else
        1
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
