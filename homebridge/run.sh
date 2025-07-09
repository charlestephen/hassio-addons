#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "▶ Starting Homebridge add-on with auto-generated credentials"

STORAGE=$(bashio::config 'storage')
BRIDGE_NAME=$(bashio::config 'bridge_name')
DEBUG_FLAG=""
bashio::config.true 'debug' && DEBUG_FLAG="--debug"

# Ensure storage exists
mkdir -p "${STORAGE}"

# Path to store generated creds
CRED_FILE="${STORAGE}/credentials.json"

# First-run: generate and persist username, pin, and port
if [ ! -f "${CRED_FILE}" ]; then
  bashio::log.info "• Generating new HomeKit credentials"

  # Random MAC-style username: 6 bytes
  USERNAME=$(printf '%02X:%02X:%02X:%02X:%02X:%02X' \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) \
    $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

  # HomeKit PIN: NNN-NN-NNN
  PIN=$(printf '%03d-%02d-%03d' \
    $((RANDOM%1000)) $((RANDOM%100)) $((RANDOM%1000)))

  # Random port in [50000,53000]
  PORT=$(( RANDOM % (53000-50000+1) + 50000 ))

  # Persist
  cat <<EOF > "${CRED_FILE}"
{
  "username": "${USERNAME}",
  "pin": "${PIN}",
  "port": ${PORT}
}
EOF
  bashio::log.success "✔ Generated username=${USERNAME}, pin=${PIN}, port=${PORT}"
else
  # Load existing
  USERNAME=$(jq -r .username "${CRED_FILE}")
  PIN=$(jq -r .pin "${CRED_FILE}")
  PORT=$(jq -r .port "${CRED_FILE}")
  bashio::log.info "• Using existing credentials username=${USERNAME}, pin=${PIN}, port=${PORT}"
fi

# Install declared plugins
for PLUGIN in $(bashio::config 'plugins'); do
  bashio::log.info "• npm install -g ${PLUGIN}"
  npm install -g "${PLUGIN}"
done

# Write or respect custom_config
CUSTOM=$(bashio::config 'custom_config')
if [ -n "${CUSTOM}" ]; then
  bashio::log.info "• Applying user-provided Homebridge config"
  echo "${CUSTOM}" > "${STORAGE}/config.json"
else
  bashio::log.info "• Generating default Homebridge config"
  cat <<EOF > "${STORAGE}/config.json"
{
  "bridge": {
    "name": "${BRIDGE_NAME}",
    "username": "${USERNAME}",
    "port": ${PORT},
    "pin": "${PIN}"
  },
  "accessories": [],
  "platforms": []
}
EOF
fi

bashio::log.info "▶ Launching Homebridge on port ${PORT}"
exec homebridge -U "${STORAGE}" ${DEBUG_FLAG}