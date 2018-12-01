FROM ubuntu:18.04
LABEL maintainer="Emmanuel Bruno <emmanuel.bruno@univ-tln.fr"

ENV LC_ALL fr_FR.UTF-8

RUN HOME=root DEBIAN_FRONTEND=noninteractive &&\
	apt-get update && apt-get -y upgrade &&\
	apt-get install -y language-pack-fr &&\
	echo fr_FR.UTF-8 UTF-8 > /etc/locale.gen && locale-gen &&\
	apt-get install -y \
		git \
		zsh \
		wget \
		curl \
		unzip \
		vim \
		emacs-nox \
		tmux &&\
	rm -rf /var/lib/apt/lists/*


RUN cd /usr/local/bin && curl -sL https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar --strip-components=1 -zx docker/docker && curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && base=https://github.com/docker/machine/releases/download/v0.16.0 && curl -L $base/docker-machine-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN useradd -ms /bin/zsh dev 
USER dev
VOLUME /home/dev/workspace
WORKDIR /home/dev/workspace

RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" && zsh -c 'setopt EXTENDED_GLOB && for rcfile in /home/dev/.zprezto/runcoms/^README.md(.N); do ln -s "$rcfile" "/home/dev/.${rcfile:t}"; done'

# Vim Plugins
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &&\
    echo "execute pathogen#infect('~/.vim/bundle/{}')" >> ~/.vimrc &&\
    echo "syntax on" >> ~/.vimrc &&\
    echo "filetype plugin indent on  ">> ~/.vimrc
RUN cd ~/.vim/bundle/ \
    && git clone --depth 1 https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/scrooloose/nerdcommenter \
    && git clone --depth 1 https://github.com/godlygeek/tabular \
    && git clone --depth 1 https://github.com/Raimondi/delimitMate \
    && git clone --depth 1 https://github.com/nathanaelkane/vim-indent-guides \
    && git clone --depth 1 https://github.com/groenewege/vim-less \
    && git clone --depth 1 https://github.com/othree/html5.vim \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/bling/vim-airline \
    && git clone --depth 1 https://github.com/easymotion/vim-easymotion \
    && git clone --depth 1 https://github.com/mbbill/undotree \
    && git clone --depth 1 https://github.com/majutsushi/tagbar \
    && git clone --depth 1 https://github.com/vim-scripts/EasyGrep \
    && git clone --depth 1 https://github.com/jlanzarotta/bufexplorer \
    && git clone --depth 1 https://github.com/kien/ctrlp.vim \
    && git clone --depth 1 https://github.com/scrooloose/nerdtree \
    && git clone --depth 1 https://github.com/jistr/vim-nerdtree-tabs \
    && git clone --depth 1 https://github.com/scrooloose/syntastic \
    && git clone --depth 1 https://github.com/tomtom/tlib_vim \
    && git clone --depth 1 https://github.com/marcweber/vim-addon-mw-utils \
    && git clone --depth 1 https://github.com/vim-scripts/taglist.vim \
    && git clone --depth 1 https://github.com/terryma/vim-expand-region \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
    && git clone --depth 1 https://github.com/fatih/vim-go \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/michaeljsmith/vim-indent-object \
    && git clone --depth 1 https://github.com/terryma/vim-multiple-cursors \
    && git clone --depth 1 https://github.com/tpope/vim-repeat \
    && git clone --depth 1 https://github.com/tpope/vim-surround \
    && git clone --depth 1 https://github.com/vim-scripts/mru.vim \
    && git clone --depth 1 https://github.com/vim-scripts/YankRing.vim \
    && git clone --depth 1 https://github.com/tpope/vim-haml \
    && git clone --depth 1 https://github.com/SirVer/ultisnips \
    && git clone --depth 1 https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/derekwyatt/vim-scala \
    && git clone --depth 1 https://github.com/christoomey/vim-tmux-navigator \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
# Vim Theme
    && git clone --depth 1 https://github.com/altercation/vim-colors-solarized
# Pathogen help tags generation
RUN vim -E -c 'execute pathogen#helptags()' -c q ; return 0


ENV TERM=xterm-256color

CMD zsh

