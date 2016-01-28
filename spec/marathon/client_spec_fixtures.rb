
module Marathon
  
  module Srv
    
    module Fixtures
      
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
      
    end
    
  end
  
end