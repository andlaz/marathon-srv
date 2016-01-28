# MarathonSRV

This is a small CLI gem that retrieves Mesos slave IP addresses and port numbers for an application id and container port combination.

The idea is that this side-steps the _current_ limitations in surfacing SRV records for these BRIDGEd ports in mesos-dns.

## Usage

    $ marathon-srv find --marathon http://marathon:8080 --application-id my-cool-app --port 6162
    [
     {
      "host": "slave-1",
      "services":
       [
        { 6162: 30041 }
       ]
     }, {
      "host": "slave-2",
      "services":
       [
        { 6162: 30031 }
       ]
     }
    ]

    $ marathon-srv help find
    Usage:
      marathon-srv find --group-id=GROUP_ID --marathon=MARATHON

    Options:
      --marathon=MARATHON  # Marathon API URL
      --group-id=GROUP_ID  # Marathon group id
                           # Default: /
      [--app-id=APP_ID]    # Marathon application id
      [--healthy=HEALTHY]  # Consider healthy application instances/tasks only
                           # Default: true
      [--verbose=VERBOSE]  # Output Logger::DEBUG information to STDOUT
    
    Returns a list of ip addresses and port numbers for an application name and service port number
