# ai-hub — Context Orchestration

> **Papel:** porta única e obrigatória de entrada para qualquer IA, agente, conta, ambiente ou sessão que precise compreender o projeto **ai-hub** (infraestrutura de IA da UpexFlow) antes de propor ou executar trabalho.
>
> **Uso esperado:** basta instruir: **"Leia `docs/CONTEXT_ORCHESTRATION.md` e siga integralmente suas coordenadas antes de agir."**
>
> **Regra principal:** este documento coordena a ordem, a necessidade e a profundidade da leitura. Ele não substitui as fontes referenciadas e não autoriza implementação por si só.
>
> **Regra de eficiência:** documentos extensos já disponíveis na sessão na mesma versão não devem ser relidos integralmente. Verificar presença e versão, reler apenas quando necessário e registrar o que foi reutilizado.

---

## 1. Objetivo

Elimina a necessidade de reconstruir manualmente, em cada sessão, quais fontes ler, em que ordem, com qual autoridade e quando reutilizar.

A contextualização reconstroi quatro camadas:

1. **Leonardo** (quando relevante): identidade operacional, método e decisões vivas — vive no repositório `upexnote` (`AGENTS.md` → pasta `00- Manifesto&Decisions` no Google Drive). Não é obrigatório para tarefas puramente técnicas do ai-hub.
2. **Estado do projeto ai-hub:** `docs/PROJECT_CONTEXT.md`.
3. **Validação e roadmap:** `docs/FEATURE_VALIDATION_AND_ROADMAP.md`.
4. **Execução atual:** pendências, documentos especializados (`docs/DEPLOY.md`, Dockerfile, configs), código e estado real na VPS.

---

## 2. Ponto único de entrada

Toda sessão relevante deve começar por este arquivo; a leitura das fontes seguintes é **condicional à presença, versão e atualidade**.

```text
CONTEXT_ORCHESTRATION.md
  → AGENTS.md da raiz (regras do repositório)
  → PROJECT_CONTEXT.md (estado vivo do projeto)
  → FEATURE_VALIDATION_AND_ROADMAP.md (frentes + roadmap)
  → documentos especializados exigidos pela tarefa (DEPLOY.md, Dockerfile, configs)
  → código, Git e estado executável (VPS/EasyPanel quando aplicável)
  → proposta ou implementação autorizada
  → retroalimentação dos documentos de domínio
  → retorno ao roadmap / PROJECT_CONTEXT.md
```

Não iniciar pelo código isoladamente, por conversa antiga ou por um único documento técnico quando esta porta estiver disponível.

**Regra de confronto obrigatória (espelhada do upexnote):** antes de declarar leitura integral de qualquer documento deste repositório, rodar `git status --short`, `git log --oneline -20` e `git branch -vv`. Se a branch estiver `behind` de `origin/main`, ler as versões via `git show origin/main:<caminho>` e registrar a divergência, em vez de assumir o conteúdo local como canônico.

---

## 3. Camada humana e decisória

Leonardo Cunha é o arquiteto e responsável intelectual do ai-hub. O contexto pessoal (método de trabalho, decisões vivas, prioridades) está documentado no repositório `upexnote` (AGENTS.md → pasta canônica `00- Manifesto&Decisions` no Google Drive).

Aplicar essa camada quando a tarefa envolver priorização, direção, custo, segurança ou critérios de Leonardo. Não forçar contexto pessoal em tarefas técnicas puras sem relação.

---

## 4. Protocolo de presença, versão e releitura

Avaliar **cada documento separadamente**.

### 4.1. Pode reutilizar sem releitura integral quando
Todos os pontos forem verdadeiros:
- a sessão já leu integralmente o documento na versão corrente;
- a versão da sessão é idêntica à mais recente (local + `origin/main`);
- a data de modificação é a mesma;
- não há dúvida sobre cortes, lacunas ou leitura incompleta.

### 4.2. Deve reler integralmente quando
Qualquer um destes ocorrer:
- não há prova de leitura integral na sessão;
- a versão local é maior que a carregada;
- o worktree está `behind` de `origin/main`;
- há dúvida sobre trechos omitidos.

Não fazer downgrade silencioso: se a sessão indicar versão maior que a do repositório, informar a divergência e preservar a versão mais nova até localizar a fonte correta.

---

## 5. Camada do repositório ai-hub

| Item | Valor |
|---|---|
| Raiz local de desenvolvimento | `C:\Users\cunha\Projects\upexflow\ai-hub` (disco local, fora da nuvem) |
| **Ambiente remoto de trabalho** | `upexflow-vps` (SSH/Remote-SSH) → **`/root/ai-hub`** — o código é trabalhado aqui (janela local = orquestração) |
| GitHub | `cunha-leo/upexflow-ai-hub` (privado, branch `main`) — **fonte de verdade e sincronização** |
| Documentação de referência | Google Drive `...\UpexFlow\ai-hub\DeepSeekHarness` (dossiê DOCX + doc MD) |
| VPS | Hostinger KVM, EasyPanel, projeto `ai-hub` (serviços `dsh` e `authelia`) |
| Segredos | nunca versionar; ficam na VPS (`/root/.secrets`, `/root/authelia/config`) e em SecretStorage/cofre local |

> **Ambiente de trabalho:** o código do ai-hub vive e é editado na **VPS** (`/root/ai-hub`, via Remote-SSH `upexflow-vps`). A janela local do VS Code é usada para **orquestração/gestão** (esta documentação, VPS, GitHub). O handoff da sessão está em `docs/handoff/HANDOFF_2026-08-16.md`.
>
> **Memória persistente (dossiês):** a pasta `dossies/` (na VPS, **gitignorada** — não vai ao GitHub) guarda os dossiês DOCX/MD retroalimentados, com versão atual na raiz e antigas em `old/`. A convenção de estrutura/versão/atualização está em **`docs/DOSSIERS.md`** (versionado) e o espelho fica no Google Drive (`...\UpexFlow\ai-hub`).

---

## 6. Regras não negociáveis do ai-hub

- **Nunca expor ou registrar segredos** (tokens, senhas, chaves, OAuth) em docs, Git ou chat.
- **Código** no disco local + GitHub (privado); **documentação** no Google Drive (pasta `DeepSeekHarness`).
- **VPS = execução/casa** (agentes, serviços, código+deps); **material bruto de mídia** (vídeo/transcript) fica na máquina local (upexnote).
- **Chaves de API por canal** (telemetria) — nunca reutilizar a mesma chave para fins diferentes.
- **NUNCA `docker restart` em tasks do swarm** → usar `docker service update --force <serviço>`.
- **Deploy, push ou operações destrutivas** somente com autorização explícita de Leonardo.
