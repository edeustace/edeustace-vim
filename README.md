### Introduction
My vim config and plugins

### Installation
        cd ~
        mkdir vim_config
        cd vim_config
        git clone git@github.com:edeustace/edeustace-vim.git
        cd ~
        ln -s ~/vim_config/edeustace-vim/ .vim
        ln -s ~/vim_config/edeustace-vim/.vimrc .vimrc
        cd ~/.vim
        git submodule init
        git submodule update

You'll then need to build command-t, see command-t installation instructions for details. Basically you'll need to install the same ruby version as the one that runs in vim. Then you need to cd to the command-t bundle folder and run ````rake make````.


