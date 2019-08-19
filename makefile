SHELL := /bin/bash
PLATFORM := $(shell uname)
all: install update
install: yadr python docker

.PHONY: install yadr vim python rust r perl docker

define youcompleteme
	if [ ! -d $$HOME/.vim/bundle/YouCompleteMe/ ]; then \
		git clone git@github.com:Valloric/YouCompleteMe.git $$HOME/.vim/bundle/YouCompleteMe/;\
	fi;
	git config http.proxy http://127.0.0.1:12333
  cd $$HOME/.vim/bundle/YouCompleteMe/ && git submodule update --init --recursive && python install.py
endef

define miniconda
  if [ ! -x "$$(command -v conda)" ]; then \
		wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh ;\
		wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh ;\
		if [ "$(PLATFORM)" == "Linux" ]; then \
			bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $$HOME/miniconda ; \
		else \
			bash Miniconda3-latest-MacOSX-x86_64.sh -b -f -p $$HOME/miniconda ; \
		fi;\
	fi;
endef


yadr:
	if [ "$(PLATFORM)" == "Linux" ]; then \
		sudo apt install git rake zsh;\
	else \
		sudo brew install git rake zsh;\
	fi;
	git submodule update --init --recursive
	chmod +x yadr/install.sh && ./yadr/install.sh
	[ -d $$HOME/.zsh.after ] || mkdir $$HOME/.zsh.after
	\cp zsh.after/alias.zsh zsh.after/appearance.zsh $$HOME/.zsh.after/

vim: yadr
	\cp vim/.vim* vim/.editorconfig	$$HOME/
	[ -d $$HOME/.vim/ ] || mkdir $$HOME/.vim/
	\cp vim/vundles.vim $$HOME/.vim/ $$HOME/.vim/vundles/
	\sed -i '/neocomplete/d; /snipmate/d' $$HOME/.vim/vundles/*vundle
	\cp vim/vim-enhancements.vundle $$HOME/.vim/vundles/
	$(call youcompleteme)
	vim +PluginInstall +qall
	\cp vim/snips/* $$HOME/.vim/bundle/vim-snippets/UltiSnips/
	\cp vim/global_extra_conf.py $$HOME/

python:
	$(call miniconda)
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
		sudo apt-get install perl;\
	else \
		sudo brew install perl;\
	fi;
	\cp zsh.after/perl.zsh $$HOME/.zsh.after/
	curl -L https://cpanmin.us | perl - App::cpanminus
	cpanm --local-lib=$$HOME/perl5 local::lib && eval $$(perl -I $HOME/perl5/lib/perl5/ -Mlocal::lib)
	cpanm App::perlbrew

r:
	\cp config/Rprofile $$HOME/.Rprofile

docker:
	if [ "$(PLATFORM)" == "Linux" ]; then \
		echo "please read https://docs.docker.com/install/linux/docker-ce/ubuntu/ for details" ;\
  	sudo apt-get install apt-transport-https ca-certificates curl software-properties-common ;\
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ;\
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" ;\
    sudo apt-get update ;\
    sudo apt-get install docker-ce docker-ce-cli containerd.io ;\
    sudo groupadd docker && sudo usermod -aG docker $$(who am i| awk '{print \$1}');\
		echo "please read https://docs.docker.com/compose/install/ for details";\
    sudo curl -L https://github.com/docker/compose/releases/download/1.24/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose ;\
    sudo chmod +x /usr/local/bin/docker-compose ;\
	else \
		echo "please read https://docs.docker.com/docker-for-mac/install/ for details"; \
	fi;

update:
	cd $$HOME/.yadr && rake update
