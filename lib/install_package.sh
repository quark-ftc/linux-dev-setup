#! /usr/bin/env bash

script_dir=$(dirname "${BASH_SOURCE[0]}")

util_function_path="${script_dir}/util_function.sh"

# shellcheck source=util_function.sh
source "${util_function_path}"

generate_packages=(
    # zsh
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    # autojump

    # bash
    bash-completion

    # 文本编辑
    vim
    neovim

    # shell-script
    shfmt
    shellcheck
    direnv
    # 系统工具
    rsync
    plocate
    tree
    which
    tmux
    less
    man-db
    htop
    wget
    curl
    tldr
    diffutils
    unzip
    # telnet
    # gnu-netcat
    nmap
    # itop
    # dig
    fastfetch
    openssh

    # ASCII 艺术与终端玩具
    lolcat
    cowsay
    figlet
    sl

    # 开发工具
    git

    # c/c++
    clang
    gcc

    # nodejs
    pnpm
    yarn

    # 数据库
    postgresql

    # 其他依赖
    libaio
    base-devel
)

############################## Arch Linux ##############################
function set_pacman_mirror() {
    # shellcheck disable=SC2016
    local aliyun_mirror='http://mirrors.aliyun.com/archlinux/$repo/os/$arch'
    local mirror_string="Server = ${aliyun_mirror}"
    local mirror_list_dir='/etc/pacman.d'
    local mirror_list_path="${mirror_list_dir}/mirrorlist"
    local temp_mirror_list_path="${mirror_list_path}.tmp"

    if ! grep -qF "$aliyun_mirror" "$mirror_list_path"; then
        if ask_for_confirmation "是否需要写入阿里镜像源？"; then
            if ! cp -pf "$mirror_list_path" "${mirror_list_dir}/mirrorlist.backup.$(date +%Y-%m-%d_%H-%M-%S)"; then
                echo "错误：备份 ${mirror_list_path} 失败"
                return 1
            fi
            echo "$mirror_string" | cat - "$mirror_list_path" >"$temp_mirror_list_path" && mv -f "$temp_mirror_list_path" "$mirror_list_path" && rm -f "${temp_mirror_list_path}"
        fi
    fi

    if ! sudo pacman -Syyu --noconfirm; then
        echo '错误：同步镜像数据失败' >&2
        return 1
    fi
}
function install_package_by_pacman() {

    type pacman &>/dev/null || {
        echo '错误：pacman 命令不存在，请检查发行版和包管理器' 1>&2
        return 1
    }

    if ! set_pacman_mirror; then
        return 1
    fi

    local packages="${generate_packages[*]}"

    # shellcheck disable=SC2068
    sudo pacman -S ${packages[@]} --verbose --needed

}
############################## Arch Linux ##############################

function install_package() {
    local distribution
    distribution=$(detect_distribution)

    if [[ $distribution =~ [aA]rch ]]; then
        install_package_by_pacman
    fi
}
