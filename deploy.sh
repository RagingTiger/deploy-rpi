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

run_pihole(){
  # https://github.com/pi-hole/docker-pi-hole/blob/master/README.md
  # setting data dir
  PIHOLE_BASE="data/pihole"

  # checking for data dir
  [[ -d "$PIHOLE_BASE" ]] || \
  { echo "Please run setup to create data directory: $PIHOLE_BASE"; exit 1; }

  # get server address
  local server_addr="$(sudo cat "$PIHOLE_BASE/.SERVER_ADDR")"

  # Note: ServerIP should be replaced with your external ip.
  docker run -d \
      --name pihole \
      -p 53:53/tcp -p 53:53/udp \
      -p 9000:80 \
      -e TZ="America/Chicago" \
      -v "$(pwd)/${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
      -v "$(pwd)/${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
      --dns=127.0.0.1 --dns=1.1.1.1 \
      --restart=unless-stopped \
      --hostname pi.hole \
      -e VIRTUAL_HOST="pi.hole" \
      -e PROXY_LOCATION="pi.hole" \
      -e ServerIP="$server_addr" \
      pihole/pihole:latest

  # Pihole start up
  printf 'Starting up pihole container '
  for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
      printf ' OK'
      echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:')
               for your pi-hole: https://${server_addr}:9000/admin"
      exit 0
    else
      sleep 3
      printf '.'
    fi

    if [ $i -eq 20 ] ; then
      echo -e "\nTimed out waiting for Pi-hole start, consult
               your container logs for more info (\`docker logs pihole\`)"
      exit 1
    fi
  done;
}

main(){
  # deploy ovpn
  prompt "Would you like to run OpenVPN? [Y/n]: "
  get_response run_ovpn 'Y' false

  # deploy ddns
  prompt "Would you like to run DynamicDNS? [Y/n]: "
  get_response run_ddns 'Y' false

  # deploy pihole
  prompt "Would you like to run Pi-hole? [Y/n]: "
  get_response run_pihole 'Y' false
}

# execute
main
