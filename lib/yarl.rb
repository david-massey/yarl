require 'logger'

class YARL < Logger # Yet Another Ruby Logger
  module Severity
    include Logger::Severity

    # For that time you need more messages that annoy the hell out of everyone else.
    # These should rarely -- if ever -- be displayed.
    SPAM = -1
  end

  include Severity

  def initialize(progname = nil, **kwargs)
    destination = kwargs[:destination] || STDOUT
    super destination

    @progname  = progname.nil? ? self.class : progname
    @level = kwargs[:level] || INFO

    # Header colors
    @color      =       text_color(kwargs[:color] || :light_white)
    @background = background_color(kwargs[:background] || :black)

    # Body colors
    @fatal_color = background_color(kwargs[:fatal_color] || :red)
    @error_color =       text_color(kwargs[:error_color] || :red)
    @spam_color  =       text_color(kwargs[:spam_color]  || :bright_black)

    # Log formatting
    @datetime_format = kwargs[:datetime_format] || '%Y-%m-%dT%H:%M:%S.%3NZ'

    if kwargs[:formatter].is_a?(Proc)
      @formatter = kwargs[:formatter]
    else
      @formatter ||= proc { |severity, datetime, progname, message|
        datetime = datetime.strftime(@datetime_format)
        "\e[#{@color};#{@background}m#{datetime} #{severity[0]} #{progname}\e[0m #{message}\n"
      }
    end
  end

  # A basic rewrite of Logger.add to support message body colors.
  def add(severity, message = nil, progname = nil)
    severity ||= UNKNOWN
    return true if @logdev.nil? or severity < @level

    progname  ||= @progname
    message   ||= block_given? ? yield : progname

    progname = @progname if message == progname

    case severity
    when FATAL
      message = "\e[#{@fatal_color}m#{message}\e[0m"
    when ERROR
      message = "\e[#{@error_color}m#{message}\e[0m"
    when SPAM
      message = "\e[#{@spam_color}m#{message}\e[0m"
    end

    @logdev.write(
      format_message(
        format_severity(severity),
        Time.now.utc,
        progname,
        message
      )
    )

    true
  end

  # SPAM support
  # Add SPAM to level setter
  def level=(severity)
    severity = severity.to_s if severity.is_a?(Symbol)

    case severity
    when 'spam'
      @level = SPAM
    else
      super
    end
  end

  # Returns +true+ iff the current severity level allows for the printing of SPAM
  def spam?; @level <= SPAM; end

  # Sets the severity to SPAM.
  def spam!; self.level = SPAM; end

  # Log a +DEBUG+ message.
  def spam(progname = nil, &block)
    add(SPAM, nil, progname, &block)
  end

  private

  SEV_LABEL = {
    SPAM    => 'SPAM',
    DEBUG   => 'DEBUG',
    INFO    => 'INFO',
    WARN    => 'WARN',
    ERROR   => 'ERROR',
    FATAL   => 'FATAL',
    UNKNOWN => 'UNKWN'
  }

  def format_severity(severity)
    SEV_LABEL[severity] || 'ANY'
  end

  # Color Methods
  def text_color(color)
    (COLOR_CODES[color] || 67) + 30
  end

  def background_color(color)
    (COLOR_CODES[color] ||  0) + 40
  end

  COLOR_CODES = {
    :black    => 0, :bright_black   => 60,
    :red      => 1, :bright_red     => 61,
    :green    => 2, :bright_green   => 62,
    :yellow   => 3, :bright_yellow  => 63,
    :blue     => 4, :bright_blue    => 64,
    :magenta  => 5, :bright_magenta => 65,
    :cyan     => 6, :bright_cyan    => 66,
    :white    => 7, :bright_gray    => 67,
  }
end
