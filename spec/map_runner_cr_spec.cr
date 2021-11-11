require "./spec_helper"

describe "Map_Runner_Cr" do
  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "Hello World!"
  end
end
