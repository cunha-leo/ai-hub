# ai-hub — Contexto Vivo do Projeto

> **Objetivo:** manter uma fonte de verdade legível por pessoas e IAs. Atualizar a cada decisão, validação, teste relevante ou mudança estrutural. **Não contém segredos** (chaves, tokens, senhas).

**Última atualização:** 16 de agosto de 2026
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
- **Chaves por canal** (telemetria): `deepseek-harness` · `vscode-extension` · `copilot` · `upexnote` — a `deepseek-agent` foi **revogada** (terminal usa sessão do navegador, não API).
- **Telemetria registrada** (doc MD, seção 12): 30 dias ≈ **US$ 4,82 · 944 requisições · 229,4M tokens** (~US$ 0,02/M efetivo).
- **Dossiê DOCX v1.1** + **doc MD v1.2** no Drive (pasta `DeepSeekHarness`).
- **Validação end-to-end do dsh OK** (16/08): mensagem respondida, sessão vinculada ao workspace, sem "Ungrouped".

---

## 2. Decisões de arquitetura vigentes

- **VPS = execução/casa** (100% para ai-hub e futuros projetos web: código, deps, agentes). **Local = cofre de mídia** (vídeo/transcript do upexnote).
- **upexnote permanece local-first (desktop)**; versão web **adiada** (não compensa agora).
- **GitHub = ponte** entre local e VPS (push/pull); sempre `pull` antes de editar, `push` ao terminar.
- **Chaves de API por canal** para telemetria consistente.
- **Código no disco local + GitHub**; **documentação no Google Drive** (evita arquivos ocultos da nuvem no repositório).
- **Reuso de plataforma:** Authelia vira SSO único do ecossistema; LiteLLM (futuro) vira gateway único de modelos.
- **VPS atual:** 96 GB disco (80 GB livres) · 7,8 GB RAM · 2 núcleos · load ~0 — suporta vários projetos de código.

---

## 3. Pendências imediatas

1. **Credencial do GitHub na VPS** (fine-grained token) para o Harness fazer `clone/pull/push` nos repos privados.
2. **(Opcional)** `LiteLLM` na VPS como gateway multi-provedor (OpenAI/Claude/Gemini) — 1 endpoint, chaves centralizadas.
3. **(Opcional)** Tema customizado do Authelia (logo UpexFlow + CSS).
4. **Metrificação semanal** de telemetria (via Export do DeepSeek Platform + planilha sugerida na seção 12 do doc MD).

---

## 4. Registro de atualizações

- **16/08/2026 — Montagem completa do ai-hub:**
  - Deploy do `dsh` na VPS (EasyPanel, source Dockerfile) com proxy HTTP+WebSocket (fix do 403/Host fence e do "Ungrouped"), volume persistente e `ripgrep`.
  - Authelia com 2FA (TOTP + passkey) e reset por e-mail (SMTP Hostinger), forward Gmail.
  - Traefik `dsh.yaml` com forward-auth nos domínios `deepseek` e `authai`.
  - Chaves por canal criadas/rotacionadas; `deepseek-agent` revogada.
  - Telemetria e comparação de custo vs assinaturas registradas.
  - Dossiê DOCX v1.1 (com imagens) e doc MD v1.2 (seção 12 de telemetria) no Drive.
  - Decisões de arquitetura: VPS=execução, upexnote local-first, ai-hub 100% VPS, GitHub=ponte.
  - Estrutura de orquestração documental criada (este `docs/`).
