require "uri"
require "net/http"
require "logger"
require "rubygems"
require "json"

module Marathon
  
  module Srv
  
  class InvalidResponseCodeError < Exception; end
  class NoRunningTasksFoundError < Exception; end
  class NotDockerContainerizedApplicationError < Exception; end
  class NoHealthChecksDefinedError < Exception; end
  class InvalidJSONResponseError < Exception; end
  
    class Client    
      
      API_VERSION = "v2"
      
      PATH_FIND_APP = "/#{API_VERSION}/apps/%s"
      
      attr_reader :marathon_api
      
      def initialize(marathon_api_url, options = {})
        
        @marathon_api = marathon_api_url
        
        @logger = Logger.new(STDOUT)
        @logger.level = options[:log_level] || Logger::ERROR
        
        @logger.debug "Initialized with options #{options}"
        
      end
      
      def get_bridged_port_array(application_id, healthy_tasks_only=false)
        
        @logger.debug "Attempting to fetch application #{application_id} object from API, healthy_tasks_only: #{healthy_tasks_only} "
  
        api = URI::join(marathon_api, PATH_FIND_APP % application_id)
        Net::HTTP.new(api.host, api.port).start do |http|
          
          response = http.request Net::HTTP::Get.new api
          @logger.debug "Received response: #{response}"
          
          raise Marathon::Srv::InvalidResponseCodeError.new response.code unless response.code == "200"
          
          # parse JSON
          begin
            @logger.debug "Parsing body #{response.body}"
            app = (JSON response.body)["app"]
            
            @logger.debug "Retrieved app object #{app}"
            
            raise Marathon::Srv::NotDockerContainerizedApplicationError.new unless app["container"]["type"] == "DOCKER"
            raise Marathon::Srv::NoRunningTasksFoundError.new unless app["tasks"].size > 0
            raise Marathon::Srv::NoHealthChecksDefinedError.new unless app["healthchecks"].size > 0
            
            # collect slave ports of (healthy) tasks
            ports=[]
            app["tasks"].each do |task|
              
              if(healthy_tasks_only)
                @logger.debug "Verifying health checks for task #{task}"
                # all health checks must be passing
                passing=true
                task["healthCheckResults"].each do |health_check_result|
                  (passing=false; @logger.debug "%s has failing health check, not considering it" % task; break) unless health_check_result["alive"] == true
                  
                end
                @logger.debug "All health checks passing - filtering ports for task #{task}"
                ports.push filter_ports(app, task) if passing
                
              else
                # just add task
                @logger.debug "Ignoring health checks - filtering ports for task #{task}"
                ports.push filter_ports(app, task)
                
              end
              
            end
            
            @logger.debug "Collected ports #{ports}"
            ports
  
          rescue JSON::ParserError => e
            raise Marathon::Srv::InvalidJSONResponseError.new e
            
          end
          
          
        end
        
      end
  
      protected
      def filter_ports(app, task)
        port = {:host => task["host"], :services => {}}
        app["container"]["docker"]["portMappings"].each_with_index do |port_mapping, port_i|
          port[:services][port_mapping["protocol"]] = {} unless port[:services].has_key? port_mapping["protocol"]
          port[:services][port_mapping["protocol"]][port_mapping["containerPort"]] = task["ports"][port_i]
          
        end
        
        port
           
      end
    
      
    end
  
  end
  
end