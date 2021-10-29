require "dag"

module MapRunnerCr

    enum JobStatus
        Ready
        Running
        Successful
        Failed
    end

    class Job
        property status = JobStatus::Ready
        property name : String
        property command : String  
        property description : String

        def initialize(@name, @command, @description = ""); end

        def hash
            name.hash
        end

        def run
            @status = Status::Running
            puts "Job with id #{@id} is running with command  (#{@command})..."
            process = Process.new(@command, shell: true, output: Process::Redirect::Pipe)
            output = process.output.gets_to_end
            result = process.wait
            if result.success?
              @status = Status::Successfull
            else
              @status = Status::Failed
            end
            puts "job with  id #{@id} is finished with status: #{@status} Output: \n#{output}"
            {@status}
        end


    end

    class Map
        property name : String
        jobs = Dag::Graph(Job).new     

        def initialize(@name)
        end

        
    end
end