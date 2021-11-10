require "dag"

module MapRunnerCr

    # Represents the status of a job.
    enum JobStatus
        Ready
        Running
        Successful
        Failed
    end
    
    #A job module. Every type of jobs should include this abstrat module. 
    module Job
        getter status = JobStatus::Ready
        getter name : String
        getter command : String  
        getter description : String
        
        getter running_time = 0 
        getter timeout : Int32 
        

        def initialize(@name, @command, @description = "", @timeout=0); end

        def hash
            name.hash
        end

        abstract def perform : Boolean

        def run
            @status = Status::Running
            puts "Job with id #{@id} is running..."
            result = perform
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

        def perform
            process = Process.new(@command, shell: true, output: Process::Redirect::Pipe)
            output = process.output.gets_to_end
            process.wait
        end
    end
end