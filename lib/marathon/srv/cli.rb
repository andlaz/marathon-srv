require "marathon/srv"
require "marathon/srv/client"
require "rubygems"
require "thor"
require "logger"
require "json"

module Marathon
  
  module Srv
    
    class CLI < Thor
      class_option :verbose, :default => false, :desc => "Output Logger::DEBUG information to STDOUT"
      class_option :json, :default => false, :desc => "JSON encode response ( instead of CSV )"
      
      desc "find", "Returns a list of ip addresses and port numbers for an application name and service port number"
      option :marathon, :required => true, :desc => "Marathon API URL"
      option :app_id, :reqired => true, :desc => "Marathon application id"
      option :protocol, :default => "tcp"
      option :container_port, :type => :numeric, :required => true, :desc => "Docker container-side port to translate"
      option :username, :required => false
      option :password, :required => false
      option :healthy, :default => true, :desc => "Consider healthy application instances/tasks only"
      def find
        
        client = Marathon::Srv::Client.new options[:marathon], options[:username], options[:password], {:log_level => (options[:verbose] ? Logger::DEBUG : Logger::ERROR)}
        
        begin
          hosts = client.get_bridged_port_array options[:app_id], (options[:healthy] ? true : false), [options[:container_port]]
          
          if options[:json]
            puts JSON hosts
          else
            
            lines=[]
            hosts.each do |host|
              
              line=[]
              line.push host[:host]
              host[:services].each do |protocol, services|
                line.push protocol
                services.each do |port, host_port|
                  line.push host_port
                end
                
              end
              lines.push line.join ","
              
            end
            
            puts lines.join "\n"
            
          end
          
          
        rescue Exception => e
          fail e
        end
        
      end

    end    
    
  end
  
end