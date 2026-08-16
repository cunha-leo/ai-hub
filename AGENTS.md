# AGENTS.md — ai-hub

Este arquivo é a porta de entrada operacional para qualquer IA, agente ou sessão que vá trabalhar no repositório `ai-hub`.

## Entrada obrigatória

1. Leia **`docs/CONTEXT_ORCHESTRATION.md`** e siga integralmente suas coordenadas **antes de agir**.
2. Leia **`docs/PROJECT_CONTEXT.md`** (estado vivo) e **`docs/FEATURE_VALIDATION_AND_ROADMAP.md`** (frentes + roadmap).
3. Leia os documentos especializados exigidos pela tarefa (`docs/DEPLOY.md`, Dockerfile, configs).
4. Confira sem modificar: `git status --short`, `git log --oneline -20`, `git branch -vv`.

## Regras não negociáveis

- **Nunca expor ou registrar segredos** (tokens, senhas, chaves, OAuth) em docs, Git ou chat.
- **Código** no disco local + GitHub (privado); **documentação** no Google Drive (pasta `DeepSeekHarness`).
- **VPS = execução/casa** (agentes, serviços); **material bruto de mídia** fica na máquina local (upexnote).
- **Chaves de API por canal** (telemetria) — nunca reutilizar a mesma chave para fins diferentes.
- **NUNCA `docker restart` em tasks do swarm** → usar `docker service update --force <serviço>`.
- **Deploy, push ou operações destrutivas** somente com autorização explícita de Leonardo.

## Fonte de verdade (prioridade)

1. Código e estado real do repositório/Git + VPS.
2. `docs/PROJECT_CONTEXT.md`.
3. `docs/FEATURE_VALIDATION_AND_ROADMAP.md`.
4. `docs/DEPLOY.md` + arquivos do repo (Dockerfile, configs).
5. Documentação de referência no Google Drive (dossiê DOCX + doc MD).
6. Conversas antigas apenas como contexto complementar.

## Vocabulário do utilizador

- "Ambiente" = o navegador interno do agente (Codex/Claude em Chrome) com os acessos de trabalho.
- **"Abra o ambiente"** (ou "ambiente 1") = abrir/reutilizar uma aba para cada destino principal:
  - EasyPanel/VPS: `https://vps.upexflow.com/`
  - DeepSeek Harness (app): `https://deepseek.upexflow.com/`
  - Hostinger e-mail (caixa `contact@upexflow.com`): `https://hpanel.hostinger.com/email/upexflow.com/`
  - DeepSeek Platform (usage/telemetria): `https://platform.deepseek.com/usage`
- "Harness" / "dsh" = o DeepSeek Harness rodando na VPS (`https://deepseek.upexflow.com`).
- "authai" = a tela de login única (`https://authai.upexflow.com`).
