#!/bin/sh

sed -ri "s/SETUP_USERNAME/$STATUS_USER/g" /serverstatus/client-psutil.py
sed -ri "s/SETUP_SERVER_ADDRESS/$STATUS_ADDRESS/g" /serverstatus/client-psutil.py
