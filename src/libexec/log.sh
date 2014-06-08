#!/bin/sh


# Output options defaults
MODE=1				# Default: interactive mode
LOGTO=stdout		# Default: write log messages to stdout
LOGLEVEL=2			# Default: only log messages with level "WARN" or above
					# 0 = DEBUG
					# 1 = INFO
					# 2 = WARN
					# 3 = ERROR


get_log_level() {
	case $1 in
		[dD][eE][bB][uU][gG])
			echo "0"
			;;
		[iI][nN][fF][oO])
			echo "1"
			;;
		[wW][aA][rR][nN])
			echo "2"
			;;
		[eE][rR][rR][oO][rR])
			echo "3"
			;;
		*)
			echo "-1"
			;;
	esac
}
