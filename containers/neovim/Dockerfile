# Podmanはコンテナのビルド用のファイルを、以下のいずれかの名前で作成して使うことができる。
# 1. Containerfile
# 2. Dockerfile
# Ref: https://docs.podman.io/en/latest/markdown/podman-build.1.html
# > For this document, a file referred to as a Containerfile can be a file named either ‘Containerfile’ or ‘Dockerfile’.
FROM docker.io/library/debian:10.13

# ロケールとGitのバージョンを変数として定義
ENV LANGUAGE=ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV GIT_VERSION=v2.41.0
ENV MAKE_PREFIX=/usr/local
ENV TMP_DIR_FOR_BUILD_NVIM=/tmp/neovim
ENV RUST_HOME /usr/local/lib/rust
ENV RUSTUP_HOME ${RUST_HOME}/rustup
ENV CARGO_HOME ${RUST_HOME}/cargo

# 一度のRUNコマンドでパッケージのインストールとクリーンアップを行う
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
       gettext=0.19.8.1-9 \
       libcurl4-gnutls-dev=7.64.0-4+deb10u6 \
       libexpat1-dev=2.2.6-2+deb10u6 \
       libghc-zlib-dev=0.6.2-2+b2 \
       libssl-dev=1.1.1n-0+deb10u5 \
       make=4.2.1-1.2 \
       wget=1.20.1-1.1 \
       apt-transport-https=1.8.2.3 \
       autoconf=2.69-11 \
       automake=1:1.16.1-4 \
       ca-certificates=20200601~deb10u2 \
       cmake=3.13.4-1 \
       coreutils=8.30-3 \
       curl=7.64.0-4+deb10u6 \
       doxygen=1.8.13-10 \
       fd-find=7.2.0-2 \
       fzf=0.17.5-2+b10 \
       g++=4:8.3.0-1 \
       gnupg=2.2.12-1+deb10u2 \
       libtool=2.4.6-9 \
       libtool-bin=2.4.6-9 \
       locales=2.28-10+deb10u2 \
       npm=5.8.0+ds6-4+deb10u2 \
       pkg-config=0.29-6 \
       python3-pip=18.1-5 \
       ripgrep=0.10.0-2 \
       sudo=1.8.27-1+deb10u5 \
       tar=1.30+dfsg-6 \
       unzip=6.0-23+deb10u3 \
       wget=1.20.1-1.1 \
       zip=3.0-11+b1  \
    && sed -i "/${LANG}/s/^# //g" /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s "$(which fdfind)" /usr/bin/fd

# Gitのビルド
WORKDIR /tmp
RUN wget -q https://github.com/git/git/archive/${GIT_VERSION}.tar.gz \
    && tar -xzf ${GIT_VERSION}.tar.gz \
    && cd git-* \
    && make prefix=${MAKE_PREFIX} all \
    && make prefix=${MAKE_PREFIX} install

# Neovimのビルド
WORKDIR /tmp
RUN git clone https://github.com/neovim/neovim ${TMP_DIR_FOR_BUILD_NVIM} \
    && cd /tmp/neovim \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo \
    && make install \
    && rm -fr ${TMP_DIR_FOR_BUILD_NVIM}

# Node.jsのインストール
WORKDIR /tmp
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs --no-install-recommends \
    && npm install -g pnpm typescript

# Rustのインストール
WORKDIR /usr/local/lib/rust
RUN chmod 755 ${RUST_HOME} && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ${RUST_HOME}/rustup.sh && \
    chmod +x ${RUST_HOME}/rustup.sh && \
    ${RUST_HOME}/rustup.sh -y --default-toolchain nightly --no-modify-path

ENV PATH ${PATH}:${CARGO_HOME}/bin

# 非rootユーザー 'nvim' の追加とsudo設定
RUN adduser --disabled-password --gecos '' nvim \
    && adduser nvim sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /hoge/nvim
RUN mkdir -p ~/.config/nvim \
    && mkdir -p ~/.config/share

WORKDIR /home/nvim
