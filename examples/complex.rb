require 'yarl'

module Some
  class Klass
    attr_accessor :logger

    def initialize
      @logger = YARL.new\
        self.class,
        destination: STDERR,
        color: :bright_magenta,
        datetime_format: '%H:%M:%S.%6NZ',
        spam_color: :black # I *never* want to see SPAM
    end

    def add(x, y)
      @logger.spam { x + y }
      x + y
    end
  end
end

complex = Some::Klass.new
complex.logger.info complex.add('Hello, ', 'World!')
