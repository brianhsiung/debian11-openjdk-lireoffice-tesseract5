# debian11-openjdk-lireoffice-tesseract5

#### Description
基于Debian11构建的含openjdk8u332，libreoffice7.2，tesseract5的基础镜像

#### Software Architecture

1. Libreoffice下载地址：https://zh-cn.libreoffice.org/download/libreoffice/ 选择稳定版本下载，本例是基于`Debian`构建的镜像，因此需要选择`deb`

![image-20220708101418204](https://brianhsiung.oss-cn-hangzhou.aliyuncs.com/img/image-20220708101418204.png)

> 官方源：
> 
> https://mirrors.nju.edu.cn/tdf/libreoffice/stable/7.2.7/deb/x86_64/LibreOffice_7.2.7_Linux_x86-64_deb.tar.gz
> 
> https://mirrors.nju.edu.cn/tdf/libreoffice/stable/7.2.7/deb/x86_64/LibreOffice_7.2.7_Linux_x86-64_deb_langpack_zh-CN.tar.gz
>
> 国内源：
> 
> https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/7.2.7/deb/x86_64/LibreOffice_7.2.7_Linux_x86-64_deb.tar.gz
>
> https://mirrors.cloud.tencent.com/libreoffice/libreoffice/stable/7.2.7/deb/x86_64/LibreOffice_7.2.7_Linux_x86-64_deb_langpack_zh-CN.tar.gz



2. OpenJDK下载地址：https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases， 在 `GA Release` 中选择合适的 `jre` ，本例为：[OpenJDK8U-jre_x64_linux_8u332b09.tar.gz](https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u332-b09/OpenJDK8U-jre_x64_linux_8u332b09.tar.gz)

3. 将下载的 Libreoffice，openjdk，Dockerfile 上传到一个空目录下，并进行构建

```shell
docker build -t libreoffice-tesseract-ocr5-bullseye:openjdk-8-jre-base-v1.0 .
```

4. 镜像只包含几款基础字体，如果需要其他字体，可单独安装，如：

```dockerfile
FROM libreoffice-tesseract-ocr5-bullseye:openjdk-8-jre-base-v1.0 .

COPY myfonts /usr/share/fonts/myfonts
```
