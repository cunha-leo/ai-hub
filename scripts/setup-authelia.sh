#!/bin/bash
# Setup inicial do Authelia: gera credenciais, hash de senha e a config base.
# ATENÇÃO: versão histórica (one_factor, sem 2FA/SMTP). A config final atual
# está documentada em authelia/configuration.example.yml.
set -e
mkdir -p /root/.secrets /root/authelia/config
OUT=$(docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --random 2>&1)
PASS=$(echo "$OUT" | sed -n 's/^Random Password: //p')
HASH=$(echo "$OUT" | sed -n 's/^Digest: //p')
if [ -z "$PASS" ] || [ -z "$HASH" ]; then echo "ERRO credenciais"; exit 1; fi
echo "$PASS" > /root/.secrets/dsh-login.txt
chmod 600 /root/.secrets/dsh-login.txt
JWT=$(openssl rand -hex 32)
SESSION=$(openssl rand -hex 32)
cat > /root/authelia/config/users.yml <<USERS
users:
  leonardo@upexflow.com:
    displayname: Leonardo
    password: $HASH
    email: leonardo@upexflow.com
USERS
cat > /root/authelia/config/configuration.yml <<CFG
theme: dark
jwt_secret: $JWT
default_redirection_url: https://deepseek.upexflow.com/
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
      authelia_url: https://deepseek.upexflow.com
      default_redirection_url: https://deepseek.upexflow.com
storage:
  local:
    path: /config/db.sqlite3
notifier:
  filesystem:
    filename: /config/notifications.txt
CFG
echo "OK - authelia configurado"
