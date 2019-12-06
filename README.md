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
3. change settings > region & language > manage installed languages > keyboard input method system > fcitx

### terminal profiles

Change terminal profiles to Front Galaxy 50

```
bash -c  "$(wget -qO- https://git.io/vQgMr)"
```
