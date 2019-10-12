#!/usr/bin/python3

import pymysql
import os
import sys
import time
import json
import subprocess

HOST = '127.0.0.1'
PORT = 3306
USERNAME = 'admin_ss1'
PASSWORD = ''
DBNAME = 'admin_ss1'

UPDATE_TIME = 150

V2RAY_PATH = '/usr/bin/v2ray/v2ray'
V2CTL_PATH = '/usr/bin/v2ray/v2ctl'
CONFIG_PATH = '/etc/v2ray/config.json'
ALTERID = 16
LEVEL = 0

CTL_PORT = 10085

User_list = []
data = []

def update_traffic():
    for u_list in User_list:
        try:
            traffic_msg = get_traffic(u_list['email'])
            if traffic_msg !=0:
                tra_sql = 'UPDATE user SET d=d+' + str(traffic_msg[0]) + ', u=u+' + str(traffic_msg[1]) + ', t=' + str(traffic_msg[2]) + ' WHERE email=\'' + u_list['email'] + '\''
                exec_sql(tra_sql)
        except Exception as e:
            print('Traffic read error!')
            print(e)


def get_traffic(user_email):
    def traffic_get_msg(cmd):
        import re
        try:
            exec_cmd = subprocess.Popen(
                    (cmd),
                    stdout = subprocess.PIPE,
                    stderr = subprocess.PIPE,
                    shell = True)
            outs, errs = exec_cmd.communicate(timeout = 1)
        except subprocess.TimeoutExpired as e:
            exec_cmd.kill()
            return 0
        finally:
            exec_cmd.kill()
        allouts = (outs + errs).decode()
        error_str = 'failed to call service StatsService.GetStats'
        check_error = re.search(error_str, str(allouts))
        if check_error is not None:
            return 0
        else:
            try:
                traffic_values = [i for i in allouts.split('\n') if re.search('value:', i)][0].strip()[7:]
                return traffic_values
            except Exception as e:
                return 0

    cmd_downlink = V2CTL_PATH + ' api --server=127.0.0.1:' + str(
        CTL_PORT) + ' StatsService.GetStats \'name: \"user>>>' + user_email + '>>>traffic>>>downlink\" reset: true\''
    cmd_uplink = V2CTL_PATH + ' api --server=127.0.0.1:' + str(
        CTL_PORT) + ' StatsService.GetStats \'name: \"user>>>' + user_email + '>>>traffic>>>uplink\" reset: true\''
    d_data = int(traffic_get_msg(cmd_downlink))
    u_data = int(traffic_get_msg(cmd_uplink))
    if d_data == 0:
        return 0
    else:
        use_time = int(time.time())
        return d_data, u_data, use_time



#进程检查
def isRunning(process_name):
    try:
        process = len(
                os.popen('ps aux | grep "' + process_name +
                    '" | grep -v grep').readlines())
        if process >=1:
            return True
        else:
            return False
    except Exception:
        print("Check process ERROR!")
        return False

#读取数据库连接
def exec_sql(sql):
    import pymysql
    conn = pymysql.connect(
        host=HOST,
        user=USERNAME,
        passwd=PASSWORD,
        db=DBNAME,
        charset='utf8'
        )
    try:
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql)
        data = cursor.fetchall()
        conn.commit()
    except Exception as e:
        print(e)
        data = 'error'
    finally:
        conn.close()
    return data


def traffic_check(all_user):
    sql = "SELECT u, d, transfer_enable, id FROM user"
    tmp = exec_sql(sql)
    for i in tmp:
        if i['u'] + i['d'] > i['transfer_enable']:
            for n in all_user:
                if n['id'] == i['id']:
                    n['enable'] = 0

def pull_user():
    from copy import deepcopy
    global data
    sql = "SELECT id, email, enable, uuid FROM user"
    data_cache = exec_sql(sql)
    if data_cache == 'error':
        return 'error'
    traffic_check(data_cache)
    if data_cache == data:
        return 'None'
    else:
        #检索变更
        data_change = [
            i for i in data_cache
            if i not in [m for m in data if m in data_cache]
        ]
        data_id = [x['id'] for x in data]
        data_cache_id = [y['id'] for y in data_cache]
        id_change = [z for z in data_id if z not in data_cache_id]
        data_delete =[]
        for n1 in data:
            for n2 in id_change:
                if n1['id'] == n2:
                    n1['enable'] = 0
                    data_delete.append(n1)
        data_all = data_change + data_delete
        data = deepcopy(data_cache)
    return data_all


