#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$0")
NC="$(tput sgr0)"
RED="$(tput setaf 1)"
GRN="$(tput setaf 2)"
YEL="$(tput setaf 3)"

install_system_packages() {
    local brewurl os

    os="$(uname)"
    printf "${YEL}OS is $os.${NC}\n"

    case "$os" in
        Darwin)
            brewurl="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            if command -v brew &> /dev/null; then
                printf "${GRN}Homebrew is already installed :-)\n${NC}"
            else
                printf "${YEL}Attempting to install Homebrew...\n${NC}"
                /bin/bash -c "$(curl -fsSL "$brewurl")" || \
                    # https://nanxiao.me/en/fix-permission-denied-rb_file_s_symlink-error-of-installing-homebrew/
                    sudo chown -R $(whoami) $(brew --prefix)/* || return 1
                brew update --force || return 1
            fi
            brew install $(cat "$SCRIPT_DIR"/brew.list) || return 1
            ;;
        Linux)
            source /etc/os-release
            printf "${YEL}Linux distribution is $ID.${NC}\n"
            case "$ID" in
                debian|neon|ubuntu|raspbian)
                    sudo apt -y update && sudo apt -y full-upgrade && \
                        sudo apt -y install $(cat "$SCRIPT_DIR"/deb.list) || \
                            return 1
                    ;;
                centos|fedora*)
                    sudo dnf upgrade && \
                        sudo dnf -y install $(cat "$SCRIPT_DIR"/rpm.list) || \
                            return 1
                    ;;
                *)
                    printf "${RED}$ID is not supported yet...\n${NC}"
                    return 1
                    ;;
            esac
            ;;
        *)
            printf "${RED}$os is not supported.\n${NC}"
            ;;
    esac
    printf "${GRN}Finished installing system packages :-) \n${NC}"
    return 0
}

install_go_packages() {
    go install \
       github.com/rogpeppe/godef@latest \
       github.com/tslight/lazygit.go/cmd/github@latest \
       golang.org/x/tools/cmd/godoc@latest \
       golang.org/x/tools/cmd/goimports@latest \
       golang.org/x/tools/gopls@latest \
        && echo "${GRN}Finished installing Go packages :-)${NC}"
}

install_npm_packages() {
    sudo npm install -g \
         bash-language-server \
         dockerfile-language-server-nodejs \
         typescript \
         typescript-language-server \
         vscode-langservers-extracted \
         yaml-language-server \
        && echo "${GRN}Finished installing Node LSP packages :-)${NC}"
}

install_system_packages
install_go_packages
install_npm_packages
