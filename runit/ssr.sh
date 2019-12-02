#!/bin/sh
ulimit -n 512000
exec python3 /shadowsocksr/server.py 2>&1
