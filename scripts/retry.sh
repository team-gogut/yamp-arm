#!/bin/bash

try_num=3
if [ "${#}" -lt 1 ]; then
    echo 'Argument required' 1>&2
    exit 1
fi
if [[ ${1} =~ ^[0-9]+$ ]]; then
    try_num="${1}"
    shift
fi

exit_status=0
for i in $(seq ${try_num}); do
    echo "Try[${i}]: ${@}"
    # "${@}" && break || sleep 1
    ${@}
    if [ "${?}" = "0" ]; then
        exit_status=0
        break
    else
        exit_status=1
        sleep 1
    fi
done

exit "${exit_status}"
