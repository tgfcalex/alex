#!/usr/bin/env python
#coding: utf-8
# python_version : 3.5.3
# __author__ == "Sun"
#Description: a主机控制容器中的tomcat服务 启动 停止
import os,sys,re,time,threading
class controlService:
    env_file = os.path.join(os.getcwd(),"appServiceControl.conf")
    hostname = os.popen('hostname').read()
    lineNumber = re.sub("\D", "", hostname)
    def get_env(self, key):  #读取变量文件，转换成python字典
        env_dict = {}
        if os.path.exists(self.env_file):
            with open(self.env_file) as f:
                for line in f.readlines():
                    line = line.strip("\n")
                    if len(line) != 0 and not line.startswith('#'):
                        k = line.split("=")[0]
                        v = line.split("=")[1]
                        env_dict[k] = v
            if env_dict.__contains__(key):
                return env_dict.get(key)
            else:
                result = self.env_file + "未定义此变量" + key
                return  result
        else:
            result = self.env_file + "变量文件不存在"
            return result
    def getContainerName(self, app): #获取容器名
        project = self.get_env('project')
        containerName = os.popen('docker ps --format "{{.Names}}" --filter name=' + project + '_' + app + "-" + self.lineNumber).read().strip()
        return containerName
    def get_check(self, app): #停止服务后，进行check请求，确认服务是否停止
        check_url = "curl -s -I http://" + self.get_env('project') + "_" + app + "-" + self.lineNumber + ":8080" + self.get_env(app)
        container_name = self.getContainerName(app)
        response = os.popen("docker exec  " + container_name + ' ' + check_url).read()
        statusCode = re.compile(r'200')
        result = statusCode.findall(response)
        if result:
            return True
        else:
            return False
    def stop(self, *apps):  # 停止服务
        for app in apps:
            container_name = self.getContainerName(app)
            app_dubbo_off = app + "_dubbo_off"
            dubbo_off = self.get_env(app_dubbo_off)
            print("反注册dubbo服务-------" + app)
            os.system("docker exec " + container_name + ' ' +  dubbo_off)
            check_value = self.get_check(app)
            if not check_value:
                result = "反注册dubbo成功，check状态码为非200,开始执行stop"
                #调试信息
                print(result)
                os.system("docker exec " + container_name + ' ' +  'stop.sh')
                print("休眠20秒，进行check监测是否停止服务")
                time.sleep(20)
                check_info = self.get_check(app)
                if not check_info:
                    result = "服务已停止  "
                    print(result + app)
                    return result
            else:
                return_info = os.popen("docker exec " + container_name + ' ' + "status.sh").read().strip()
                print("反注册dubbo服务失败" + '--服务状态信息----' + return_info )
    def start(self, *apps):  #启动服务
        for app in apps:
            print("监测服务是否是停止状态-check-----" + app)
            check_value = self.get_check(app)
            if check_value:
                print("服务已是运行状态 !!......   " + app)
                return False
            else:
                container_name = self.getContainerName(app)
                print("启动服务---" + app)
                os.system('docker exec ' + container_name + ' ' + 'start.sh')
                print("休眠20秒，开始进行check监测启动是否成功-----------" + app)
                time.sleep(20)
                check_value = self.get_check(app)
                if check_value:
                    result = app + "服务已启动，check状态码为200"
                    print(result)
                    return result
                else:
                    result = app + "服务启动失败，请手动查看日志"
                    print(result)
                    return result
if __name__ == "__main__":
    try:
        parameter = sys.argv[1]
    except IndexError:
        print("检查参数是否正确")
    else:
        if parameter == "stop":
            for num in range(2, len(sys.argv)):
                threads = threading.Thread(target=controlService().stop, args=[sys.argv[num]])
                threads.start()
                # controlService().stop(sys.argv[num])
        elif parameter == "start":
            for num in range(2,len(sys.argv)):
                threads = threading.Thread(target=controlService().start, args=[sys.argv[num]])
                threads.start()
                # controlService().start(sys.argv[num])