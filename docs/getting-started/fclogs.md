# Collect and analyze aero flight logs

The aero flight controller doesn't have sd card slot and the onboard slot is connected to compute board.
The flight stack logs are streamed by the mavlink-router and stored on the compute board filesystem in the location "/var/lib/mavlink-router/".</br>
User can copy the logs using scp over USB ethernet or WIFI for further log analysis.</br>
User will be able to download flight logs using cockpit with aero release images > 1.5.1.<br/></br>
mavlink-router will save two types of files based on the type of autopilot loaded.

## PX4 log ananlysis
PX4 stack logs are stored with ulog file extension<br/>
[More details on PX4 log analysis](https://dev.px4.io/en/log/flight_log_analysis.html)

## Ardupilot log analysis
Ardupilot stack logs are stored with binlog extension<br/>
[More details on Ardupilot log analysis](http://ardupilot.org/copter/docs/common-downloading-and-analyzing-data-logs-in-mission-planner.html#manually-review-a-log)

