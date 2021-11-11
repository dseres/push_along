require "dag"
require "job"

module MapRunnerCr
  class Map
    property name : String
    jobs = Dag::Graph(Job).new

    def initialize(@name)
    end
  end
end
