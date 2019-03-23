require 'logger'
require 'yarl'

times = 1_000_000

def benchmark(method, times = 1000)
  destination = STDOUT

  start_time = Time.now

  case method
  when :puts
    (1..times).each do |message_number|
      puts "puts Message #{message_number}"
    end
  when :logger
    logger = Logger.new(destination)

    (1..times).each do |message_number|
      logger.info "logger Message #{message_number}"
    end
  when :yarl
    yarl = YARL.new "YARL"

    (1..times).each do |message_number|
      yarl.info "yarl Message #{message_number}"
    end
  when :yarl_color
    yarl = YARL.new "YARL", color: :blue

    (1..times).each do |message_number|
      yarl.info "yarl Message #{message_number}"
    end
  when :destination
    (1..times).each do |message_number|
      destination << "#{destination} << Message #{message_number}\n"
    end
  end

  end_time = Time.now

  return end_time - start_time
end

elapsed = {}
elapsed[:puts]        = benchmark(:puts, times)
elapsed[:logger]      = benchmark(:logger, times)
elapsed[:yarl]        = benchmark(:yarl, times)
elapsed[:yarl_color]  = benchmark(:yarl_color, times)
elapsed[:stdout]      = benchmark(:destination, times)

shortest = elapsed.values.min
puts "#{times} messages. #{elapsed.key shortest} took the least time (#{shortest}s)."
puts "puts        => #{elapsed[:puts]}s"        # =>  4.348134s
puts "logger      => #{elapsed[:logger]}s"      # => 11.266948s
puts "yarl        => #{elapsed[:yarl]}s"        # => 10.685384s
puts "yarl_color  => #{elapsed[:yarl_color]}s"  # => 10.699868s
puts "`STDOUT <<` => #{elapsed[:stdout]}s"      # =>  5.835941s
