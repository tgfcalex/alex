#!/usr/bin/env python3

from pathlib import Path
import sys
import getopt
import re
import subprocess
try:
    import yaml
except ImportError:
    from pip._internal import main as pip
    pip(['install', '--user', 'pyYAML'])
    import yaml


def usage(exit_code=0, info=None):
    version = "0.1beta"
    if exit_code != 0:
        print("\033[0;31;40m{}\033[0m".format(info))
    print("\nUsage: {} [OPTION]\n".format(Path(__file__)))
    print("\t手动 rsync 脚本, 具体模块参看 ./syncthing.yaml")
    print("{:20s}{}".format("Options", "Description"))
    opt_desc = {"-h": "print this message",
                "-v": "print version number",
                "-m <MODULE>": "指定同步模块"}
    for opt, desc in opt_desc.items():
        print("  {:20s}{}".format(opt, desc))
    print("\nVersion: ", version)
    sys.exit(exit_code)


def get_config():  # 解析 yaml 配置, 返回 {"modules":{...}, "hosts":{...}}
    conf_file = Path(__file__).parent / 'syncthing.yaml'
    if not conf_file.is_file():
        print("\033[0;31;40m{}\033[0m: No such file.\n----\033[0m".format(conf_file))
        exit(1)
    with open(conf_file) as yaml_file:
        try:
            dict_conf = yaml.load(yaml_file, Loader=yaml.FullLoader)
            if "modules" in dict_conf and "hosts" in dict_conf:
                return dict_conf["modules"], dict_conf["hosts"]
            else:
                print("Configuration file error")
                sys.exit(2)
        except yaml.YAMLError as exc:
            print("Error in configuration file:", exc)
            sys.exit(2)


def get_cmd_dict(_modules_dict, _module, _host_list):  # 参数模块, 拼接返回 {"主机1": "rsync命令1", ...}
    if _module not in _modules_dict:
        m_list = [item for item in _modules_dict]
        print("\033[0;31;40m{}: invalid module.\n\t\033[0;32;40m{}\033[0m".format(_module, m_list))
        sys.exit(3)
    try:
        m_config = _modules_dict[_module]
        is_delete, path, excludes, user = m_config["is_delete"], m_config["path"], m_config["excludes"], m_config["user"]
    except KeyError as err:
        print('KeyError: {} \nFrom  \n\tget_cmd_dict(_module)'.format(err))
        sys.exit(4)

    result = {}
    _delete = ' --delete ' if is_delete else ' '
    _excludes = " "
    if excludes:
        for i in excludes:
            if i.strip():
                _excludes = _excludes + ' --exclude ' + i

    if Path(path).is_dir and Path(path).exists():
        path = path + '/'
        for host in _host_list:
            _remote = user + "@" + host + "::" + _module
            cmd_str = "rsync -vazl --timeout=20 --contimeout=30 {} {} {} {}".format(_delete, _excludes, path, _remote)
            cmd_str = re.sub(r'\s+', ' ', cmd_str)
            cmd_str = re.sub(r'/+', '/', cmd_str)
            result[host] = cmd_str
        return result
    else:
        print("\033[0;31;40m{}\033[0m: No such directory.\033[0m".format(path))
        exit(2)


def executor(_rsync_cmd):
    proc = subprocess.Popen(_rsync_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc.wait(60)
    returncode = proc.returncode
    # print(_rsync_cmd, returncode)
    if returncode == 0:
        return True
    else:
        return False


def get_module(_modules, _argv):  # 获取参数模块
    try:
        opts, args = getopt.getopt(_argv, "hvm:", ["help", "version", "module="])
    except getopt.GetoptError:
        usage(1, "Getopt error!")
    if len(args) > 0:
        usage(1, "Unknown argument: {}".format(args))
    else:
        for opt, arg in opts:
            if opt in ("-m", "--module") and arg:
                if arg not in _modules:
                    m_list = [item for item in _modules]
                    print("\033[0;31;40m{}: invalid module.\n\t\033[0;32;40m{}\033[0m".format(arg, m_list))
                    sys.exit(3)
                return arg
            elif opt in ("-h", "--help", "-v", "--version"):
                usage()
            # else:
            #     usage(1, "Option error!")
        usage(1, "Option error!")


def result_info(_level, info_list):
    end = '\n\t'
    if _level == "excludes":
        color = "\033[0;33;40m"
    elif _level == "success":
        color = "\033[0;32;40m"
        end = ' '
    elif _level == "failure":
        color = "\033[0;31;40m"

    if info_list:
        info = end.join(info_list)
    else:
        info = "None"
    print('{}{}:\n\t{}\033[0m'.format(color, _level, info))


def main(_argv):
    modules, hosts = get_config()
    module = get_module(modules, _argv)
    hosts_list = hosts["all"]

    success_host = []
    excludes_host = []
    failure_host = []
    if module not in ['freessl', "theme"]:
        exc_hosts = hosts["excludes"]
        if exc_hosts:
            for host in exc_hosts:
                if host in hosts_list:
                    hosts_list.remove(host)
                    _exclude = "{}:  {}".format(host, exc_hosts[host])  # 输出忽略主机和原因
                    excludes_host.append(_exclude)
                else:
                    continue
    cmd_dict = get_cmd_dict(modules, module, hosts_list)  # 获取执行的命令
    # import json
    # print(json.dumps(cmd_dict, indent=4))
    for host, rsync_cmd in cmd_dict.items():
        exexcutor_result = executor(rsync_cmd)
        if exexcutor_result:
            success_host.append(host)
        else:
            _failure = "{}:  {}".format(host, rsync_cmd)
            failure_host.append(_failure)

    result_info("success", success_host)
    result_info("excludes", excludes_host)
    result_info("failure", failure_host)


if __name__ == "__main__":
    main(sys.argv[1:])
