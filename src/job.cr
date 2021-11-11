require "dag"

module MapRunnerCr
  # Represents the status of a job.
  enum JobStatus
    Ready
    Running
    Successful
    Failed
    Timeout
  end

  # Represents the result of a job
  class Result
    property status : JobStatus
    property output : String
    property running_time : Int32

    def initialize(@status, @output, @running_time)
    end
  end

  # A job module. Every type of jobs should include this abstrat module.
  module Job
    getter name : String
    getter status = JobStatus::Ready
    getter description : String
    getter running_time = 0
    getter timeout : Int32
    getter dependencies = [] of Job

    def initialize(@name, @command, @description = "", @timeout = 0, dependencies = [] of Job); end

    def hash
      name.hash
    end

    def add_dependency(other : Job)
      dependencies << other
    end

    abstract def perform : Boolean

    def run
      @status = Status::Running
      puts "Job with id #{@id} is running..."
      result, output = perform
      if result.success?
        @status = Status::Successfull
      else
        @status = Status::Failed
      end
      puts "job with  id #{@id} is finished with status: #{@status}"
      {@status}
    end
  end

  class ConsoleJob
    include Job

    getter commands

    def initialize(@commands = [] of String)
    end

    def perform
      process = Process.new(@command, shell: true, output: Process::Redirect::Pipe)
      output = process.output.gets_to_end
      result = process.wait
      {result, output}
    end
  end
end
