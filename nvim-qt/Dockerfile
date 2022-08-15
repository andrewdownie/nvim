# BUILD:
# `docker build -t nvim-qt .`

# RUN:
# - `docker run -it -e DISPLAY=<display-address>:0 nvim-qt` # x11 forwarding needs to be setup. See setup folder instructions.

# Use debian linux as base image
FROM debian
LABEL Name=nvim-qt Version=0.0.1

# Path to persistent volume
ARG PERSISTENT_VOLUME=/code

# Create folder to mount volume for persistent code storage
RUN mkdir $PERSISTENT_VOLUME

# Create environment variable so vim startify knows where to save sessions (as defined in init.vim)
ENV PERSISTENT_VOLUME=$PERSISTENT_VOLUME

# Copy custom neovim config to location neovim expects
COPY init.vim /root/.config/nvim-qt/

# Update Linux so we can install Linux packages
RUN apt-get update -y

# Install Linux Packages
RUN apt-get install neovim-qt -y # Install neovim
RUN apt-get install curl -y # Needed to install vim-plug
RUN apt-get install git -y # Needed to install vim plugins with vim-plug

# Download vim plug for neovim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Run vim plug to install all plugins defined in init.vim
# RUN nvim +PlugInstall +qall

# TODO: install nvim-qt plugins from command line
