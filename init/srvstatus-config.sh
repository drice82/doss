#!/bin/sh

sed -ri "s/SETUP_USERNAME/$STATUS_USER/g" /serverstatus/client-linux.py
sed -ri "s/SETUP_SERVER_ADDRESS/$STATUS_ADDRESS/g" /serverstatus/client-linux.py
