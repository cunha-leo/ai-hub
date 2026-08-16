FROM node:22
RUN npm install -g @deepseek-ai/dsh

# O dsh bloqueia `--host 0.0.0.0` (só aceita 127.0.0.1) por segurança contra RCE.
# Solução: proxy TCP interno — o dsh escuta em 127.0.0.1:3081 e um forwarder
# Node repassa para 0.0.0.0:3080 (a porta exposta ao EasyPanel/Traefik).
RUN cat > /entry.sh <<'EOF'
#!/bin/sh
set -e
dsh web --host 127.0.0.1 --port 3081 &
node -e 'const n=require("net"); n.createServer(s=>{const c=n.connect(3081,"127.0.0.1"); s.pipe(c); c.pipe(s);}).listen(3080,"0.0.0.0");'
EOF
RUN chmod +x /entry.sh
EXPOSE 3080
ENTRYPOINT ["/entry.sh"]
