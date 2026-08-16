FROM node:22
RUN npm install -g @deepseek-ai/dsh

# ripgrep: o agente dsh usa `rg` para busca de arquivos. Sem ele, a execução
# de código falha (o agente sugere "npm rebuild" por engano, mas é o rg).
RUN apt-get update && apt-get install -y --no-install-recommends ripgrep && rm -rf /var/lib/apt/lists/*

# O dsh bloqueia `--host 0.0.0.0` e protege `/api` com um "Host fence" que só
# aceita loopback. Como o app é exposto via reverse proxy com Host público
# (deepseek.upexflow.com), usamos um proxy HTTP interno que reescreve
# Host -> localhost e remove Origin, fazendo o dsh enxergar loopback.
RUN cat > /entry.sh <<'EOF'
#!/bin/sh
set -e
dsh web --host 127.0.0.1 --port 3081 &
node -e 'const http=require("http");http.createServer((req,res)=>{const h=Object.assign({},req.headers,{host:"localhost"});delete h.origin;const p=http.request({hostname:"127.0.0.1",port:3081,path:req.url,method:req.method,headers:h},pr=>{res.writeHead(pr.statusCode,pr.headers);pr.pipe(res);});p.on("error",()=>{res.writeHead(502);res.end();});req.pipe(p);}).listen(3080,"0.0.0.0");'
EOF
RUN chmod +x /entry.sh
EXPOSE 3080
ENTRYPOINT ["/entry.sh"]
