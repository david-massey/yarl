require_relative '../lib/yarl'

logger = YARL.new color: :green

def test_levels(logger)
  logger.fatal  "It's just a flesh wound!"
  logger.error  'PC LOAD LETTER'
  logger.warn   'Here there be dragons!'
  logger.notice 'In order to build a hyperspatial express route, Earth will be destroyed.'
  logger.info   'The more you know'
  logger.debug  'Better call Terminix'
  logger.spam   "Nobody likes spam\r\n"
end

puts "YARL logger level defaults to INFO"
test_levels logger

puts "\nAfter level changes to debug"
logger.level = :debug
test_levels logger

puts "\nAfter level changes to spam"
logger.level = :spam
test_levels logger
