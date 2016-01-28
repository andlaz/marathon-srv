require "spec_helper"
require "marathon/client"

describe Marathon::Client do
  
  APP_JSON = '{
    "app": 
    {
      "container": 
      {
        "type": "DOCKER",
        "docker": 
        {
          "portMappings": 
          [
            {
              "containerPort": 5000,
              "protocol": "tcp"
            },
  
            {
              "containerPort": 5001,
              "protocol": "tcp"
            }
          ]
        }
      },
  
      "healthchecks": 
      [
        {
          "path": "/",
          "protocol": "TCP",
          "portIndex": 0,
          "gracePeriodSeconds": 120,
          "intervalSeconds": 15,
          "timeoutSeconds": 5,
          "maxConsecutiveFailures": 0,
          "ignoreHttp1xx": false
        }
      ],
  
      "tasks": 
      [
        {
          "healthCheckResults": 
          [
            {
              "alive": true
            }
          ],
  
          "host": "slave-1",
          "ports": 
          [
            30051,
            30052
          ]
        }
      ]
    }
  }'
  
  NON_DOCKER_APP_JSON = '{
    "app": 
    {
      "container": 
      {
        "type": "NOTDOCKER!"
      }
    }
  }'
  
  NO_TASKS_APP_JSON = '{
    "app": 
    {
      "container": 
      {
        "type": "DOCKER",
        "docker": 
        {
          "portMappings": 
          [
            {
              "containerPort": 5000,
              "protocol": "tcp"
            },
  
            {
              "containerPort": 5001,
              "protocol": "tcp"
            }
          ]
        }
      },
  
      "tasks": []
    }
  }'
  
  NO_HEALTHCHECK_APP_JSON = '{
    "app": 
    {
      "container": 
      {
        "type": "DOCKER",
        "docker": 
        {
          "portMappings": 
          [
            {
              "containerPort": 5000,
              "protocol": "tcp"
            },
  
            {
              "containerPort": 5001,
              "protocol": "tcp"
            }
          ]
        }
      },

      "healthchecks": [],
      
      "tasks": 
      [
        {
          "healthCheckResults": 
          [],
  
          "host": "slave-1",
          "ports": 
          [
            30051,
            30052
          ]
        }
      ]
    }
  }'  
  
  NO_HEALTHY_TASKS_APP_JSON = '{
    "app": 
    {
      "container": 
      {
        "type": "DOCKER",
        "docker": 
        {
          "portMappings": 
          [
            {
              "containerPort": 5000,
              "protocol": "tcp"
            },
  
            {
              "containerPort": 5001,
              "protocol": "tcp"
            }
          ]
        }
      },

      "healthchecks": 
      [
        {
          "path": "/",
          "protocol": "TCP",
          "portIndex": 0,
          "gracePeriodSeconds": 120,
          "intervalSeconds": 15,
          "timeoutSeconds": 5,
          "maxConsecutiveFailures": 0,
          "ignoreHttp1xx": false
        }
      ],
      
      "tasks": 
      [
        {
          "healthCheckResults": 
          [
            {
              "alive": false
            }
          ],
  
          "host": "slave-1",
          "ports": 
          [
            30051,
            30052
          ]
        }
      ]
    }
  }'
  
  describe "#intialize" do
    
    it "sets marathon api url" do
      
      client = Marathon::Client.new("foo", {})
      expect(client.marathon_api).to eq "foo"
      
    end
    
  end
  
  describe "#get_bridged_port_array" do
    
    it "raises on non-200 response code" do
      
      stub_request(:any, "http://example.tld/v2/api/apps/application-id").
        to_return(:status => 404)
        
      client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::InvalidResponseCodeError)
      
    end
    
    it "raises on invalid body" do
      
      stub_request(:any, "http://example.tld/v2/api/apps/application-id").
        to_return(:status => 200, :body => "definitely not json")
        
      client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})    
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::InvalidJSONResponseError)
      
    end
    
    it "raises on non docker containerizer application" do
      
      stub_request(:any, "http://example.tld/v2/api/apps/application-id").
        to_return(:status => 200, :body => NON_DOCKER_APP_JSON)        

      client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})    
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::NotDockerContainerizedApplicationError)

      
    end
    
    it "raises on dockerized application with no running tasks" do
      
      stub_request(:any, "http://example.tld/v2/api/apps/application-id").
        to_return(:status => 200, :body => NO_TASKS_APP_JSON)
        
      client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})          
      expect { client.get_bridged_port_array "application-id" }.to raise_error(Marathon::NoRunningTasksFoundError)
      
    end
    
    context "when considering only healthy tasks" do
      
      it "raises on dockerized application with no health checks defined" do
        
        stub_request(:any, "http://example.tld/v2/api/apps/application-id").
          to_return(:status => 200, :body => NO_HEALTHCHECK_APP_JSON)      
        
        client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})          
        expect { client.get_bridged_port_array "application-id", true }.to raise_error(Marathon::NoHealthChecksDefinedError)


      end
      
      it "returns empty array on dockerized application with no healthy tasks" do

        stub_request(:any, "http://example.tld/v2/api/apps/application-id").
          to_return(:status => 200, :body => NO_HEALTHY_TASKS_APP_JSON)      
        
        client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})          
        expect(client.get_bridged_port_array "application-id", true).to eq([])
        
      end
      
      it "returns ports only on healthy tasks" do
        
      end
      
      
    end
    
    
    it "returns port array" do
      
      stub_request(:any, "http://example.tld/v2/api/apps/application-id").
        to_return(:status => 200, :body => APP_JSON)  
        
      client = Marathon::Client.new("http://example.tld/v2/api", {:log_level => Logger::DEBUG})  
      expect(client.get_bridged_port_array "application-id").to eq([{:host=>"slave-1", :services=>{"tcp"=>{5000=>30051, 5001=>30052}}}])
      
    end
    
  end
  
end
