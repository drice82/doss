#!/bin/sh

sed -ri "s/mysqlhost/$MYSQL_HOST/g" /serverstatus/client-psutil.py
