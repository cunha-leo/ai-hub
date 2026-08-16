#!/bin/bash
# Define a senha SMTP no configuration.yml do Authelia de forma segura
# (sem aparecer na tela e sem shell escaping). Rode na VPS:
#   bash /root/set_smtp.sh
F=/root/authelia/config/configuration.yml

if ! grep -q "SMTP_PASSWORD_AQUI" "$F"; then
  echo "A senha ja foi substituida antes. Apenas reiniciando o Authelia..."
  docker service update --force ai-hub_authelia > /dev/null 2>&1
  sleep 8
  docker ps --filter name=ai-hub_authelia
  exit 0
fi

echo -n "Cole a senha SMTP do contact@upexflow.com e pressione Enter: "
read -s PASS
echo ""
if [ -z "$PASS" ]; then
  echo "Senha vazia. Nada foi alterado."
  exit 1
fi

printf '%s' "$PASS" | node -e '
const fs = require("fs");
const chunks = [];
process.stdin.on("data", d => chunks.push(d));
process.stdin.on("end", () => {
  const p = Buffer.concat(chunks).toString("utf8");
  const f = "/root/authelia/config/configuration.yml";
  let c = fs.readFileSync(f, "utf8");
  c = c.replace("SMTP_PASSWORD_AQUI", p);
  fs.writeFileSync(f, c);
  console.log(c.includes("SMTP_PASSWORD_AQUI") ? "ERRO: placeholder ainda presente" : "OK: senha substituida");
});
'

echo "Reiniciando Authelia..."
docker service update --force ai-hub_authelia > /dev/null 2>&1
sleep 8
docker ps --filter name=ai-hub_authelia
echo "Pronto."