def sql_cov_json(userlist):
    #获取配置文件
    def get_config_json():
        with open(CONFIG_PATH, 'rb+') as f:
            json_dict = json.loads(f.read().decode('utf8'))
        return json_dict

    #生成新的clients字段
    def make_config_json():
        global User_list
        for user in userlist:
            if user['enable'] == 1:
                usrname_cfg = {}
                usrname_cfg['id'] = user['uuid']
                usrname_cfg['email'] = user['email']
                usrname_cfg['alterId'] = ALTERID
                usrname_cfg['level'] = LEVEL
                User_list.append(usrname_cfg)
            elif user['enable'] == 0:
                del_user = [i for i in User_list if i['id'] == user['uuid']]
                User_list = [m for m in User_list if m not in del_user]
        return User_list

    #在配置中更新clients字段
    def create_config_json():
        c_dict = get_config_json()
        c_dict["inbounds"][0]["settings"].update({'clients':make_config_json()})
        return c_dict

    #更新json并格式化
    def format_json():
        config_dict = create_config_json()
        config_str = json.dumps(
                config_dict, sort_keys=False, indent=4, separators=(',', ':'))
        with open(CONFIG_PATH, 'wb+') as f:
            f.write(config_str.encode('utf8'))
    #执行
    format_json()


def update_cfg(u_list):
    v2ray_status = isRunning(V2RAY_PATH)
    r_cmd = 'service v2ray restart'
    s_cmd = 'service v2ray start'
    sql_cov_json(u_list)
    if v2ray_status:
        os.popen(r_cmd)
        print('restart')
    else:
        os.popen(s_cmd)
        print('start')

def accept_cfg():
    user_config_temp = pull_user()
    if user_config_temp !='None':
        print('Update user list')
        try:
            update_cfg(user_config_temp)
        except Exception as e:
            print(e)
            print('Update Error!')
    else:
        print('no update')

def main():
    while True:
        print(time.asctime(time.localtime(time.time())))
        try:
            update_traffic()
            accept_cfg()
        except Exception as e:
            print(e)
        time.sleep(UPDATE_TIME)

def run_scripts(argv):
    global HOST, PORT, USERNAME, PASSWORD, DBNAME
    import getopt
    import re
    import os
    filename = os.path.basename(sys.argv[0])
    help_text = '''Start up the V2muser.

Usage:
    ./{filename}
    ./{filename} -s <ip> -p <port> -u <username>, -k <password> -db <dbname>
    ./{filename} -h | --help
    ./{filename} --version

options:
    -h --help       Show this screen.
    -s --serverip   mysql server ip.
    -p --port       mysql server port.
    -u --username   mysql server username.
    -k --password   mysql server password. 
    -db --dbname    mysql server db name.
    -v --version    Show version.'''.format(filename=filename)
    try:
        opts, args = getopt.getopt(argv, "h:s:p:u:k:db",["--help", "--serverip=", "--port=", "--username=", "--password=", "--dbname="])
    except getopt.GetoptError:
        print("err")
        print(help_text)
        sys.exit(2)
    error_count=0
    for opt, arg in opts:
        if opt == ("-h", "--help"):
            print(help_text)
            sys.exit()
        elif opt in ("-s", "--serverip"):
            compile_ip = re.compile(
                    '^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$'
                    )
            if compile_ip.match(arg):
                HOST = arg
            else:
                print(arg + ' is not a legal ip address!')
                error_count +=1
        elif opt in ("-p", "--port"):
            try:
                arg = int(arg)
                if arg <1 or arg >65535:
                    print('The port numbers in the range from 1 to 65535.')
                    error_count +=1
            except Exception:
                print(opt + ' must use intergers')
                error_count +=1
            PORT = arg
        elif opt in ("-u", "--username"):
            USERNAME = arg
        elif opt in ("-k", "--password"):
            PASSWORD = arg
        elif opt in ("-db", "--dbname"):
            DBNAME = arg
    if error_count !=0:
        print(str(error_count) + ' error(s)')
        sys.exit()

def pri_par():
    print('''
Mysql Address:      {0}
Port:               {1}
'''.format(HOST, PORT))

if __name__ == "__main__":
    run_scripts(sys.argv[1:])
    pri_par()
    main()

