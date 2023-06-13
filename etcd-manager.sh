mkdir -p /data/etcd-manager/{config,logs}

cat >/data/etcd-manager/config/cfg.toml <<'EOF'

debug = true
log_path = /home/cliu/etcd-manager/logs

[http]
address = "0.0.0.0"
port = 10280

# 使用 Let's Encrypt 证书 - tls_enable为true优先使用本地证书模式
tls_encrypt_enable = false
#tls_encrypt_domain_names = ["debian3.mynas,org"]

tls_enable = false
[http.tls_config]
#cert_file = "cert_file"
#key_file = "key_file"


[[server]]
# 显示名称
title = "192.168.2.58"
name = "192.168.2.58"
# etcd连接地址 如果为集群请填写全部地址
address = ["192.168.2.58:2379","192.168.2.59:2379","192.168.2.60:2379"]
key_prefix = "/"
desc = "etcd"
#访问etcd的用户
username="root"
password="19940826"
roles = ["normal","admin"]
# 是否启用tls连接
tls_enable = false
# tls证书配置
[server.tls_config]
#cert_file = "/etc/etcd/etcdSSL/etcd.pem"
#key_file = "/etc/etcd/etcdSSL/etcd-key.pem"
#ca_file = "/etc/etcd/etcdSSL/etcd-root-ca.pem"


#[[server]]
#title = "本地etcd"
#name = "local"
#address = ["127.0.0.1:2379"]
#key_prefix = "/"
#desc = "本机环境"
#roles = ["admin","dev"]

## 以下为用户列表 ##
#管理介面登录用户
[[user]]
username = "root"
password = "19940826"
role = "admin"

[[user]]
username = "cliu"
password = "19940826"
role = "normal"
EOF

cat >/data/etcd-manager/start.sh <<'EOF'
docker run -it -d \
--name etcd-manager  \
-v /data/etcd-manager/config/cfg.toml:/app/config/cfg.toml \
-v /data/etcd-manager/logs:/app/logs  \
-v /etc/localtime:/etc/localtime \
-p 10280:10280  \
shiguanghuxian/etcd-manage:1
EOF

bash /data/etcd-manager/start.sh
