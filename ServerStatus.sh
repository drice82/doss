#!/bin/sh
exec python /ServerStatus/client-linux.py SERVER=$STATUS_SRV USER=$STATUS_USR 2>&1
