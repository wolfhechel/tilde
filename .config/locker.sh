#!/bin/sh

export XSECURELOCK_PASSWORD_PROMPT=time_hex

echo RELOADAGENT | gpg-connect-agent

xsecurelock
