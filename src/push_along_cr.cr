require "kemal"
require "./job"

# TODO: Write documentation for `PushAlong`
module PushAlong
  VERSION = "0.1.0"

  # TODO: Put your code here
end

get "/" do
  "Hello World!"
end

Kemal.run
