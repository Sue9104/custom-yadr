# Custom YADR

integrate [yadr](https://github.com/skwp/dotfiles), [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) and some software setup procedure.

support system:
- Ubuntu
- Mac

included setup:
- docker
- python
- perl
- rust

## install

```
make install
```

## update
```
make update
```

## Ubuntu essential

### sougou pinyin

1. download deb: https://pinyin.sogou.com/linux/?r=pinyin
2. install: sudo dpkg -i \*.deb
3. ibus to fcitx: change settings > region & language > manage installed languages > keyboard input method system > fcitx > Apply System wide
4. add sougou to input: Configure current input method > Sougou Pinyin
5. garbled: cd ~/.config && rm -rf SogouPY* sogou*
6. two icon: sudo apt-get remove fcitx-ui-qimpanel

### terminal profiles

Change terminal profiles to Front Galaxy 50

```
bash -c  "$(wget -qO- https://git.io/vQgMr)"
```

### wechat

> https://github.com/Jactor-Sue/Deepin-Apps-Installation

1. install deepin wechat
2. font in /opt/deepinwine/tools/run.sh : WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"
3. dpi: WINEPREFIX=~/Deepin-WeChat/ deepin-wine winecfg ; then change graphics > dpi
4. update: WINEPREFIX=~/Deepin-WeChat/ deepin-wine WeChatSetup_latest.exe 
