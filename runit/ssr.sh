#!/bin/sh
ulimit -n 512000
exec python /shadowsocksr/server.py 2>&1
