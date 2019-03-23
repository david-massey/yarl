require 'yarl'

module Mocks
  class Klass
    def initialize(**kwargs)
      if kwargs.empty?
        klass_color = self.class.to_s.split('::')[1]
        color = klass_color.downcase.sub(/\Abright/, 'bright_').to_sym
      end

      color ||= kwargs[:color] || :invalid
      background = kwargs[:background] || :invalid

      @logger = YARL.new self.class, color: color, background: background
      @logger.info "Initialized"
    end
  end

  class Black         < Klass ; end
  class BrightBlack   < Klass ; end
  class White         < Klass ; end
  class BrightWhite   < Klass ; end
  class Red           < Klass ; end
  class BrightRed     < Klass ; end
  class Green         < Klass ; end
  class BrightGreen   < Klass ; end
  class Yellow        < Klass ; end
  class BrightYellow  < Klass ; end
  class Blue          < Klass ; end
  class BrightBlue    < Klass ; end
  class Magenta       < Klass ; end
  class BrightMagenta < Klass ; end
  class Cyan          < Klass ; end
  class BrightCyan    < Klass ; end
end

# Text Colors
Mocks::Klass.new
Mocks::Black.new
Mocks::BrightBlack.new
Mocks::White.new
Mocks::BrightWhite.new
Mocks::Red.new
Mocks::BrightRed.new
Mocks::Green.new
Mocks::BrightGreen.new
Mocks::Yellow.new
Mocks::BrightYellow.new
Mocks::Blue.new
Mocks::BrightBlue.new
Mocks::Magenta.new
Mocks::BrightMagenta.new
Mocks::Cyan.new
Mocks::BrightCyan.new

# Background Colors
Mocks::Black.new          background: :black
Mocks::BrightBlack.new    background: :bright_black
Mocks::White.new          background: :white
Mocks::BrightWhite.new    background: :bright_white
Mocks::Red.new            background: :red
Mocks::BrightRed.new      background: :bright_red
Mocks::Green.new          background: :green
Mocks::BrightGreen.new    background: :bright_green
Mocks::Yellow.new         background: :yellow
Mocks::BrightYellow.new   background: :bright_yellow
Mocks::Blue.new           background: :blue
Mocks::BrightBlue.new     background: :bright_blue
Mocks::Magenta.new        background: :magenta
Mocks::BrightMagenta.new  background: :bright_magenta
Mocks::Cyan.new           background: :cyan
Mocks::BrightCyan.new     background: :bright_cyan
