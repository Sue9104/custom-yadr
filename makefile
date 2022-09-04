SHELL := /bin/bash
PLATFORM := $(shell lsb_release -d| awk  '{print $$2}')
all: install update
install: yadr python docker

.PHONY: install yadr vim python rust r perl docker nvm

define youcompleteme
	if [ ! -d $$HOME/.vim/bundle/YouCompleteMe/ ]; then \
		#git config https.proxy http://127.0.0.1:12333;\
		git clone https://github.com/ycm-core/YouCompleteMe.git $$HOME/.vim/bundle/YouCompleteMe/;\
	fi;
  cd $$HOME/.vim/bundle/YouCompleteMe/ && git submodule update --init --recursive && python3 install.py
endef

define miniconda
  if [ ! -x "$$(command -v conda)" ]; then \
		if [ "$(PLATFORM)" == "Linux" ]; then \
			wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $$HOME/Downloads;\
			bash $$HOME/Downloads/Miniconda3-latest-Linux-x86_64.sh -b -f -p $$HOME/miniconda ; \
		else \
			wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -P $$HOME/Downloads;\
			bash $$HOME/Downloads/Miniconda3-latest-MacOSX-x86_64.sh -b -f -p $$HOME/miniconda ; \
		fi;\
	fi;
endef


yadr:
	$(info "Current Operating System is $(PLATFORM)...")
	if [ "$(PLATFORM)" == "Ubuntu" ]; then \
		sudo apt install -y git rake zsh cmake python3-dev ;\
	elif [ "$(PLATFORM)" == "CentOS" ]; then \
		echo "Need Root Permission!!!"; \
	elif [ "$(shell uname)" == "Darwin" ]; then \
		sudo brew install git rake zsh cmake python3-dev ;\
	fi;
	chmod +x config/install_yadr.sh && sh config/install_yadr.sh
	cd $$HOME/.yadr && git submodule update --init --recursive
	[ -d $$HOME/.zsh.after ] || mkdir $$HOME/.zsh.after
	\cp zsh.after/alias.zsh zsh.after/appearance.zsh $$HOME/.zsh.after/

vim:
	\cp vim/.vim* vim/.editorconfig	$$HOME/
	[ -d $$HOME/.vim/ ] || mkdir $$HOME/.vim/ $$HOME/.vim/vundles/
	\cp vim/vundles.vim $$HOME/.vim/
	# \sed -i '/neocomplete/d; /snipmate/d' $$HOME/.vim/vundles/*vundle
	\cp vim/vim-enhancements.vundle $$HOME/.vim/vundles/
	$(call youcompleteme)
	vim +PluginInstall +qall
	\cp vim/snips/* $$HOME/.vim/bundle/vim-snippets/UltiSnips/
	\cp vim/global_extra_conf.py $$HOME/

snips:
	\cp vim/snips/* $$HOME/.vim/bundle/vim-snippets/UltiSnips/

python:
	ifeq (,$(shell which conda))
		$(error "Please Install Anaconda first")
	\cp config/.condarc $$HOME/.condarc
	[ -d $$HOME/miniconda/envs/test3/ ] || $$HOME/miniconda/bin/conda create -y -n test3 python=3
	source $$HOME/miniconda/bin/activate test3 && \
		pip install -r config/python.packages
	\cp zsh.after/python.zsh $$HOME/.zsh.after/

rust:
	curl https://sh.rustup.rs -sSf | sh
	\cp zsh.after/rust.zsh $$HOME/.zsh.after/
	\cp config/cargo.config $$HOME/.cargo/config
	$$HOME/.cargo/bin/rustup install stable && $$HOME/.cargo/bin/rustup default stable
	$$HOME/.cargo/bin/rustup component add rust-src
	cd $$HOME/.vim/bundle/YouCompleteMe/ && git submodule update --init --recursive && python install.py --rust-completer

perl:
	if [ "$(PLATFORM)" == "Linux" ]; then \
		sudo apt-get install -y perl;\
	else \
		sudo brew install perl;\
	fi;
	\cp zsh.after/perl.zsh $$HOME/.zsh.after/
	curl -L https://cpanmin.us | perl - App::cpanminus
	cpanm --local-lib=$$HOME/perl5 local::lib && eval $$(perl -I $HOME/perl5/lib/perl5/ -Mlocal::lib)
	cpanm App::perlbrew

r:
	\cp config/Rprofile $$HOME/.Rprofile

nvm:
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
	\cp zsh.after/nvm.zsh $$HOME/.zsh.after/
	[ -s "$$HOME/.nvm/nvm.sh" ] && \. "$$HOME/.nvm/nvm.sh"
	nvm install node cytoscape


docker:
	if [ "$(PLATFORM)" == "Linux" ]; then \
		echo "please read https://docs.docker.com/install/linux/docker-ce/ubuntu/ for details" ;\
  	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common ;\
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ;\
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" ;\
    sudo apt-get update ;\
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io ;\
    sudo groupadd docker && sudo usermod -aG docker $$(whoami| awk '{print $$1}');\
		echo "please read https://docs.docker.com/compose/install/ for details";\
    sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$$(uname -s)-$$(uname -m) -o /usr/local/bin/docker-compose ;\
    sudo chmod +x /usr/local/bin/docker-compose ;\
		sudo echo "DOCKER_OPTS=\"--registry-mirror=https://registry.docker-cn.com\"" >> /etc/default/docker
	else \
		echo "please read https://docs.docker.com/docker-for-mac/install/ for details"; \
	fi;

update:
	cd $$HOME/.yadr && rake update

ubuntu:
	sudo apt update && sudo apt install -y build-essential git vim dconf-tools fcitx-bin fcitx-table dconf-cli uuid-runtime filezilla curl htop python python2.7-dev
	# Chinese font
	sudo apt install -y fonts-droid-fallback fonts-wqy-zenhei fonts-wqy-microhei fonts-arphic-ukai fonts-arphic-uming
	sudo \cp -r win7fonts /usr/share/fonts/
	sudo fc-cache -f -v
	sudo apt install -f -y
	# git init
	git config --global user.name Sue9104
	git config --global user.email sumin2012@163.com
	git config --global core.editor vim
	# chrome
	wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $$HOME/Downloads/
	sudo dpkg -i $$HOME/Downloads/google-chrome-stable_current_amd64.deb
	# ssh
	sudo apt install -y openssh-server
	sudo sed -i 's/#Port/Port/g' /etc/ssh/sshd_config
	sudo ufw allow 22
	sudo service ssh restart
	# ssr
	sudo apt install -y libcanberra-gtk-module libcanberra-gtk3-module gconf2 gconf-service libappindicator1 libssl-dev python
	wget -c https://github.com/qingshuisiyuan/electron-ssr-backup/releases/download/v0.2.6/electron-ssr-0.2.6.deb -P $$HOME/Downloads/
	sudo dpkg -i $$HOME/Downloads/electron-ssr-0.2.6.deb
	# move dash to bottom center
	gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
	gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
	gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
	gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 42
	gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
	gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
