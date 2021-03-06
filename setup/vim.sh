#!/usr/local/bin/bash -x
# 自分のホームディレクトリにVimをインストールする
# 参考にしたサイト
# http://www.glidenote.com/archives/422
# patchesが途中で止まってしまうので最新版にはならない

# CentOSの場合はこちらを参照
# http://d.hatena.ne.jp/deris/20120804/1344080402

# http://www.vim.org/download.phpで最新バージョンを確かめる
VERSION=7.3
# ftp://ftp.vim.org/pub/vim/patchesで最新のパッチを調べる
PATCHES=382

mkdir -p $HOME/local/{bin,src}
cd $HOME/local/src/ || exit 1
# $HOME/loca/srcにDownload
if which curl;then
    curl -O ftp://ftp.vim.org/pub/vim/unix/vim-${VERSION}.tar.bz2 || exit 1
elif which wget;then
    # -Nは上書きのオプション
    wget -N ftp://ftp.vim.org/pub/vim/unix/vim-${VERSION}.tar.bz2 || exit 1
else
    echo 'curlまたはwgetをインストールしてください'
    exit 1
fi
bzip2 -dc vim-${VERSION}.tar.bz2 | tar xvf - || exit 1
cd vim$(echo $VERSION | tr -d .) || exit 1

# patch
mkdir patches
cd patches
if which curl;then
    curl -O ftp://ftp.vim.org/pub/vim/patches/${VERSION}/${VERSION}.[001-${PATCHES}] || exit 1
else
    # -Nは上書きのオプション
    wget -N ftp://ftp.vim.org/pub/vim/patches/${VERSION}/${VERSION}.[001-${PATCHES}] || exit 1
fi

cd $HOME/local/src/vim$(echo $VERSION | tr -d .) || exit 1
# patchの-p0はディレクトリ構造を無視しないオプション
# http://www.koikikukan.com/archives/2006/02/17-235135.php
# patchが途中で止まってしまう
cat patches/${VERSION}.* | patch -p0

# ./configure --helpでオプションの詳細が見れる
# --with-featuresで何が入るかはこちら
# https://sites.google.com/site/vimdocja/various-html#:version
./configure \
--with-features=big \
--enable-multibyte \
--enable-pythoninterp \
--disable-gui \
--without-x \
--prefix=$HOME/local || exit 1
# --with-local-dir=$HOME/local \
# LDFLAGS="-L$HOME/local/lib" \
# CFLAGS="-I$HOME/local/include"

make || exit 1
make install || exit 1
