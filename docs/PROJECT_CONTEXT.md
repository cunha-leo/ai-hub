# ai-hub — Contexto Vivo do Projeto

> **Objetivo:** manter uma fonte de verdade legível por pessoas e IAs. Atualizar a cada decisão, validação, teste relevante ou mudança estrutural. **Não contém segredos** (chaves, tokens, senhas).

**Última atualização:** 17 de agosto de 2026
**Repositório:** `https://github.com/cunha-leo/upexflow-ai-hub` (privado) — **fonte de verdade e sincronização**
**Raiz local:** `C:\Users\cunha\Projects\upexflow\ai-hub`
**Documentação de referência:** Google Drive `...\UpexFlow\ai-hub\DeepSeekHarness` (dossiê DOCX + doc MD)

---

## 1. Resumo executivo

`ai-hub` é a infraestrutura de IA da UpexFlow rodando na VPS Hostinger: o agente **DeepSeek Harness (dsh)** atrás de um portão de login **Authelia** com autenticação de dois fatores (2FA). Além de servir o Harness, é a fundação de uma **plataforma reutilizável**: login SSO (Authelia) para o ecossistema + futuro gateway de modelos (LiteLLM).

**Fluxo:** `Você → Traefik → Authelia (forward-auth) → dsh → API DeepSeek`. A VPS orquestra; a inferência é remota (API).

---

## 1.1 Estado atual — 16 de agosto de 2026

- **dsh** rodando 24/7 na VPS: proxy HTTP+WebSocket interno, volume persistente (`/root/dsh-data` → `/root/.dsh`), `ripgrep` instalado, env `DEEPSEEK_API_KEY` definida.
- **Authelia** com 2FA (TOTP + passkey/WebAuthn) e **recuperação de senha por e-mail** (SMTP Hostinger `submissions://…:465`), com forward Gmail de fallback.
- **Frentes de acesso DeepSeek** (cada uma é uma frente, mesmo sem chave): chat oficial (free) · `deepseek-agent` (executor interativo no terminal local) · DeepSeek Harness/dsh (VPS) · Deep Copilot · chat do editor VS Code · upexnote.
- **Chaves de API por canal** (telemetria): `deepseek-harness` → dsh · `copilot` → Deep Copilot · `vscode-extension` → chat do editor VS Code · `upexnote` → desktop local. A `deepseek-agent` **não tem chave** (não consome API — executor no nível do chat free oficial); a revogação foi da chave, não da frente.
- **Telemetria registrada** (doc MD, seção 12): 30 dias ≈ **US$ 4,82 · 944 requisições · 229,4M tokens** (~US$ 0,02/M efetivo).
- **Dossiê DOCX v1.1** + **doc MD v1.2** no Drive (pasta `DeepSeekHarness`).
- **Validação end-to-end do dsh OK** (16/08): mensagem respondida, sessão vinculada ao workspace, sem "Ungrouped".
- **Ambiente remoto (Remote-SSH) montado** (16/08): host `upexflow-vps` no `~/.ssh/config`, extensões instaladas na VPS (Python/Pylance/YAML/Prettier/Copilot/DeepSeek), chaves DeepSeek das extensões configuradas e testadas, `upexflow-ai-hub` clonado em `/root/ai-hub`.
- **Credencial GitHub na VPS** ✅ (chave `id_ed25519` já existia e autentica como `cunha-leo`); identidade git configurada (`Leonardo Cunha <contact@upexflow.com>`).
- **Multi-provedor no dsh (17/08):** análise concluída — o dsh **já suporta outros motores nativamente** (`dsh-llm-pi-ai`, catálogo pi-ai + seleção de modelo na mesma sessão); sem ajuste de código, basta configurar perfis `llm-pi-ai:` e chaves. **LiteLLM fica opcional** (lugar único p/ telemetria e controle de APIs no ecossistema).

---

## 2. Decisões de arquitetura vigentes

