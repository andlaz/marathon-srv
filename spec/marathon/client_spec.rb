require "spec_helper"
require "marathon/client_spec_fixtures"
require "marathon/srv/client"

describe Marathon::Srv::Client do
  
  describe "#intialize" do
    
    it "sets marathon api url" do
      
      client = Marathon::Srv::Client.new("foo", {})
      expect(client.marathon_api).to eq "foo"
      
    end
    
  end
  
  describe "#get_bridged_port_array" do
    
    it "raises on non-200 response code" do
      
      stub_request(:any, "http://example.tld/v2/apps/application-id").
        to_return(:status => 404)
        
      client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::Srv::InvalidResponseCodeError)
      
    end
    
    it "raises on invalid body" do
      
      stub_request(:any, "http://example.tld/v2/apps/application-id").
        to_return(:status => 200, :body => "definitely not json")
        
      client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})    
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::Srv::InvalidJSONResponseError)
      
    end
    
    it "raises on non docker containerizer application" do
      
      stub_request(:any, "http://example.tld/v2/apps/application-id").
        to_return(:status => 200, :body => Marathon::Srv::Fixtures::NON_DOCKER_APP_JSON)        

      client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})    
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::Srv::NotDockerContainerizedApplicationError)

      
    end
    
    it "raises on dockerized application with no running tasks" do
      
      stub_request(:any, "http://example.tld/v2/apps/application-id").
        to_return(:status => 200, :body => Marathon::Srv::Fixtures::NO_TASKS_APP_JSON)
        
      client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})          
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::Srv::NoRunningTasksFoundError)
      
    end
    
    context "when considering only healthy tasks" do
      
      it "raises on dockerized application with no health checks defined" do
        
        stub_request(:any, "http://example.tld/v2/apps/application-id").
          to_return(:status => 200, :body => Marathon::Srv::Fixtures::NO_HEALTHCHECK_APP_JSON)      
        
        client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})          
        expect { client.get_bridged_port_array "application-id", true }.to raise_error(Marathon::Srv::NoHealthChecksDefinedError)

      end
      
      it "returns empty array on dockerized application with no healthy tasks" do

        stub_request(:any, "http://example.tld/v2/apps/application-id").
          to_return(:status => 200, :body => Marathon::Srv::Fixtures::NO_HEALTHY_TASKS_APP_JSON)      
        
        client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})          
        expect(client.get_bridged_port_array "application-id", true).to eq([])
        
      end
      
      it "returns empty array on dockerized application with tasks failing some health checks" do
        stub_request(:any, "http://example.tld/v2/apps/application-id").
          to_return(:status => 200, :body => Marathon::Srv::Fixtures::SOME_TASK_FAILURES_APP_JSON)      
        
        client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})          
        expect(client.get_bridged_port_array "application-id", true).to eq([])        
      end
      
      it "returns ports only on healthy tasks" do
        stub_request(:any, "http://example.tld/v2/apps/application-id").
          to_return(:status => 200, :body => Marathon::Srv::Fixtures::SOME_HEALTHY_TASKS_APP_JSON)   
          
        client = Marathon::Srv::Client.new("http://example.tld/v2", {:log_level => Logger::DEBUG})          
        expect(client.get_bridged_port_array "application-id", true).to eq([{:host=>"slave-2", :services=>{"tcp"=>{5000=>30061, 5001=>30072}}}])        
                  
      end
      
      
    end
    
  end
  
end
