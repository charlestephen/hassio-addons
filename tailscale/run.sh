#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "▶ Starting Tailscale daemon"

# Required values
bashio::log.blue "• Using state file: $(bashio::config 'state_file')"
bashio::config.require 'auth_key'
AUTH_KEY=$(bashio::config 'auth_key')

# Launch tailscaled
tailscaled --state="$(bashio::config 'state_file')" &
sleep 2

# Build flags
FLAGS="--authkey=${AUTH_KEY} --state=${STATE_FILE}"
bashio::config.true 'exit_node' && \
  FLAGS="${FLAGS} --exit-node=$(bashio::config 'exit_node_ip')"
bashio::config.true 'advertise_routes' && \
  FLAGS="${FLAGS} --advertise-routes=$(bashio::config 'advertise_routes')"
bashio::config.true 'accept_routes' && FLAGS="${FLAGS} --accept-routes"
bashio::config.true 'host_stack' && FLAGS="${FLAGS} --net=userspace"

bashio::log.info "▶ tailscale up ${FLAGS}"
tailscale up ${FLAGS}

bashio::log.success "✔ Tailscale is up and running"
sleep infinity