require 'logger'

class YARL < Logger # Yet Another Ruby Logger
  module Severity
    include Logger::Severity

    # Normal but significant conditions
    # Conditions that are not error/warning conditions, but that may require special handling.
    NOTICE = 1.5

    # For that time you need more messages that annoy the hell out of everyone else.
    # These should rarely -- if ever -- be displayed.
    SPAM = -1
  end

  include Severity

  def initialize progname = nil, **kwargs
    destination = kwargs[:destination] || STDOUT
    super destination

    @progname = progname.nil? ? self.class : progname
    @level    = kwargs[:level] || INFO

    # Header colors
    color       =       text_color(kwargs[:color] || kwargs[:header])
    background  = background_color(kwargs[:background])
    @header     = format_code color, background

    # Default body colors
    @body       =       text_color(kwargs[:body])

    # Automatic body colors
    @fatal_body = background_color(kwargs[:fatal] || kwargs[:fatal_color] || :red)
    @error_body =       text_color(kwargs[:error] || kwargs[:error_color] || :red)
    @warn_body  =       text_face (kwargs[:warn]  || kwargs[:warn_face]   || :bold)
    @spam_body  =       text_color(kwargs[:spam]  || kwargs[:spam_color]  || :bright_black)

    # Log formatting
    @datetime_format = kwargs[:datetime_format] || '%Y-%m-%dT%H:%M:%S.%3NZ'
    if kwargs[:ascii8bit]
      @to_hex_regex = /([^ -~])/no
    elsif !(kwargs[:printable] === false)
      @to_hex_regex = /([\x00-\x19])/o
    end

    if kwargs[:formatter].is_a?(Proc)
      @formatter = kwargs[:formatter]
    else
      @formatter ||= proc { |severity, datetime, progname, message|
        datetime = datetime.strftime(@datetime_format)
        "\e[#{@header}m#{datetime} #{severity[0]} #{progname}\e[#{@body}m #{message}\e[0m\n"
      }
    end
  end

  # A basic rewrite of Logger.add to support message body colors.
  def add severity, message = nil, progname = nil
    severity ||= UNKNOWN
    return true if @logdev.nil? or severity < @level

    progname  ||= @progname
    message   ||= block_given? ? yield : progname

    progname = @progname if message == progname

    message = message.gsub(@to_hex_regex) {|c| "[%02X]" % c.ord} if @to_hex_regex

    case severity
    when FATAL
      message = "\e[#{@fatal_body}m#{message}"
    when ERROR
      message = "\e[#{@error_body}m#{message}"
    when WARN
      message = "\e[#{@warn_body}m#{message}"
    when SPAM
      message = "\e[#{@spam_body}m#{message}"
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

  # SPAM and NOTICE support
  # Add to level setter
  def level= severity
    severity = severity.to_s if severity.is_a?(Symbol)

    case severity
    when 'notice'
      @level = NOTICE
    when 'spam'
      @level = SPAM
    else
      super
    end
  end

  # Returns +true+ iff the current severity level allows
  def notice?; @level <= NOTICE; end
  def spam?; @level <= SPAM; end

  # Sets the severity to SPAM.
  def notice!; self.level = NOTICE; end
  def spam!; self.level = SPAM; end

  # Log a +NOTICE+ message.
  def notice progname = nil, &block
    add(NOTICE, nil, progname, &block)
  end
  # Log a +SPAM+ message.
  def spam progname = nil, &block
    add(SPAM, nil, progname, &block)
  end

  private

  SEV_LABEL = {
    SPAM    => 'SPAM',
    DEBUG   => 'DEBUG',
    INFO    => 'INFO',
    NOTICE  => 'NOTICE',
    WARN    => 'WARN',
    ERROR   => 'ERROR',
    FATAL   => 'FATAL',
    UNKNOWN => 'UNKWN'
  }

  def format_severity severity
    SEV_LABEL[severity] || 'ANY'
  end

  def format_code color, background = 0
    if color > 0 && background > 0
      "#{color};#{background}"
    elsif color > 0
      "#{color}"
    elsif background > 0
      "#{background}"
    else
      '0'
    end
  end

  # Font Face Methods
  def text_face mode
    return FACE_MODES[mode]
  end

  FACE_MODES = {
    :reset      => 0,
    :bold       => 1,
    :underscore => 4,
    :blink      => 5 # Please don't...
  }

  # Color Methods
  def text_color color
    return (COLOR_CODES[color] || 67) + 30 if color
    return 0
  end

  def background_color color
    return (COLOR_CODES[color] ||  0) + 40 if color
    return 0
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
