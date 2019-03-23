# YARL - Yet Another Ruby Logger
YARL is a [ruby/logger](https://github.com/ruby/logger) extension that provides:
- Full [ANSI 4-bit color](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) support
- SPAM -- a severity level lower than DEBUG
- Clean, low-clutter formatting
- Common defaults, like writing to STDOUT

As an extension, `logger` is fully implemented.

## Color Support
YARL supports 4-bit ANSI colors -- both text and background -- in the logger header.

![[citation needed]](../master/media/tests_colors.png?raw=true)

Additionally, the following severity levels have message colors:
- `FATAL` has a background color -- defaults to red
- `ERROR` has a text color -- defaults to red
- `SPAM` has a text color -- defaults to bright black

![Levels and their colors](../master/media/tests_levels.png?raw=true)

## Installation
Add this line to your application's Gemfile:

`gem 'yarl'`

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install yarl`

## Usage

### Simple Example

```ruby
require 'yarl'

logger = YARL.new "Simple Example", color: :green
logger.info "Hello, World!"
```

will produce
![A simple example](../master/media/examples_simple.png?raw=true)

### Complex Example

Please see [examples/complex.rb](../master/examples/complex.rb) for the source code.

This example will produce
![A complex example](../master/media/examples_complex.png?raw=true)

## Contributing

Feel free to [make an issue](https://github.com/david-massey/yarl/issues/new), and I will do my best to respond quickly.

Or, fork it, edit it, and pull request.

