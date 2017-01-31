#!/bin/bash
#
# @brief   Remove blank lines from an ascii file and replace the original file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RM_BLANKS=rm_blanks
UTIL_RM_BLANKS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_RM_BLANKS_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A RM_BLANKS_USAGE=(
	[USAGE_TOOL]="__${UTIL_RM_BLANKS}"
	[USAGE_ARG1]="[FILES] Name of file"
	[USAGE_EX_PRE]="# Removing blank lines from file"
	[USAGE_EX]="__${UTIL_RM_BLANKS} /data/test.txt"
)

#
# @brief  Remove blank lines from an ascii file and replace the original file
# @param  Value required name of file or path to the file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rm_blanks "test.ini"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __rm_blanks() {
	local FILES=$@
	if [ -n "${FILES}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS A
		MSG="Remove blank lines from an ascii file, replace original file!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
		local TMP=/tmp/tmp.${RANDOM}$$
		trap 'rm -f $TMP >/dev/null 2>&1' 0
		trap "exit 1" 1 2 3 15
		for A in "${FILES[@]}"
		do
			MSG="Checking file [${A}]?"
			__info_debug_message_que "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
			if [ -f "${A}" ]; then
				MSG="[ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
				file "${A}" | grep -q text
				STATUS=$?
				if [ $STATUS -eq $SUCCESS ]; then
					sed '/^[ 	]*$/d' < "${A}" > ${TMP} && mv ${TMP} "${A}"
				else
					MSG="File [${A}] is not in ascii type!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
				fi
			else
				MSG="[not ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
				MSG="Please check file [${A}]"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_RM_BLANKS"
			fi
			:
		done
		__info_debug_message_end "Done" "$FUNC" "$UTIL_RM_BLANKS"
		return $SUCCESS
	fi
	__usage RM_BLANKS_USAGE
	return $NOT_SUCCESS
}
