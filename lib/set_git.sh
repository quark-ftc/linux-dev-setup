#! /usr/bin/env bash

function set_global_git_config() {
    # 设置用户信息（必需）
    git config --global user.name "Fang Tiancong"
    git config --global user.email "2830923997@qq.com"

    # 设置默认编辑器
    git config --global core.editor "code --wait"

    # 设置默认分支名
    git config --global init.defaultBranch "main"

    # 设置换行符处理（Linux/Mac）
    # true : 提交时 CRLF -> LF;检出时 LF -> CRLF。推荐 Linux/Mac 用户使用
    # input: 提交时 CRLF -> LF;检出时不变。推荐 windows 用户使用
    # false: 不进行转换
    git config --global core.autocrlf input

    # 设置文件权限变更检测
    git config --global core.filemode true

    # 设置大小写敏感（推荐）
    git config --global core.ignorecase false

    cat <<EOF
========================================
Git 全局配置已完成！
========================================

git config --global user.name "Fang Tiancong"
git config --global user.email "2830923997@qq.com"

# 设置默认编辑器
git config --global core.editor "code --wait"

# 设置默认分支名
git config --global init.defaultBranch "main"

# 设置换行符处理（Linux/Mac）
# true : 提交时 CRLF -> LF;检出时 LF -> CRLF。推荐 Linux/Mac 用户使用
# input: 提交时 CRLF -> LF;检出时不变。推荐 windows 用户使用
# false: 不进行转换
git config --global core.autocrlf input

# 设置文件权限变更检测
git config --global core.filemode true

# 设置大小写敏感（推荐）
git config --global core.ignorecase false

========================================
EOF
}
