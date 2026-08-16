# Deploy — ai-hub (DeepSeek Harness + Authelia)

Guia de referência da montagem feita na VPS Hostinger (EasyPanel + Docker Swarm + Traefik + Authelia).

## 0. Pré-requisitos

- VPS com EasyPanel instalado (licença free = limite de 3 projetos).
- DNS: `authai.upexflow.com` e `deepseek.upexflow.com` → IP da VPS (`72.61.2.64`).
- SMTP Hostinger para recuperação de senha (usuário `contact@upexflow.com`).

## 1. Serviço `dsh` (DeepSeek Harness)

No EasyPanel, criar serviço com **source "Dockerfile"** (o EasyPanel não puxa imagem local).
Colar o conteúdo de [`../dsh/Dockerfile`](../dsh/Dockerfile).

- O dsh **bloqueia `--host 0.0.0.0`** (segurança) e protege `/api` com um **Host fence** que só aceita loopback.
- Solução: **proxy HTTP interno** — dsh em `127.0.0.1:3081` + proxy Node em `0.0.0.0:3080` que
  reescreve `Host -> localhost` e remove `Origin`, fazendo o dsh enxergar loopback.
- Porta exposta: `3080`.
- A chave de API do modelo vai por **env var `DEEPSEEK_API_KEY`** (o erro `MISSING_CREDENTIAL`
  indica que a página Models não gravou a credencial; a env var resolve sem depender da UI).

## 2. Serviço `authelia`

Imagem `authelia/authelia:latest`, porta interna `9091`.

Volumes/bind mounts:
- `/root/authelia/config` → `/config`

Configs (geradas a partir dos `.example`):
- `configuration.yml` — gerar segredos: `openssl rand -hex 32` (jwt_secret, session.secret, encryption_key).
- `users.yml` — hash de senha: `docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --random`.

### Requisitos da v4.39 (senão o container cai)

- `identity_validation.reset_password.jwt_secret`
- `storage.encryption_key`
- `session.cookies` com `authelia_url` **diferente** de `default_redirection_url`
  (por isso existem 2 domínios: `authai` e `deepseek`).

## 3. Traefik (`dsh.yaml`)

Colocar [`../traefik/dsh.yaml`](../traefik/dsh.yaml) em `/etc/easypanel/traefik/config/`.

- O Traefik assiste a pasta inteira; o EasyPanel **não sobrescreve** o arquivo custom.
- Os aliases do swarm usam **hífen**: `http://ai-hub-authelia:9091` e `http://ai-hub-dsh:3080`
  (nomes de serviço têm underscore, aliases de rede têm hífen).

## 4. 2FA + SMTP (segurança)

- `access_control` com `policy: two_factor` no domínio do app.
- `totp` com `skew: 2` (±60s) para tolerar deriva de relógio.
- SMTP: porta 465 usa esquema **`submissions://`** (TLS implícito), não `smtp://`.
- `notifier.disable_startup_check: true` evita crash fatal se o SMTP falhar no startup.
- Recuperação de senha: `users.yml` → `email: contact@upexflow.com`.
- Forward (fallback Gmail): no hPanel, `contact@upexflow.com` → `cunhaleonardo.pt@gmail.com`.

## 5. Operação (swarm — CRÍTICO)

- **NUNCA usar `docker restart`** em tasks do swarm (cria tasks duplicadas que quebram DNS/VIP).
- Reiniciar um serviço: `docker service update --force <servico>`.
- Ver status: `docker ps --filter name=ai-hub`.
- Logs: `docker service logs ai-hub_authelia` / `docker service logs ai-hub_dsh`.

## 6. Validação

```bash
curl -sk -o /dev/null -w "%{http_code}\n" https://authai.upexflow.com/   # 200
curl -sk -o /dev/null -w "%{http_code}\n" https://deepseek.upexflow.com/ # 302 (redirect login)
```

Fluxo esperado: login → 2FA (TOTP/passkey) → app carrega.
