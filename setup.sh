pkcon refresh && pkcon update --noninteractive

sudo apt purge --yes \
     nano \
     vim \
    && sudo apt autoremove \
    && echo "Finished purging system packages"

sudo apt install --yes \
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
