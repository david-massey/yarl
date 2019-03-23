require '../lib/yarl'

logger = YARL.new color: :green

def test_levels(logger)
  logger.fatal  "It's just a flesh wound!"
  logger.error  'PC LOAD LETTER'
  logger.warn   'Danger Will Robinson!'
  logger.info   'The more you know'
  logger.debug  'Better call Terminex'
  logger.spam   'Nobody likes spam'
end

puts "YARL logger level defaults to INFO"
test_levels logger

puts "\nAfter level changes to debug"
logger.level = :debug
test_levels logger

puts "\nAfter level changes to spam"
logger.level = :spam
test_levels logger
