require "spec_helper"
require "marathon/srv/client"
require "marathon/srv/cli"

describe Marathon::Srv::CLI do

  describe "#find" do
    
    it "json encodes client#find object response" do
      
      client = class_double("Marathon::Srv::Client")
      cli = Marathon::Srv::CLI.new
      
      cli.options = {
        :marathon => "http://domain.tld",
        :app_id => "foo",
        :container_port => 1234
      }
      
       
      
      
    end
    
  end

end