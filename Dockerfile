FROM ubuntu:22.04

# Install required packages
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install sudo
RUN apt-get -y install git
RUN apt-get -y install zsh
RUN apt-get -y install tmux 
RUN apt-get -y install software-properties-common 
RUN apt-get -y install ripgrep 
RUN apt-get -y install wget 
RUN apt-get -y install unzip 
RUN apt-get -y install make 
RUN apt-get -y install gcc 
RUN apt-get -y install pip 

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get -y --no-install-recommends install php 
RUN apt-get -y install composer 

# Install modern NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN sudo bash /tmp/nodesource_setup.sh
RUN apt-get -y install nodejs 

# Install NVim - unstable version
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get -y install neovim

# Add 'developer' user with root access
RUN useradd -ms /bin/bash developer
RUN usermod -aG sudo developer
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the 'developer' user
USER developer
WORKDIR /home/developer

# Set zsh as default shell
RUN sudo chsh -s $(which zsh)

# Copy NVim settings
COPY ./nvim /home/developer/.config/nvim
RUN sudo chown -R developer:developer /home/developer/.config

# Install LuaRocks for Lazy.nvim
RUN sudo apt-get -y --no-install-recommends install lua5.1 liblua5.1
RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
RUN tar zxpf luarocks-3.11.1.tar.gz
WORKDIR /home/developer/luarocks-3.11.1
RUN ./configure && make && sudo make install
RUN sudo luarocks install luasocket
WORKDIR /home/developer
RUN rm luarocks-3.11.1.tar.gz
RUN rm -r luarocks-3.11.1

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Start SSH agent, and add keys
RUN eval `ssh-agent -s`
RUN ssh-add

CMD ["zsh"]

