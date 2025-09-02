#! /usr/bin/env bash

function ask_for_confirmation() {

    if [ -z "$1" ]; then
        echo "错误：${FUNCNAME[0]} 函数使用错误，请传入提示词" >&2
        return 1
    fi

    local user_response=''
    local prompt="$1"

    while true; do
        read -rp "${prompt} (y/n) " user_response
        if [[ "$user_response" =~ ^[yYnN]$ ]]; then
            break
        fi
        echo '请输入 y (是) 或 n (否)' >&2
    done

    if [[ "$user_response" =~ ^[yY]$ ]]; then
        return 0
    fi
    return 1
}

function is_file_exist() {
    local file_path="$1"
    if [ -z "$file_path" ]; then
        echo "错误：${FUNCNAME[0]} 函数使用错误，请传入文件名称" >&2
        return 1
    fi

    if [ -f "$file_path" ]; then
        return 0
    else
        echo "错误：文件 ${file_path} 不存在" >&2
        return 1
    fi
}

function detect_distribution() {

    local release_file_path='/etc/os-release'

    is_file_exist "$release_file_path"

    # shellcheck  source=/etc/os-release
    source "$release_file_path"

    local distribution=$NAME
    local full_distribution=$PRETTY_NAME

    ask_for_confirmation "检测到系统是 ${full_distribution} ,是否正确？"

    local is_user_confirm_distribution=$?

    if [ $is_user_confirm_distribution -eq 0 ]; then
        echo "$distribution"
    else
        echo '检测到的 Linux 发行版不正确，请检查系统' >&2
        return 1
    fi

}

function create_file_if_not_exist() {
    if [ -z "$1" ]; then
        echo "函数 ${FUNCNAME[0]} 使用错误，请传入文件路径"
        return 1
    else
        local file_path="$1"
    fi

    if [ ! -f "${file_path}" ]; then
        if ! ask_for_confirmation "未找到 ${file_path},是否创建？"; then
            echo "未找到 ${file_path} ,并且您没有选项创建。请手动创建后再执行本脚本"
            return 1
        fi
        if ! touch "${file_path}"; then
            echo "错误：创建 ${file_path} 失败。"
            return 1
        fi
    fi
}
