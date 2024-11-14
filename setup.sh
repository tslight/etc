pkcon refresh && pkcon update --noninteractive

sudo apt purge --yes \
     nano \
     vim \
    && sudo apt autoremove \
    && echo "Finished purging system packages"

sudo apt install --yes \
     bash-completion \
     build-essential \
     clangd \
     curl \
     ed \
     emacs \
     evtest \
     fortunes \
     gdebi-core \
     git \
     golang \
     htop \
     jq \
     libimage-exiftool-perl \
     locate \
     make \
     mg \
     ncdu \
     neovim \
     nmap \
     npm \
     p7zip \
     python3-flake8 \
     python3-flake8-black \
     python3-ipython \
     python3-pip \
     python3-pip \
     python3-pylsp-* \
     qbittorrent \
     ranger \
     rsync \
     rtorrent \
     shellcheck \
     sl \
     tmux \
     tree \
     unzip \
     w3m \
     w3m-img \
     wget \
     whois \
     xxd \
     zip \
     zsh \
    && echo "Finished installing system packages :-)"

# pip install python-lsp-server
go install \
   github.com/rogpeppe/godef@latest \
   github.com/tslight/lazygit.go/cmd/github@latest \
   golang.org/x/tools/cmd/godoc@latest \
   golang.org/x/tools/cmd/goimports@latest \
   golang.org/x/tools/gopls@latest \
    && echo "Finished installing Go packages :-)"

sudo npm install -g \
     bash-language-server \
     dockerfile-language-server-nodejs \
     typescript \
     typescript-language-server \
     vscode-langservers-extracted \
     yaml-language-server \
    && echo "Finished installing Node LSP packages :-)"
