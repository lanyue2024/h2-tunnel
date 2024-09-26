# http2-tunnel
能伪装成任意网站，以haproxy为基础的http2 tunnel和sniproxy。

## 服务端
在ubuntu 22.04/24.04上安装haproxy，
```bash
sudo apt update && sudo apt install haproxy unzip -y
```

然后直接下载本仓库代码解压：
```bash
curl -LO https://github.com/lanyue2024/h2-tunnel/archive/refs/heads/main.zip \
&& unzip main.zip \
&& cd h2-tunnel-main
```

设置h2-tunnel，
```bash
sudo bash h2-tunnel.sh HOST KEY
```

- HOST: 是伪装的网站，比如 www.apple.com
- KEY: 是认证密钥，只能包含数字、字母，用命令生成 openssl rand -hex 10

```bash
sudo bash h2-tunnel.sh www.apple.com d4dc100df79f4727a1b2
```

最后重启haproxy
```bash
sudo systemctl restart haproxy
```


## 客户端
以 Windows 系统为例：
- [下载仓库代码](https://github.com/lanyue2024/h2-tunnel/archive/refs/heads/main.zip)解压到 h2-tunnel-main。
- 从服务器上下载 <ca.crt> 文件放在文件夹 h2-tunnel-main。
- 打开文件 <h2-client.cfg>，修改 HOST，KEY 和 SERVER。SERVER是服务器IP。HOST 和 KEY 和服务端一样。
- 然后双击 <h2-tunnel.bat> 运行haproxy。

客户端和服务端是经过 http2/tls1.3加密的。

### 运行其他程序
其他程序(比如v2ray)在服务器上运行时应当监听在 127.0.0.1:7200，并且不要设置加密。其他程序的客户端连接本地端口 7200就是连接到服务器的 7200。

### 作为sniproxy使用
只要在文件 <h2-client.cfg> 加入绑定 443端口，服务器就可以成为sniproxy。
```haproxy
listen h2_client
    bind :7200
    # 加入下面一行
    bind :443
```

要么通过修改系统 hosts文件将网站指向 sniproxy，或者搭配 dnsmasq/adguardhome，看这里 https://github.com/lanyue2024/hosts


