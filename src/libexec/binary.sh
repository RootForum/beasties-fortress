#!/bin/sh

detect_binary() {

	local BINDIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin"
	local rval=""

	for i in $BINDIRS
	do
		if [ -x "${i}/${1}" ]
		then
			rval="${i}/${1}"
			break
		fi
	done

	echo $rval
}
