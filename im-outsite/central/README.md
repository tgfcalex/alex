# 说明

适用于 outer-c 和sync 类型服务器;
普通外围不需要同步本目录;

```bash
control
├── ansible-playbook/  # 外围初始化
├── ansible-hosts      # sp-outer-c 和 sp-sync-2 可以软链接至 /etc/ansible/hosts
├── README.md          # 本说明文档
├── syncthing.py*      # 手动 rsync 脚本
└── syncthing.yaml     # 手动 rsync 脚本的配置

```