- **VPS = execução/casa** (100% para ai-hub e futuros projetos web: código, deps, agentes). **Local = cofre de mídia** (vídeo/transcript do upexnote).
- **upexnote permanece local-first (desktop)**; versão web **adiada** (não compensa agora).
- **GitHub = ponte** entre local e VPS (push/pull); sempre `pull` antes de editar, `push` ao terminar.
- **Ambiente de trabalho:** o código do ai-hub é trabalhado **via SSH/Remote-SSH na VPS** (`upexflow-vps` → `/root/ai-hub`) — o editor local vira janela de orquestração/gestão; o upexnote continua 100% local.
- **Chaves de API por canal** para telemetria consistente.
- **Código no disco local + GitHub**; **documentação no Google Drive** (evita arquivos ocultos da nuvem no repositório).
- **Reuso de plataforma:** Authelia vira SSO único do ecossistema; LiteLLM (futuro) vira gateway único de modelos.
- **VPS atual:** 96 GB disco (80 GB livres) · 7,8 GB RAM · 2 núcleos · load ~0 — suporta vários projetos de código.

---

## 3. Pendências imediatas
~~**Credencial do GitHub na VPS**~~ → ✅ **feita** (chave SSH `id_ed25519` já existia; repo clonado em `/root/ai-hub`)
1. **Credencial do GitHub na VPS** (fine-grained token) para o Harness fazer `clone/pull/push` nos repos privados.
2. **(Opcional)** `LiteLLM` na VPS como gateway multi-provedor (OpenAI/Claude/Gemini) — 1 endpoint, chaves centralizadas.
3. **(Opcional)** Tema customizado do Authelia (logo UpexFlow + CSS).
4. **Metrificação semanal** de telemetria (via Export do DeepSeek Platform + planilha sugerida na seção 12 do doc MD).

---

## 4. Registro de atualizações

- **17/08/2026 — Frentes de acesso × chaves de API (clarificação):**
  - `deepseek-agent` é uma **frente** (executor interativo no terminal via chat free oficial) **sem chave de API** — a revogação foi da chave, não da frente.
  - Mapeamento confirmado das chaves por canal: `deepseek-harness` → dsh (VPS); `copilot` → Deep Copilot; `vscode-extension` → chat do editor VS Code; `upexnote` → desktop local.
- **17/08/2026 — Análise multi-provedor no dsh (conclusão):**
  - O dsh **já tem multi-provedor nativo** via adapter `dsh-llm-pi-ai` (catálogo pi-ai): anthropic, openai, google, deepseek, groq, mistral, xai, zai, openrouter etc. + gateways custom via `baseURL`.
  - **Seleção de modelo na mesma sessão é feature existente** (UI de seleção + página Models; hot-reload via `$DSH_HOME/settings.yaml`).
  - **Sem ajuste de código** — basta configurar perfis `llm-pi-ai:` + chaves (`apiKeyEnv`/credentials) e selecionar o modelo na UI.
  - **LiteLLM vira opcional**: só vale como lugar único para telemetria e controle de APIs no ecossistema (não é requisito do Harness).
- **16/08/2026 — Montagem completa do ai-hub:**
  - Deploy do `dsh` na VPS (EasyPanel, source Dockerfile) com proxy HTTP+WebSocket (fix do 403/Host fence e do "Ungrouped"), volume persistente e `ripgrep`.
  - Authelia com 2FA (TOTP + passkey) e reset por e-mail (SMTP Hostinger), forward Gmail.
  - Traefik `dsh.yaml` com forward-auth nos domínios `deepseek` e `authai`.
  - Chaves por canal criadas/rotacionadas; `deepseek-agent` revogada.
  - Telemetria e comparação de custo vs assinaturas registradas.
  - Dossiê DOCX v1.1 (com imagens) e doc MD v1.2 (seção 12 de telemetria) no Drive.
  - Decisões de arquitetura: VPS=execução, upexnote local-first, ai-hub 100% VPS, GitHub=ponte.
  - Estrutura de orquestração documental criada (este `docs/`).
  - **Ambiente remoto montado:** `~/.ssh/config` com host `upexflow-vps`; Remote-SSH instalado no VS Code; extensões + chaves DeepSeek configuradas no servidor da VPS; repo `ai-hub` clonado em `/root/ai-hub` (git conectado e identidade configurada); handoff da sessão em `docs/handoff/HANDOFF_2026-08-16.md`.
