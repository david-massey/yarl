require_relative '../lib/yarl'

test_string = 'The quick brown fox jumps over the lazy dog.'

default_logger = YARL.new 'YARL Default Range', color: :cyan
default_logger.info test_string

range = 0..31
short_logger = YARL.new 'YARL Short Range', color: :green, message_range: range
short_logger.info test_string

long_logger = YARL.new 'YARL Long Range', color: :blue, message_range: 0...1024
long_logger.info test_string
