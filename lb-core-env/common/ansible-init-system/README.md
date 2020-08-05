# 1 .初始化服务器使用ansible编写playbook文件批量运行
    1.1 通过入口文件控制角色执行
    1.2 外围角色目前有区别的是crontab文件不同，不同项目同步工程文件不同

# 2.操作步骤
    初始化服务器执行步骤  统一在out-c上进行初始化操作
```
1、确保out-c可以免秘钥登录控制机
    ssh-copy-id  {remote-host}
2、初始化的服务器，在大鱼添加，并在out-c执行
    s  --reload-hosts
3、确保/etc/ansible/hosts定义了要执行的主机或者主机组（必须使用主机名，禁止使用ip，主机名对应解析，请添加到/etc/hosts文件中）
    
4、执行初始化操作
    sh ansible-init.sh  {yml_file} {remote_host}  {remote_ssh_port} {remote_host_user}

5、Example:

例如gb项目 外围服务器sp-10的主机初始化
(1)、/etc/ansible/hosts添加内容如下   --如果大鱼平台有，直接执行命令 s --reload-hosts
[sp]
sp-10 （为何禁止使用ip，因为hostname角色，会用到此名字，使用ip，主机名就会设置成ip，或者注释角色hostname）
(2)、/etc/hosts 添加：
192.168.0.41 sp-10
(3)、执行脚本
./ansible-init.sh --help 查看脚本帮助说明
./ansible-init.sh  -f gb-outsite.yml -h sp-10 -p 22
如果远端主机不是root用户，请修改用户
./ansible-init.sh -f gb-outsite.yml -h sp-10 -p 22 -u gb

```
# 3. 操作命令
    
## 3.1 ansible命令

```bash
#执行gb的外围初始化, --extra-vars选项可以传入参数
ansible-playbook  gb-outsite.yml   --extra-vars "remote_host=gb-123  ansible_ssh_port=6343 ansible_ssh_user=root"

```

# 4.通过脚本执行
```bash
#-f:playbook文件  -h: 远端主机 -p: 远端主机端口 -u:远端执行命令的用户
sh ansible-init.sh -f gb-outsite.yml -h gb-123 -p 6343 -u gb
```

