<h1 align="center">frontend-dev-env-setup</h1>

[English](https://github.com/yuzheng14/ubuntu-frontend-setup/blob/main/README.md) | 简体中文

`frontend dev env setup` 致力于提供一个简便的 Linux （目前仅支持 Ubuntu）从刚安装开始一键配置所有前端需要的开发环境。

包含以下特性：

- apt 清华镜像源
  - ca-certificates
  - [清华 https 镜像源](https://mirrors.tuna.tsinghua.edu.cn)
- 简中支持
- git
  - 几个我常用的 git 指令别名
- curl 和 wget
- zsh
  - oh-my-zsh
  - 设为默认 shell
- nvm
  - Nodejs 16
  - nvm 钩子，用于目录下有  `.nvmrc` 时自动切换 node 版本
- nrm
  - 修改为默认使用淘宝镜像源
- python2.7（兼容 `node-sass`）（请使用  `sass` 或者 `sass-embeded` 以替代 `node-sass`， 因为官方已不再支持）
  - 设置指向 python2.7 的 python 软链
- vim
- yarn
- pnpm

<details>
	<summary>目录</summary>


- [开始](#开始)
  - [所需条件](#所需条件)
  - [安装](#安装)
- [代办](#代办)

</details>

## 开始

### 所需条件

- 一个刚安装的 Ubuntu（暂时）或者已经在使用中
- amd64/x84_64 或者 aarch64(arm64) 架构
- bash

### 安装

如果你安装有 curl or wget（通常安装有 curl）, 你可以直接使用以下指令之一进行安装。

```shell
curl -fsSL https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh | bash
```

```shell
wget -qO- https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh | bash
```

如果没有你可以拷贝[这里](https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh)的内容到 `install.sh` 文件然后运行以下指令。

```shell
bash install.sh
```

## 代办

- [ ] i18n 支持
- [ ] 可选择 prompt 支持
- [ ] 更精准地探测是否安装 oh-my-zsh
- [ ] 多系统支持（macOS centOS 等）