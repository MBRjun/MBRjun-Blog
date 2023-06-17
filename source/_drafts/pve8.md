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
thumbnailImage: 
---
Proxmox VE 8.0 已于 2023 年 6 月 22 日发布，PVE 8.0 使用 Linux 6.2 内核和最新的 Debian 12 Bookworm 底层系统
<!-- more -->

## 新特性
- 默认使用 ``x86-64-v2-AES`` CPU 类型代替 ``qemu64``/``kvm64`` 来提高性能  
- ISO 安装新增 TUI
- 2FA 安全性提高
- 原生的深色模式

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
