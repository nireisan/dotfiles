#!/usr/bin/env bash

set -ex

gitdir=`pwd | sed 's|/setup$||'`

[ ! -d ~/bin/pseudo ] && mkdir -p ~/bin/pseudo
[ ! -d ~/bin/cygwin ] && mkdir -p ~/bin/cygwin

if [[ `uname` = CYGWIN* ]]; then
    # Windowsのメッセージの文字コードをcp932からutf-8に変更
    # なぜか英語になっちゃう
    cmd /c chcp 65001

    # cygwinのlnをmklinkで実行する
    if [ ! -x ~/bin/cygwin/ln ]; then
        # curl -L https://raw.github.com/tmsanrinsha/dotfiles/master/bin/cygwin/ln > ~/bin/cygwin/ln
        # chmod a+x ~/bin/cygwin/ln
        cp $gitdir/bin/cygwin/ln ~/bin/cygwin/ln
        alias ln="~/bin/cygwin/ln"
    fi
fi

# リンクの作成とダウンロード
for file in `find ..  -type f ! -regex '.*README.*' ! -regex '.*\.git.*' ! -regex '.*swp.*' ! -regex '.*setup.*' ! -regex '.*\.ssh.*' | sed 's|../||'`
do
    if [ ! -L ~/$file ];then
        if [ -f ~/$file ]; then
            mv ~/$file ~/${file}.bak
        fi
        ln -sv $gitdir/$file ~/$file
    fi
done
# [ ! -f ~/.gitconfig ] && cp $gitdir/.gitconfig ~/.gitconfig

# http://betterthangrep.com/
# if [ ! -x ~/bin/ack ];then
#     curl http://betterthangrep.com/ack-standalone > ~/bin/ack
#     chmod a+x ~/bin/ack
# fi

if [ ! -x ~/bin/pseudo/git ];then
    # http://d.hatena.ne.jp/hnw/20120602
    # https://github.com/hnw/fakegit
    curl -L https://raw.github.com/hnw/fakegit/master/bin/fakegit > ~/bin/pseudo/git
    chmod a+x $HOME/bin/pseudo/git
fi

# bin
# [ ! -d ~/bin ] && mkdir ~/bin
# for file in `find ../bin -maxdepth 1 -type f ! -regex '.*swp.*' | sed 's|../||'`
# do
#     [ ! -f ~/$file ] && ln -sv $gitdir/$file ~/$file
# done

if [[ `uname` = CYGWIN* ]]; then
    if [ ! -x ~/bin/cygwin/apt-cyg ]; then
        curl -kL http://apt-cyg.googlecode.com/svn/trunk/apt-cyg > ~/bin/cygwin/apt-cyg
        chmod a+x ~/bin/cygwin/apt-cyg
    fi

    if which ssh 1>/dev/null 2>&1; then
        apt-cyg install openssh
    fi

    # cygwinでpageantを使う
    # http://sanrinsha.lolipop.jp/blog/2012/08/cygwin%E3%81%A7pageant%E3%82%92%E4%BD%BF%E3%81%86.html
    if [ ! -x /usr/bin/ssh-pageant ]; then
        cd /usr/src
        curl -L https://github.com/downloads/cuviper/ssh-pageant/ssh-pageant-1.1-release.tar.gz | tar  zxvf -
        cd ssh-pageant-1.1
        cp ssh-pageant.exe /usr/bin/
        cp ssh-pageant.1 /usr/share/man/man1/
    fi
fi

# zsh
if [ ! -d ~/git/z ]; then
    test -d ~/git || mkdir ~/git
    git clone git://github.com/rupa/z.git ~/git/z
    test -d ~/.zsh/plugin || mkdir -p ~/.zsh/plugin
    ln -s ~/git/z/z.sh ~/.zsh/plugin
    test -d ~/local/man/man1 || mkdir -p ~/local/man/man1
    ln -s ~/git/z/z.1 ~/local/man/man1
    test -d ~/.z || mkdir -p ~/.z
fi

# vim
if [ ! -d ~/.vim/bundle/neobundle.vim ] && which git 1>/dev/null 2>&1;then
    mkdir -p ~/.vim/bundle
    git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

# cpanm
if ! which cpanm 1>/dev/null 2>&1;then
    source cpanm.sh
fi
cpanm --skip-installed MIME::Base64
cpanm --skip-installed App::Ack
