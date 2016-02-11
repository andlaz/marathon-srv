
module Marathon
  
  module Srv
    
    module Fixtures

      SOME_HEALTHY_TASKS_APP_JSON = '{
        "apps":
        [
        {
          "id": "best-app",
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
      
          "healthChecks": 
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
            },
            {
              "healthCheckResults": 
              [
                {
                  "alive": true
                }
              ],
      
              "host": "slave-2",
              "ports": 
              [
                30061,
                30072
              ]
            }
          ]
        }
        ]
      }' 
      
      SOME_TASK_FAILURES_APP_JSON = '{
        "apps":
        [
        {
          "id": "best-app",
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
      
          "healthChecks": 
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
            },
            {
              "path": "/",
              "protocol": "TCP",
              "portIndex": 1,
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
                },
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
        ]
      }'      
      
      ALL_HEALTHY_TASKS_APP_JSON = '{
        "apps": 
        [
        {
          "id": "best-app",
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
      
          "healthChecks": 
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
            },
            {
              "healthCheckResults": 
              [
                {
                  "alive": true
                }
              ],
      
              "host": "slave-2",
              "ports": 
              [
                30093,
                30077
              ]
            }
          ]
        }
        ]
      }'
      
      NON_DOCKER_APP_JSON = '{
        "apps": 
        [
        {
          "id": "best-app",
          "container": 
          {
            "type": "NOTDOCKER!"
          }
        }
        ]
      }'
      
      NO_TASKS_APP_JSON = '{
        "apps":
        [ 
        {
          "id": "best-app",
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
        ]
      }'
      
      NO_HEALTHCHECK_APP_JSON = '{
        "apps":
        [ 
        {
          "id": "best-app",
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
    
          "healthChecks": [],
          
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
        ]
      }'  
      
      NO_HEALTHY_TASKS_APP_JSON = '{
        "apps": 
        [
        {
          "id": "best-app",
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
    
          "healthChecks": 
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
        ]
      }'        
      
    end
    
  end
  
end