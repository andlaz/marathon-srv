# MarathonSRV

This is a small CLI gem that retrieves Mesos slave IP addresses and port numbers for an application id and container port combination.
The idea is that this side-steps the _current_ limitations in surfacing SRV records for these BRIDGEd ports in mesos-dns.

tl;dr poor man's port/service discovery for BRIDGEd Docker Containerized Marathon applications

## Usage via CLI

    $ marathon-srv find \
     --marathon http://marathon.domain.tld:8080 \
     --app-id best-redis-cluster \
     --container-port 6379 \
     --username username \
     --password password
    mesos-s1,tcp,31050
    mesos-s2,tcp,31507
    mesos-s11,tcp,31496

    $ marathon-srv help find
	Usage:
	  marathon-srv find --container-port=CONTAINER_PORT --marathon=MARATHON
	
	Options:
	  --marathon=MARATHON              # Marathon API URL
	  [--app-id=APP_ID]                # Marathon application id
	  [--protocol=PROTOCOL]            
	                                   # Default: tcp
	  --container-port=CONTAINER_PORT  # Docker container-side port to translate
	  [--username=USERNAME]            
	  [--password=PASSWORD]            
	  [--healthy=HEALTHY]              # Consider healthy application instances/tasks only
	                                   # Default: true
	  [--verbose=VERBOSE]              # Output Logger::DEBUG information to STDOUT
	  [--json=JSON]                    # JSON encode response ( instead of CSV )
	
	Returns a list of ip addresses and port numbers for an application name and service port number

## Usage via Marathon::Srv::Client object

    client = Marathon::Srv::Client.new "http://marathon.domain.tld:8080", "username", "password", {:log_level => Logger::DEBUG}
    client.get_bridged_port_array "best-redis-cluster", true # 2nd parameter : consider healthy tasks only
    
( n.b.: The Client object returns all BRIDGEd ports, the CLI filters these down to only --container-port )

## Notes

### Tests

Are there for the Client, not there for the CLI, and a bit spotty in general

### Health checks

When considering only healthy tasks, all health checks must pass. For TCP health checks, port index is not considered - if _any_ of the health checks fail, the
task is dropped and will not contribute host/port entries.