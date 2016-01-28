# MarathonSRV

This is a small CLI gem that retrieves Mesos slave IP addresses and port numbers for an application id and container port combination.

The idea is that this side-steps the _current_ limitations in surfacing SRV records for these BRIDGEd ports in mesos-dns.

## Usage

## Notes

### Health checks

When considering only healthy tasks, all health checks must pass. For TCP health checks, port index is not considered - if _any_ of the health checks fail, the
task is dropped and will not contribute host/port entries.