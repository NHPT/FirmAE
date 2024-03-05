# FirmAE简介

FirmAE是一个完全自动化的框架，用于执行仿真和漏洞分析。FirmAE使用五种仲裁技术显著提高了仿真成功率（从[Firmadyne](https://github.com/firmadyne/firmadyne)的16.28%到79.36%）。
我们在来自前八大供应商的1124个无线路由器和IP相机固件映像上测试了FirmAE。
我们还开发了一个用于发现0-day的动态分析工具，该工具根据目标固件的文件系统和内核日志推断web服务信息。
通过在仿真成功的固件映像上运行我们的工具，我们发现了12个新的0-day，影响了23个设备。

# 安装

注意，我们在Ubuntu 18.04上测试了FirmAE。

1. 克隆`FirmAE`项目
```console
$ git clone --recursive https://github.com/pr0v3rbs/FirmAE
```

2. 运行 `download.sh` 下载脚本.
```console
$ ./download.sh
```

3. 运行 `install.sh` 安装脚本.
```console
$ ./install.sh
```

# 用法

1. 执行 `init.sh` 初始化脚本.
```console
$ ./init.sh
```

2. 准备一个待仿真的固件
```console
$ wget https://github.com/pr0v3rbs/FirmAE/releases/download/v1.0/DIR-868L_fw_revB_2-05b02_eu_multi_20161117.zip
```

3. 检查仿真
```console
$ sudo ./run.sh -c <brand> <firmware>
```

4. 分析目标固件
    * 分析模式使用FirmAE分析仪
    ```console
    $ sudo ./run.sh -a <brand> <firmware>
    ```

    * 运行模式有助于测试web服务或执行自定义分析器
    ```console
    $ sudo ./run.sh -r <brand> <firmware>
    ```

## 调试

运行完 `run.sh -c` 之后.

1. 用户级基本调试实用程序。（当模拟固件可通过网络访问时很有用）

```console
$ sudo ./run.sh -d <brand> <firmware>
```

2. 内核级启动调试。

```console
$ sudo ./run.sh -b <brand> <firmware>
```

## 打开/关闭仲裁

检查`firmae.config`中的五个仲裁环境变量
```sh
$ head firmae.config
#!/bin/sh

FIRMAE_BOOT=true
FIRMAE_NETWORK=true
FIRMAE_NVRAM=true
FIRMAE_KERNEL=true
FIRMAE_ETC=true

if (${FIRMAE_ETC}); then
  TIMEOUT=240
```

## Docker

首先，准备一个docker 映像
```console
$ ./docker-init.sh
```

### 并行模式

然后，运行以下命令之一。 ```-ec``` 只检查仿真, and ```-ea``` 检查仿真并分析漏洞。
```console
$ ./docker-helper.py -ec <brand> <firmware>
$ ./docker-helper.py -ea <brand> <firmware>
```

### 调试模式

在成功模拟固件映像之后
```console
$ ./docker-helper.py -ed <firmware>
```

# 仿真

## 仿真结果

Google电子表格 -
[view](https://docs.google.com/spreadsheets/d/1dbKxr_WOZ7UmneOogug1Zykj1erpfk-GzRNni8DjroI/edit?usp=sharing)

## 数据集

Google drive -
[download](https://drive.google.com/file/d/1hdm75NVKBvs-eVH9rKb5xfgryNSnsg_8/view?usp=sharing)

# CVEs

- ASUS: [CVE-2019-20082](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2019-20082)
- Belkin: [Belkin01](https://github.com/pr0v3rbs/CVE/tree/master/Belkin01)
- D-Link: [CVE-2018-20114](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-20114),
          [CVE-2018-19986](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-19986%20-%2019990#cve-2018-19986---hnap1setroutersettings),
          [CVE-2018-19987](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-19986%20-%2019990#cve-2018-19987---hnap1setaccesspointmode),
          [CVE-2018-19988](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-19986%20-%2019990#cve-2018-19988---hnap1setclientinfodemo),
          [CVE-2018-19989](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-19986%20-%2019990#cve-2018-19989---hnap1setqossettings),
          [CVE-2018-19990](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2018-19986%20-%2019990#cve-2018-19990---hnap1setwifiverifyalpha),
          [CVE-2019-6258](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2019-6258),
          [CVE-2019-20084](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2019-20084)
- TRENDNet: [CVE-2019-11399](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2019-11399),
            [CVE-2019-11400](https://github.com/pr0v3rbs/CVE/tree/master/CVE-2019-11400)

# 作者
This research project has been conducted by [SysSec Lab](https://syssec.kr) at KAIST.
* [Mingeun Kim](https://pr0v3rbs.blogspot.kr/)
* [Dongkwan Kim](https://0xdkay.me/)
* [Eunsoo Kim](https://hahah.kim)
* [Suryeon Kim](#)
* [Yeongjin Jang](https://www.unexploitable.systems/)
* [Yongdae Kim](https://syssec.kaist.ac.kr/~yongdaek/)

# 引用
We would appreciate if you consider citing [our paper](https://syssec.kaist.ac.kr/pub/2020/kim_acsac2020.pdf) when using FirmAE.
```bibtex
@inproceedings{kim:2020:firmae,
  author = {Mingeun Kim and Dongkwan Kim and Eunsoo Kim and Suryeon Kim and Yeongjin Jang and Yongdae Kim},
  title = {{FirmAE}: Towards Large-Scale Emulation of IoT Firmware for Dynamic Analysis},
  booktitle = {Annual Computer Security Applications Conference (ACSAC)},
  year = 2020,
  month = dec,
  address = {Online}
}
```
# FAQ
由于网络原因执行download.sh花费大量时间时可添加代理后再次执行：
```console
$ export https_proxy=http://127.0.0.1:7890
$ export http_proxy=http://127.0.0.1:7890
$ ./download.sh
```
运行`./docker-init.sh`报错`error parsing HTTP 408 response body: invalid character '<' looking for beginning of value: "<html><body><h1>408 Request Time-out</h1>\nYour browser didn't send a complete request in time.\n</body></html>\n"`时执行：
```console
$ docker pull ubuntu:18.04
```
