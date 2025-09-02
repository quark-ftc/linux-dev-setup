#! /usr/bin/env bash

script_dir=$(dirname "${BASH_SOURCE[0]}")
util_function_path="${script_dir}/../lib/util_function.sh"

# shellcheck source=../lib/util_function.sh
source "$util_function_path"

user='ftc'
user_shell_path=$(sudo grep -E "^${user}:" /etc/passwd | awk -F ":" '{print $NF}')
zim_path="/home/${user}/.zim/zimfw.zsh"

function set_zsh_as_default_shell() {
    if ! type zsh &>/dev/null; then
        echo "错误：未安装 zsh。请先安装 zsh 再执行本脚本。"
        return 1
    fi

    if [[ $user_shell_path =~ zsh ]]; then
        echo "当前默认 shell 已经是 zsh ,无需设置"
        return 0
    fi

    if ! chsh -s "$(which zsh)" "$user"; then
        echo "错误：修改 ${user} 的默认 shell 为 zsh 失败。"
        return 1
    fi

    local zshrc_path="/home/${user}/.zshrc"

    if ! create_file_if_not_exist "$zshrc_path"; then
        return 1
    fi

}

function install_zim() {

    if is_file_exist "$zim_path"; then
        echo "zim 已经安装在路径 ${zim_path} 中，不需要重复安装"
        return 0
    fi

    sudo -u "$user" curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | sudo -u ftc zsh
}

function install_powerlevel10k_by_zim() {

    if ! is_file_exist "$zim_path"; then
        echo "错误：zim 未 安装，请先安装 zim"
        return 1
    fi

    local zimrc_path="/home/${user}/.zimrc"
    if ! is_file_exist "$zimrc_path"; then
        echo "错误：zim 配置文件 ${zimrc_path} 不存在。"
        return 1
    fi

    local powerlevel10k_module_path="/home/${user}/.zim/modules/powerlevel10k"

    if [ -d "$powerlevel10k_module_path" ]; then
        echo "powerlevel10k 已经安装在路径 ${powerlevel10k_module_path} 中，不需要重复安装"
        return 0
    fi

    if ! grep -q 'zmodule romkatv/powerlevel10k' "$zimrc_path"; then
        cat >>"$zimrc_path" <<EOF

############################## 由于 ftc 的初始化脚本插入 ##############################

# powerlevel10k
zmodule romkatv/powerlevel10k

############################## 由于 ftc 的初始化脚本插入 ##############################
EOF
    fi

    if ! sudo -u "$user" zsh -i -c "zimfw install"; then
        echo "错误：安装 powerlevel10k 失败"
        return 1
    fi

}
