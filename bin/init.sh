#!/usr/bin/env bash

script_dir=$(dirname "${BASH_SOURCE[0]}")

install_package_path="${script_dir}/../lib/install_package.sh"
set_zsh_path="${script_dir}/../lib/set_zsh.sh"
set_git_path="${script_dir}/../lib/set_git.sh"

# shellcheck source=../lib/install_package.sh
source "$install_package_path"

# shellcheck source=../lib/set_zsh.sh
source "$set_zsh_path"

# shellcheck source=../lib/set_git.sh
source "$set_git_path"

function main() {

    if ask_for_confirmation "是否需要安装常用软件包？"; then
        # if ! install_package; then
        #     return 1
        # fi

        install_package
    fi

    if ask_for_confirmation "是否需要将 zsh 设置为默认 shell?"; then
        # if ! set_zsh_as_default_shell; then
        #     return 1
        # fi

        set_zsh_as_default_shell
    fi

    if ask_for_confirmation "是否安装 使用 zim 管理 zsh 插件？"; then

        # if ! install_zim; then
        #     return 1
        # fi

        install_zim
    fi

    if ask_for_confirmation "是否安装 powerlevel10k 主题？"; then
        install_powerlevel10k_by_zim
    fi

    if ask_for_confirmation "是否设置 git 全局配置？"; then
        set_global_git_config
    fi

}

main
