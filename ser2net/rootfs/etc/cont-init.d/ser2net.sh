#!/usr/bin/with-contenv bashio

data_port=12345
admin_port=12346
device_path=$(bashio::config serial_device)
max_connections=$(bashio::config max_connections 1)

# Translate serial_device into a gensio connector string:
#   /dev/...               local serial device
#   socket://HOST:PORT     raw TCP connection to a remote serial server
#   rfc2217://HOST:PORT    telnet/RFC 2217 connection to a remote serial server
#   anything else          passed through to ser2net as a gensio string
case "$device_path" in
  /dev/*)
    connector="serialdev,$device_path,local"
    ;;
  socket://*:* | rfc2217://*:*)
    target=${device_path#*://}
    host=${target%:*}
    host=${host#[}
    host=${host%]}
    connector="tcp,$host,${target##*:}"
    if [[ "$device_path" == rfc2217://* ]]; then
      connector="telnet(rfc2217),$connector"
    fi
    ;;
  *)
    connector=$device_path
    ;;
esac
bashio::log.info "Using connector: $connector"

cat >> /etc/ser2net/ser2net.yaml << EOF

connection: &serport
  accepter: telnet(rfc2217),tcp,$data_port
  timeout: 0 # don't timeout on no activity
  enable: on
  connector: $connector
  options:
    max-connections: $max_connections

EOF
# TODO add a rotator that prints an error saying the port is in use? and then echo?

if bashio::config.true "enable_admin_interface"; then
cat >> /etc/ser2net/ser2net.yaml << EOF

admin:
  accepter: tcp,$admin_port

EOF
fi