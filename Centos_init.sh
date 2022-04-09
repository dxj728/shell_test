当前以Centos7 版本为例

sudo passwd root	# 修改设置root密码及登录

一、设置静态IP
1.宿主机系统(win)网络设置
(1) 适配器设置，VMnet8(NAT模式)网卡上属性-->Internet协议版本4，设置IP地址，子网掩码，默认网关(重要)，DNS服务器等
(2) 选择当前宿主机正在使用的网卡，属性-->共享-->允许其他网络用户通过此计算机的Internet连接来连接，并选择上一步中的网卡
2.VMware网络设置
(1) 进入编辑-->虚拟网络编辑器-->选择NAT模式，界面下方编辑子网，子网掩码，与上述一致
(2) 虚拟网络编辑器中进入NAT设置，填写网关，与上步保持一致
3.Centos7网络配置
(1) 命令 ip addr 获取当前设备网卡(例如ens33, eth0)
(2) 命令 vi /etc/sysconfig/network-scripts/ifcfg-ens33 ，修改如下，后重启生效
BOOTPROTO="static"
ONBOOT="yes"
IPADDR="192.168.XX.XX"
NETMASK="255.255.255.0"
GATEWAY="192.168.XX.1"

二、更换国内源
1.Centos7更换国内源
vim /etc/yum.repos.d/CentOS-Base.repo  先做bak文件备份，后修改各项中的baseurl值为源链接
yum clean all
yum makecache

三、SSH配置
1.SSH下载安装
yum install openssh-server
apt install openssh-server
2.远程登录
vim /etc/ssh/sshd_config  修改如下：
PermitRootLogin yes
PasswordAuthentication yes
service ssh restart
3.SSH免密
ssh-keygen -t rsa	# 生成 id_rsa 私钥和 id_rsa.pub 公钥
ssh-copy-id root@IP 	# 传递公钥至对方IP机器~/.ssh/authorized_keys文件中
service sshd restart
完成当前本机-->对方机器的ssh免密

四、命令行提示符色彩修改
vi /etc/profile文件，末尾插入以下
Centos:  export PS1="\e[31m\][\e[35m\]\u\e[33m\]@\e[32m\]\h \e[36m\]\W\e[31m\]]\e[33m\]\\$ \e[m\]"
Ubuntu:  export PS1="\e[35m\]\u\e[33m\]@\e[32m\]\h:\e[36m\]\W\e[33m\]\\$ \e[m\]"
修改完毕，source /etc/profile  后生效


