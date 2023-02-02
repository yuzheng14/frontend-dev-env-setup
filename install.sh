#!/bin/bash
tty_black="\033[1;30m"
tty_red="\033[1;31m"
tty_green="\033[1;32m"
tty_yellow="\033[1;33m"
tty_blue="\033[1;34m"
tty_pink="\033[1;35m"
tty_cyan="\033[1;36m"
tty_gray="\033[1;37m"
tty_default="\033[1;39m"
tty_plain="\033[0m"

# 定义 x86_64 和 arm64 系统架构的常量
readonly AMD64="x86_64"
readonly ARM64="aarch64"

# 输出警告信息
warn() {
  echo ${tty_yellow}警告：$1${tty_plain}
}

# 输出错误并退出
abort() {
  echo ${tty_red}错误：$1${tty_plain}
  exit 1
}

# 箭头提示过程
arrow() {
  echo "${tty_blue}==> ${tty_default}$@${tty_plain}"
}

# 检测是否具有 sudo 权限
have_sudo_access() {
  if [[ ! -x /usr/bin/sudo ]]
  then
    return 1
  fi
  
  if [[ -z "${HAVE_SUDO_ACCESS}" ]]
  then
    sudo -v && sudo -l mkdir &>/dev/null
  fi
  HAVE_SUDO_ACCESS="$?"

  if [[ "${HAVE_SUDO_ACCESS}" != 0 ]]
  then
    abort "此程序需要 sudo 权限，请确认你的 sudo 权限后重试"
  fi

  return "${HAVE_SUDO_ACCESS}"
}

execute_sudo() {
  if have_sudo_access
  then
    sudo "$@"
  else
    warn "sudo 权限失活？"
  fi
}

# 检测是否为 sudo 执行
if [ -z "${BASH_VERSION}" ]
then
  abort "当前 shell 程序不是 bash，请使用 bash 执行"
fi

# 检测是否为 ubuntu 系统
if [[ -z $(cat /etc/os-release | grep ID | grep -i ubuntu) ]]
then
  abort "当前系统非 Ubuntu，请使用 Ubuntu 运行此安装脚本"
fi

# 检测系统架构
UNAME_MACHINE=$(uname -m)
if [[ "${UNAME_MACHINE}" != "${AMD64}" ]] && [[ "${UNAME_MACHINE}" != "${ARM64}" ]]
then
  abort "此脚本仅支持 amd64/x86_64 和 arm 64 架构系统"
fi

# 如果运行前没有 sudo 权限则退出后使 sudo 时间戳失效
if [[ -x /usr/bin/sudo ]] && ! sudo -n -v 2>/dev/null
then
  trap '/usr/bin/sudo -k' EXIT
fi

# 执行指令
execute() {
  if ! "$@"
  then
    abort "执行指令 $@ 失败"
  fi
}

# 执行 sudo 指令
execute_sudo() {
  if have_sudo_access
  then
    execute sudo $@
  else
    execute $@
  fi
}

change_apt_source() {
  if [[ "${UNAME_MACHINE}" == "${AMD64}" ]]
  then
    echo 替换 x86_64/amd64 镜像源
    execute_sudo sed -i "s@http://.*archive.ubuntu.com@$1://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
    execute_sudo sed -i "s@http://.*security.ubuntu.com@$1://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
  else
    echo 替换 arm64 镜像源
    execute_sudo sed -i "s@http://ports.ubuntu.com@$1://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
  fi
}

unset HAVE_SUDO_ACCESS

have_sudo_access

if [[ -z "${USER}" ]]
then
  USER="$(id -un)"
fi

arrow 替换 apt 源
if dpkg -l "ca-certificates" | grep "ca-certificates" &>/dev/null
then
  # 如果已经装上了 ca-certificates
  echo "当前已安装 ca-certificates"
  if ! grep https://mirrors.tuna.tsinghua.edu.cn /etc/apt/sources.list &>/dev/null
  then
    # 如果 sources.list 中没有替换源
    change_apt_source "https"
  fi
else
  # 如果没装 ca-certifacates
  echo "当前未安装 ca-certificates"
  # 修改为 http 的源
  change_apt_source "http"
  # 更新软件包列表
  execute_sudo "apt" "update"
  # 安装 ca-certificates
  execute_sudo "apt" "install" "-y" "ca-certifacates"
  # 替换为 https 源
  execute_sudo "sed" "-i" "s@http@https@g" "/etc/apt/sources.list"
fi
execute_sudo "apt" "update"

arrow 配置中文
USER_SHELL_ENV_FILE="~/.profile"
execute_sudo apt install -y language-pack-zh-hans
execute locale-gen zh_CN.UTF-8
execute_sudo echo -e "\n export LANG=zh_CN.UTF-8" >> USER_SHELL_ENV_FILE
execute source USER_SHELL_ENV_FILE

arrow 安装并配置 git
execute_sudo apt install -y git
execute git config --global alias.cam "commit -a -m"
execute git config --global alias.cm "commit -m"
execute git config --global alias.pure "pull --rebase"
execute git config --global alias.lg "log --graph --decorate"
execute git config --global alias.lg1 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
execute git config --global user.name ${git_username}
execute git config --global user.email ${git_email}
execute git config --global credential.helper store

arrow 安装 curl wget 并决定地址
execute_sudo apt install -y curl wget
if curl -fssL https://github.com &>/dev/null
then
  OH_MY_ZSH_REPO=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  NVM_REPO=https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh
else
  OH_MY_ZSH_REPO=https://gitee.com/abeir/oh-my-zsh/raw/master/tools/install.sh
  NVM_REPO=https://gitee.com/yanlong-li/nvm-sh-nvm/raw/v0.39.2-gitee/install.sh

arrow 安装 zsh "&&" oh-my-zsh
execute_sudo apt install -y zsh
execute echo -e "y\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
execute usermod -s /bin/zsh ${USER}

arrow 安装 nvm "&&" node
execute curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
execute cat >> ~/.zshrc <<EOF
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF
execute sed -i "s@https://nodejs.org/dist@https://npmmirror.com/mirrors/node/@g" ~/.nvm/nvm.sh
execute source ~/.zshrc
execute nvm install 16
execute cat >> ~/.zshrc <<EOF
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
EOF
execute source ~/.zshrc

arrow 安装 nrm，设定默认地址为淘宝镜像源
npm install -g nrm --registry=https://registry.npmmirror.com/
nrm use taobao

arrow 安装 python 2 以兼容 node-sass（请尽快迁移至 sass 或 sass-embeded 包）
execute_sudo apt install -y python2
execute_sudo ln-s /usr/bin/python2.7 /usr/bin/python

arrow 安装其他常用软件
execute_sudo apt install -y vim
execute npm install -g yarn pnpm
