---
title: Proxmox VE 8 发布/更新教程
date: 2023-06-24 00:00:00
updated: 2023-06-24 00:00:00
categories: 操作系统
tags:
- Proxmox VE
- PVE
- 服务器
- 虚拟化
- 软路由
- ESXi
thumbnailImage: https://cos.mbrjun.cn/IMGS/2023/06/26/ece403b9-6549-4a37-b1ba-c1754edb72dd.webp
---
Proxmox VE 8.0 已于 2023 年 6 月 22 日发布，PVE 8.0 使用 Linux 6.2 内核和最新的 Debian 12 Bookworm 底层系统
<!-- more -->

## 新特性
- 默认使用 ``x86-64-v2-AES`` CPU 类型代替 ``qemu64``/``kvm64`` 来提高性能  
- ISO 安装新增 TUI
- 2FA 安全性提高
- 原生的深色模式
- BtrFS 性能提升
- 核心软件包（``libc6``、``OpenSSL``、``OpenSSH``、``python3``等）更新  

## 更新教程

### 检查现有版本
在升级到 Proxmox VE 8.0 之前，您需要先升级到最新的 Proxmox VE 7.4  

{% tabbed_codeblock %}
    <!-- tab sh -->
        apt dist-upgrade
    <!-- endtab -->
{% endtabbed_codeblock %}

![Upgrade to Proxmox VE 7.4](https://cos.mbrjun.cn/IMGS/2023/06/17/35267825-2bd1-4c47-ba1a-f0da940bd969.webp)

无需重启，然后输入 ``pveversion`` 命令，检查版本是否已更新到 7.4-15 或更新版本  

### 更新前检查
运行命令 ``pve7to8 --full`` 来自动检查是否能升级 Proxmox VE 8.0  

{% tabbed_codeblock %}
    <!-- tab txt -->
        = SUMMARY =
        TOTAL:    34
        PASSED:   27
        SKIPPED:  3
        WARNINGS: 4
        FAILURES: 0

        ATTENTION: Please check the output for detailed information!
    <!-- endtab -->
{% endtabbed_codeblock %}

### cgroup2 迁移
{% tabbed_codeblock %}
    <!-- tab sh -->
        sed -i 's/lxc.cgroup./lxc.cgroup2./g' /etc/pve/lxc/*.conf
    <!-- endtab -->
{% endtabbed_codeblock %}

### 开始更新

**我们需要先添加 Debian 12 和 Proxmox 8 存储库**：  

{% tabbed_codeblock %}
    <!-- tab sh -->
        sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
    <!-- endtab -->
{% endtabbed_codeblock %}

如果你是一个企业订阅用户，继续执行：

{% tabbed_codeblock %}
    <!-- tab sh -->
        echo "deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" > /etc/apt/sources.list.d/pve-enterprise.list
        echo "deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise" > /etc/apt/sources.list.d/ceph.list
    <!-- endtab -->
{% endtabbed_codeblock %}

否则请使用：

{% tabbed_codeblock %}
    <!-- tab sh -->
        echo "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription" > /etc/apt/sources.list.d/ceph.list
        sed -i -e 's/bullseye/bookworm/g' /etc/apt/sources.list.d/pve-install-repo.list 
    <!-- endtab -->
{% endtabbed_codeblock %}

完成后，使用 ``apt update`` 刷新软件源，**然后运行 ``apt dist-upgrade`` 更新**  

{% tabbed_codeblock %}
    <!-- tab txt -->
        1174 upgraded, 199 newly installed, 15 to remove and 0 not upgraded.
        Need to get 1,441 MB of archives.
        After this operation, 1,917 MB of additional disk space will be used.
    <!-- endtab -->
{% endtabbed_codeblock %}

## 更新内容
更新时，系统会发送一封邮件到管理员邮箱，其中包含了更新的内容  

![apt-listchanges](https://cos.mbrjun.cn/IMGS/2023/06/24/c59cc0b2-a320-4a07-80be-4fba93b73413.webp)

## 配置文件修改

{% tabbed_codeblock %}
    <!-- tab txt -->
        Configuration file '/etc/issue'
        ==> Modified (by you or by a script) since installation.
        ==> Package distributor has shipped an updated version.
        What would you like to do about it ?  Your options are:
            Y or I  : install the package maintainer's version
            N or O  : keep your currently-installed version
            D     : show the differences between the versions
            Z     : start a shell to examine the situation
        The default action is to keep your current version.
        *** issue (Y/I/N/O/D/Z) [default=N] ?
    <!-- endtab -->
{% endtabbed_codeblock %}

- ``/etc/issue`` 建议使用 N
- ``/etc/lvm/lvm.conf`` 建议使用 Y
- ``/etc/default/grub`` 建议使用 N

## 错误处理
如果在更新过程中出现了错误（例如：SSH 连接中断、电源故障），导致更新中断，则可能需要使用下面的命令恢复：  

{% tabbed_codeblock %}
    <!-- tab sh -->
        apt -f install
    <!-- endtab -->
{% endtabbed_codeblock %}
