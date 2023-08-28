#
# Regular cron jobs for the bifrost package.
#
0 4	* * *	root	[ -x /usr/bin/bifrost_maintenance ] && /usr/bin/bifrost_maintenance
