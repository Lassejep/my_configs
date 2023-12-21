#!/bin/bash

DAEMON_COUNT=$(ps -ef | rg -v rg | rg -cw swww)

if [ -n "$DAEMON_COUNT" ]; then
  swww query
else
  swww init
fi
