<h1 align="center">frontend-dev-env-setup</h1>

English | [简体中文](https://github.com/yuzheng14/ubuntu-frontend-setup/blob/main/README.zh_CN.md)

`frontend dev env setup` aims to provide a conveniently way to configure a frontend development environment from a just installed Linux (temporarily Ubuntu only) (Maybe MacOS could perform perfectly too, but I didn't test it. If you did it, please inform me.) from scratch.

It contains features following:

- apt Tsinghua mirror
  - ca-certificates
  - [Tsinghua https mirror](https://mirrors.tuna.tsinghua.edu.cn)
- zh-hans
- git
  - several git alias that I usually use
- curl and wget
- zsh
  - oh-my-zsh
  - Set as default shell.
- nvm
  - Nodejs 16
  - nvm hook to change node version automatically if there is a `.nvmrc`
- nrm
  - Using taobao mirror defaultly.
- python2.7(to make node-sass compatible)(please move to `sass` or `sass-embeded` instead of `node-sass` because of less of officail support)
  - python symbol link reffered to python2.7
- vim
- yarn
- pnpm

<details>
	<summary>Table of Contents</summary>

- [Getting Started](#getting-started)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
- [Todo](#todo)

</details>

## Getting Started

### Prerequisites

- Ubuntu ( temporarily )
- amd64/x84_64 or aarch64(arm64)
- bash

### Installation

If you have curl or wget, you can run command following.

```shell
curl -fsSL https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh | bash
```

```shell
wget -qO- https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh | bash
```

Otherwisely you can copy content [here](https://raw.githubusercontent.com/yuzheng14/frontend-dev-env-setup/main/install.sh) into `install.sh` and run command following.

```shell
bash install.sh
```

## Todo

- [ ] i18n support
- [ ] choosable prompt support
- [ ] more accurate oh-my-zsh detection
