# BUILD:
# `docker build -t nvim .`

# RUN:
# `docker run -it -v <volume-name>:/code nvim`
# Note: you need to create a docker volume first

# Use apline linux as base image
FROM alpine
LABEL Name=nvim Version=0.0.1

# Persistent volume
ARG PERSISTENT_VOLUME=/code

# Create folder to mount volume for persistent code storage
RUN mkdir $PERSISTENT_VOLUME

# Create environment variable so vim startify knows where to save sessions (as defined in init.vim)
ENV PERSISTENT_VOLUME=$PERSISTENT_VOLUME

# Copy custom neovim config to location neovim expects
COPY init.vim /root/.config/nvim/

# Update linux so we can install linux packages
RUN apk update && apk upgrade

# Add linux packages
RUN apk add neovim # Needed to install neovim
RUN apk add curl # Needed to download vim-plug
RUN apk add git # Needed to download vim plugins

# Download vim plug for neovim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Run vim plug to install all plugins defined in init.vim
RUN nvim +PlugInstall +qall

# Start in persistent volume folder
WORKDIR $PERSISTENT_VOLUME

# Start neovim
CMD nvim