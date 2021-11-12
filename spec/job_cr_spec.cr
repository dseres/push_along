require "./spec_helper"

 
describe PushAlong do
  describe ConsoleJob do
    describe ".new" do
      it "A new job having proper values" do
        job = ConsoleJob.new("First job", ["echo 1"], "This job is for unit testing. It will echo only '1'" )
        job.is_a?(Job).should be_true
      end
    end
  end
end
