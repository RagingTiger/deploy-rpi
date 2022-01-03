# libs
source lib/get_input.sh

# funcs
run_ovpn(){
  docker run \
           --name ovpn \
           --restart unless-stopped \
           -v "$(pwd)"/data/ovpn:/etc/openvpn \
           -d \
           -p 1194:1194/udp \
           --cap-add=NET_ADMIN \
           ghcr.io/ragingtiger/docker-openvpn:master
}

run_ddns(){
  docker run \
           --name ddns \
           --restart unless-stopped \
           -d \
           -p 8000:8000/tcp \
           -v "$(pwd)"/data/ddns:/updater/data \
           qmcgaw/ddns-updater
}

main(){
  # setup ovpn
  prompt "Would you like to run OpenVPN? [Y/n]: "
  get_response run_ovpn 'Y' false

  # setup ddns
  prompt "Would you like to run DynamicDNS? [Y/n]: "
  get_response run_ddns 'Y' false
}

# execute
main
