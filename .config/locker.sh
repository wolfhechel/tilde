#!/bin/sh

export XSECURELOCK_PASSWORD_PROMPT=time_hex
export XSECURELOCK_NO_COMPOSITE=1

echo RELOADAGENT | gpg-connect-agent

xsecurelock
