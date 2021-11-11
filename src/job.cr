require "dag"

module MapRunnerCr

    # Represents the status of a job.
    enum JobStatus
        Ready
        Running
        Successful
        Failed
        Timeout
        Skipped
    end

    # Represents the result of a job
    class Result
        #Return status of a Job
        property status : JobStatus
        #Output buffer of a Job
        property output : String
        #Running time in milliseconds
        property running_time : UInt64

        def initialize(@status, @output, @running_time)
        end
    end
    
    #A job module. Every type of jobs should include this abstrat module. 
    module Job
        getter name : String
        getter description : String
        getter running_time = 0 
        getter dependencies : Array(Job)

        getter status = JobStatus::Ready
        getter timeout : Int32 

        def initialize(@name, @description = "", @timeout=0, @dependencies = [] of Job); end

        def hash
            name.hash
        end

        def add_dependency( other : Job)
            dependencies << other
        end

        abstract def perform : {Process::Status, String }

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
            Result.new(@status, output, 0)
        end
    end

    class ConsoleJob
        include Job

        getter commands
        
        def initialize( @name, @commands = [] of String, @description = "", @timeout=0, @dependencies = [] of Job)
        end

        def perform : Tuple(Process::Status, String)
            process = Process.new(@command, shell: true, output: Process::Redirect::Pipe)
            output = process.output.gets_to_end
            status =  process.wait
            {status, output}
        end
    end
end