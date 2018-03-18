

        if [ -z "$MYSQL_PASSWORD" ]; then
                echo >&2 'error:  missing MYSQL_PASSWORD'
                echo >&2 '  Did you forget to add -e MYSQL_PASSWORD=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_USER" ]; then
                echo >&2 'error:  missing MYSQL_USER'
                echo >&2 '  Did you forget to add -e MYSQL_USER=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_PORT" ]; then
                echo >&2 'error:  missing MYSQL_PORT'
                echo >&2 '  Did you forget to add -e MYSQL_PORT=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_HOST" ]; then
                echo >&2 'error:  missing MYSQL_HOST'
                echo >&2 '  Did you forget to add -e MYSQL_HOST=... ?'
                exit 1
        fi

        if [ -z "$MYSQL_DBNAME" ]; then
                echo >&2 'error:  missing MYSQL_DBNAME'
                echo >&2 '  Did you forget to add -e MYSQL_DBNAME=... ?'
                exit 1
        fi

        for i in $MYSQL_USER $MYSQL_PORT $MYSQL_HOST $MYSQL_DBNAME $MYSQL_PASSWORD; do
                if grep '@' <<<"$i" >/dev/null 2>&1; then
                        echo >&2 "error:  missing -e $i"
                        echo >&2 "  You can't special characters '@'"
                        exit 1
                fi
        done

sed -ri 's/inputhost/$MYSQL_HOST/' /shadowsocks/usermysql.json
sed -ri 's/inputport/$MYSQL_PORT/' /shadowsocks/usermysql.json
sed -ri 's/inputuser/$MYSQL_USER/' /shadowsocks/usermysql.json
sed -ri 's/inputpassword/$MYSQL_PASSWORD/' /shadowsocks/usermysql.json
sed -ri 's/inputdb/$MYSQL_DBNAME/' /shadowsocks/usermysql.json
sed -ri 's/inputmul/1.0/' /shadowsocks/usermysql.json

