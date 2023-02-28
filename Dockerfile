FROM debian:stable-slim

LABEL maintainer=brianhsiung@outlook.com

COPY OpenJDK8U-jre_x64_linux_8u332b09.tar.gz /tmp
COPY LibreOffice_7.2.7_Linux_x86-64_deb.tar.gz /tmp
COPY LibreOffice_7.2.7_Linux_x86-64_deb_langpack_zh-CN.tar.gz /tmp

ENV JAVA_VERSION=8u332 \
    JAVA_HOME=/usr/local/openjdk \
    LIBREOFFICE_VERSION=7.2.7 \
    LIBREOFFICE_HOME=/opt/libreoffice7.2 \
    TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata

# base settings
ENV DEBIAN_FRONTEND noninteractive
RUN set -eux; \
    sed -i -e 's/deb.debian.org/mirrors.163.com/g' -e 's/security.debian.org/mirrors.163.com/g' /etc/apt/sources.list; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        procps \
        fontconfig \
        locales \
        wget \
        gnupg2 \
        tini \
    ; \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; \
    dpkg-reconfigure --frontend=noninteractive locales; \
    update-locale LANG=en_US.UTF-8; \
    rm -rf /etc/localtime; ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    rm -rf /var/lib/apt/lists/*

# openjdk8u332 && Libreoffice7.2 
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libdbus-1-3 libglib2.0-0 libxinerama1 libcups2 libcairo2 libsm6 libx11-xcb1; \ 
    tar Czxf /usr/local/ /tmp/OpenJDK8U-jre_x64_linux_8u332b09.tar.gz; \
    ln -s /usr/local/openjdk-8u332-b09-jre /usr/local/openjdk; \
    tar Czxf /tmp /tmp/LibreOffice_*_Linux_x86-64_deb.tar.gz; \
    dpkg -i /tmp/LibreOffice_*_Linux_x86-64_deb/DEBS/*.deb; \
    tar Czxf /tmp /tmp/LibreOffice_*_Linux_x86-64_deb_langpack_zh-CN.tar.gz; \
    dpkg -i /tmp/LibreOffice_*_Linux_x86-64_deb_langpack_zh-CN/DEBS/*.deb; \
    rm -rf /var/lib/apt/lists/*
    
ENV LANG=en_US.UTF-8 \
    PATH=$PATH:$JAVA_HOME/bin:$LIBREOFFICE_HOME/program

# tesseract-ocr5
RUN set -eux; \
    echo "deb https://notesalexp.org/tesseract-ocr5/bullseye/ bullseye main" > /etc/apt/sources.list.d/notesalexp.list; \
    wget -O /tmp/keyfile https://notesalexp.org/debian/alexp_key.asc; \
    apt-key add /tmp/keyfile; \ 
    apt-get update; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -P /tmp "https://notesalexp.org/tesseract-ocr5/bullseye/pool/main/t/tesseract/libtesseract5_5.1.0-1_$dpkgArch.deb"; \
    wget -P /tmp "https://notesalexp.org/tesseract-ocr5/bullseye/pool/main/t/tesseract/tesseract-ocr_5.1.0-1_$dpkgArch.deb"; \
    wget -P /tmp "https://notesalexp.org/tesseract-ocr5/bullseye/pool/main/t/tesseract-lang/tesseract-ocr-osd_5.0.0~git39-6572757-2_all.deb"; \
    wget -P /tmp "https://notesalexp.org/tesseract-ocr5/bullseye/pool/main/t/tesseract-lang/tesseract-ocr-eng_5.0.0~git39-6572757-2_all.deb"; \
    apt-get install -y --no-install-recommends \
        libarchive13 \
        libharfbuzz0b \
        liblept5 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libgomp1 \
    ; \
    dpkg -i /tmp/*.deb; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    apt-get remove -y wget gnupg2; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/cache/apt/*; \
    rm -rf /tmp/*
