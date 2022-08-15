# Install
`brew install xquartz`

`brew install socat`

# Setup xquartz
preferences -> Security -> Allow connections from network device

# Run socat
`socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

# Get IP of connection
`ifconfig en0`

It will be the ip address that appears near the start of a line that looks like:
`inet 192.168.0.12 netmask 0xffffff00 broadcast 192.168.0.255`

In this case it would be `192.168.0.12`

# Start the neovim-qt container
`docker run -it -e DISPLAY=<ip-from-above-step>:0 nvim-qt`