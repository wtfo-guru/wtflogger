# frozen_string_literal: true

# more core and stlibs

require 'logging'

module Wtflogger
  #
  # @class Scribe
  class Scribe
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    def initialize(
      caller: 'wtf-unknown',
      level: :warn,
      screen: false,
      type: 'journal',
      group: 'wtfo',
      logfile: '/dev/null'
    )
      return unless @log.nil?

      #    Logging.init :debug, :info, :warn, :error, :fatal
      @log = Logging::Logger[caller]
      @log.level = level
      @log = Logging.logger[caller]

      if type == 'journal'
        type = 'syslog' unless File.directory?('/run/systemd/journal')
      end

      case type
      when 'journal'
        @log.add_appenders(
          Logging.appenders.journald(
            caller, :layout => Logging.layouts.pattern(:pattern => "%m\n"), # optional layout
                    :ndc => false, # log ndc hash values into custom journal fields (true by default)
                    :facility => ::Syslog::Constants::LOG_USER, # optional syslog facility
                    :extra => {} # extra custom journal fields
          )
        )
        Logging.mdc['LOGGROUP'] = group
      when 'syslog'
        @log.add_appenders(Logging.appenders.syslog(group, :ident => "#{caller} -"))
      when 'file'
        @log.add_appenders(Logging.appenders.file(group, :filename => logfile))
      else
        raise "Unsupported log type: #{type}" unless screen
      end

      @log.add_appenders(Logging.appenders.stdout) if screen
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/ParameterLists
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity

    def debug(message)
      @log.debug message
    end

    def info(message)
      @log.info message
    end

    def warn(message)
      @log.warn message
    end

    def error(message)
      @log.error message
    end

    def fatal(message)
      @log.fatal message
    end

    def unknown(message)
      @log.unknown message
    end
  end
end
