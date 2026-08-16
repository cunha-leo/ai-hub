FROM node:22
RUN npm install -g @deepseek-ai/dsh http-proxy

# ripgrep: o agente dsh usa `rg` para busca de arquivos. Sem ele, a execução
# de código falha (o agente sugere "npm rebuild" por engano, mas é o rg).
RUN apt-get update && apt-get install -y --no-install-recommends ripgrep && rm -rf /var/lib/apt/lists/*

# O dsh bloqueia `--host 0.0.0.0` e protege `/api` com um "Host fence" que só
# aceita loopback. Como o app é exposto via reverse proxy com Host público
# (deepseek.upexflow.com), usamos um proxy HTTP+WebSocket interno que reescreve
# Host -> localhost e remove Origin. O WebSocket é obrigatório: sem ele o
# /api/events.mux falha e as sessões não sincronizam no workspace (aparecem
# como "Ungrouped").
RUN cat > /entry.sh <<'EOF'
#!/bin/sh
set -e
dsh web --host 127.0.0.1 --port 3081 &
NODE_PATH=/usr/local/lib/node_modules node -e '
const http = require("http");
const httpProxy = require("http-proxy");
const proxy = httpProxy.createProxyServer({ target: "http://127.0.0.1:3081" });
proxy.on("proxyReq", (pr) => { pr.setHeader("host", "localhost"); pr.removeHeader("origin"); });
proxy.on("proxyReqWs", (pr) => { pr.setHeader("host", "localhost"); pr.removeHeader("origin"); });
const srv = http.createServer((req, res) => proxy.web(req, res));
srv.on("upgrade", (req, socket, head) => proxy.ws(req, socket, head));
srv.listen(3080, "0.0.0.0");
'
EOF
RUN chmod +x /entry.sh
EXPOSE 3080
ENTRYPOINT ["/entry.sh"]
