# nekocharm

已经不想再在各种奇怪的机器上配环境了……

很多人都遇到过这种情况，远程机器上的一个账号，四五个人用，同时每个人还有自己喜欢的 shell、tmux、vim 配置。这种情况下，dotfiles 管理已然成为一种折磨。

所以，快来使用 nekocharm 吧。它会给每个人建立一个虚拟的家目录，这样大家的 dotfiles 就不会互相打架了。

## 配置方法

1. 安装

将 `bashrc` 中的内容附到远程机器上 `~/.bashrc` 末尾即可。

2. 配置

首先，你需要给自己的虚拟家目录起一个好听的名字。这里以 `nekoneko` 为例。注意，实际使用时需要把 `nekoneko` 换成你自己起的好听的虚拟家目录的名字。

你可以 **先登录远程机器** ，然后配置 `export NEKONAME=nekoneko` 来完成配置；也可以 **修改本地的 ssh 配置文件** 。例如：

```plain
Host warmhome
    Hostname 172.27.68.56
    User jyi2ya
    RemoteCommand env NEKONAME=nekoneko bash -l
```

3. 使用

配置完成后，使用 `nekocharm` 命令即可进入虚拟的家目录。