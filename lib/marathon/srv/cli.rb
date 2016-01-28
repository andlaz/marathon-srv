require "rubygems"
require "thor"
require "logger"

module Marathon
  
  module Srv
    
    class CLI < Thor
      class_option :verbose, :default => false, :desc => "Output Logger::DEBUG information to STDOUT"
      
      desc "find", "Returns a list of ip addresses and port numbers for an application name and service port number"
      option :marathon, :required => true, :desc => "Marathon API URL"
      option :group_id, :required => true, :default => "/", :desc => "Marathon group id"
      option :app_id, :reqired => true, :desc => "Marathon application id"
      option :healthy, :default => true, :desc => "Consider healthy application instances/tasks only"
      def find
        
      end
      
      protected
      def get_client
        Marathon.Client.new
      end
      
    end    
    
  end
  
end