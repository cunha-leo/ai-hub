#!/bin/bash
# Corrige o configuration.yml do Authelia para a v4.39 (identity_validation,
# encryption_key, cookies separados). Histórico da montagem.
set -e
SESSION=$(openssl rand -hex 32)
ENC=$(openssl rand -hex 32)
JWT=$(openssl rand -hex 32)
cat > /root/authelia/config/configuration.yml <<CFG
theme: dark
identity_validation:
  reset_password:
    jwt_secret: $JWT
server:
  address: tcp://0.0.0.0:9091
log:
  level: info
authentication_backend:
  file:
    path: /config/users.yml
    password:
      algorithm: argon2id
access_control:
  default_policy: deny
  rules:
    - domain: auth.upexflow.com
      policy: bypass
    - domain: deepseek.upexflow.com
      policy: one_factor
session:
  secret: $SESSION
  name: authelia_session
  expiration: 1h
  inactivity: 30m
  remember_me: 1M
  cookies:
    - domain: upexflow.com
      authelia_url: https://auth.upexflow.com
      default_redirection_url: https://deepseek.upexflow.com
storage:
  encryption_key: $ENC
  local:
    path: /config/db.sqlite3
notifier:
  filesystem:
    filename: /config/notifications.txt
CFG
echo "OK - configuration.yml corrigido"
