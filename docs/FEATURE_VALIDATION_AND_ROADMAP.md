# ai-hub — Validação de frentes e roadmap

> Atualizar sempre que uma frente mudar de estado ou o roadmap evoluir.

---

## 1. Estado por frente

| Frente | Estado | Observação |
|---|---|---|
| Deploy do dsh (VPS) | ✅ **feito/validado** | proxy HTTP+WebSocket, volume persistente, ripgrep, env key |
| Authelia + 2FA + SMTP | ✅ **feito/validado** | TOTP + passkey, reset por e-mail, forward Gmail |
| Traefik / rotas | ✅ **feito/validado** | `dsh.yaml`, forward-auth, `authai` + `deepseek` |
| Chaves por canal | ✅ **feito** | 4 ativas: `deepseek-harness` (dsh) · `copilot` (Deep Copilot) · `vscode-extension` (editor) · `upexnote`; `deepseek-agent` é frente sem chave (chat free) |
| Telemetria / custo | ✅ **feito** | registrada no doc MD (seção 12) |
| Dossiê DOCX + doc MD | ✅ **feito** | v1.1 / v1.2 no Google Drive |
| Orquestração documental (`docs/`) | ✅ **feito** | este `CONTEXT_ORCHESTRATION.md` + `PROJECT_CONTEXT.md` |
| Credencial do GitHub na VPS | ✅ **feito** | chave SSH `id_ed25519` já existia (autentica como `cunha-leo`) |
| Clone do repo na VPS | ✅ **feito** | `/root/ai-hub`, identidade git configurada, pull/push OK |
| Ambiente remoto (Remote-SSH) | ✅ **feito** | host `upexflow-vps`; extensões + chaves DeepSeek ativas na VPS |
| LiteLLM (telemetria/controle central de APIs) | 🔍 **analisado / opcional** | lugar único p/ telemetria e gestão de chaves no ecossistema; **não é requisito** do Harness |
| Tema customizado do Authelia | ⬜ **futuro** | logo UpexFlow + CSS |
| Multi-provedor no Harness | 🔍 **possível nativo** | dsh-llm-pi-ai (catálogo pi-ai): anthropic/openai/google/…; basta perfis `llm-pi-ai:` + chaves + seleção de modelo na mesma sessão |

---

## 2. Roadmap

### Próximo (curto prazo)
1. [x] ~~**Credencial do GitHub na VPS**~~ — ✅ feita (chave SSH já existia; repo clonado).
2. [x] ~~**Clone do repo no workspace do Harness**~~ — ✅ `/root/ai-hub` clonado e conectado.
3. [ ] **Handoff/continuidade** — ler `docs/handoff/HANDOFF_2026-08-16.md` na janela remota para retomar o contexto.

### Próximo (a definir)
4. [ ] **Multi-provedor no Harness (configuração)** — o dsh **já suporta nativamente** (`dsh-llm-pi-ai`): criar perfis `llm-pi-ai:` no `settings.yaml` (anthropic/openai/google), adicionar chaves (`apiKeyEnv`/credentials) e validar a seleção de modelo na mesma sessão. Sem ajuste de código.

### Médio prazo (opcional)
5. [ ] **LiteLLM na VPS (telemetria/controle central)** — lugar único para ver telemetria e controlar APIs no ecossistema; **opcional**, pois o Harness já roteia multi-provedor nativamente.
6. [ ] **Tema do Authelia** — logo e CSS da UpexFlow na tela de login (reversível, baixo risco).

### Visão
7. [ ] **Multi-provedor com visão** — aproveitar modelos com visão (Claude/OpenAI/Gemini) na mesma sessão, via perfis pi-ai (sem depender de LiteLLM/OpenRouter).
8. [ ] **Plataforma reutilizável** — Authelia como SSO e (opcional) LiteLLM como gateway para upexnote (web, futuro) e novos projetos.

---

## 3. Como validar uma frente concluída

- **UI/UX é requisito arquitetural:** a funcionalidade deve operar de ponta a ponta (não basta protótipo visual).
- Para o Harness: teste real no navegador (enviar mensagem, sessão no workspace, sem "Ungrouped").
- Para segurança: verificar `curl` de `authai` (200) e `deepseek` (302 → login), fluxo 2FA, reset por e-mail.
- Atualizar `PROJECT_CONTEXT.md` (Registro + Estado atual) e este documento ao concluir.
