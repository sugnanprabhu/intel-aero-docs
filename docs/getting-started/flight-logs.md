# Collect and analyze flight logs

The Aero Flight Controller doesn't have an sd card slot exposed. The onboard
slot is rather connect the Compute Board, i.e. it's controlled by Linux. The
flight stack logs are streamed from the Flight Controller to the Compute
Board and automatically stored by mavlink-router on the filesystem. They are
located at `/var/lib/mavlink-router/logs`.

User can copy the logs to his computer using scp, sftp or mounting the
filesystem with sshfs for further log analysis. Mavlink-router saves two types
of files based on the flight stack used.

## PX4 log analysis
PX4 logs are stored with ulog file extension. See more details on
[PX4 log analysis](https://dev.px4.io/en/log/flight_log_analysis.html).

## Ardupilot log analysis
Ardupilot logs are stored with binlog extension. See more details on
[Ardupilot log analysis](http://ardupilot.org/copter/docs/common-downloading-and-analyzing-data-logs-in-mission-planner.html#manually-review-a-log).

