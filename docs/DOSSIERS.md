# ai-hub — Dossiês de memória persistente (convenção)

> **Propósito:** os dossiês (DOCX/MD) são a **memória persistente** do ai-hub — vivos, retroalimentados e com objetivo de dar contexto contínuo às IAs. Eles **NÃO vão para o GitHub** (por segurança: nada de vazar), ficam **na VPS** e são **espelhados no Google Drive**.
>
> ⚠️ Este documento (versionado no Git) define a convenção. A pasta `dossies/` em si é **gitignorada** — a regra precisa ser conhecida pelos docs versionados.

---

## 1. Onde ficam (na VPS)

```
/root/ai-hub/dossies/
└── <dominio>/                  ← ex.: deepseek
    ├── <documento atual>.md / .docx   ← versão corrente (na raiz)
    └── old/                           ← versões superadas (nunca apagar)
```

- A pasta pai `dossies/` está no `.gitignore` — **não sobe para o GitHub** (sem risco de vazar).
- É memória persistente da VPS; o Google Drive é o **espelho/backup** (ver seção 4).

---

## 2. Regra de versão e atualização (obrigatória)

Toda vez que um dossiê for **atualizado/retroalimentado**:

1. **Renomear para a versão superior** (ex.: `..._v1.1.docx` → `..._v1.2.docx`).
2. **Mover a versão superada para `old/`** — a antiga **nunca é apagada** (preserva histórico).
3. **A versão corrente fica na raiz** da pasta do domínio.
4. Aplicar igualmente para **DOCX e MD**.
5. **Espelhar no Google Drive** com a mesma estrutura (atual na raiz, antigas em `old/`).

---

## 3. Novos documentos / novos domínios

- Novos documentos de memória podem nascer dentro de `dossies/`.
- Cada **domínio novo** = **pasta nova** (`dossies/<dominio>/`), sempre com: arquivo atual na raiz + `old/`.
- Seguir a mesma convenção de versão (renomear, mover antiga para `old/`, manter atual na raiz).

---

## 4. Espelho no Google Drive (backup)

- Caminho: `My Drive\DocumentsDesktop\03-Life\04-Active Ventures\UpexFlow\ai-hub`
- Manter a **mesma estrutura**: versão corrente na raiz do domínio; versões antigas em `old/`.
- O Drive é o backup; a VPS é o armazenamento persistente de trabalho.

---

## 5. Referência cruzada

- Este repositório (`docs/`) tem a versão **enxuta e versionável** (CONTEXT_ORCHESTRATION, PROJECT_CONTEXT, FEATURE_VALIDATION_AND_ROADMAP, handoff).
- Os dossiês em `dossies/` são a **memória completa e retroalimentada** (não versionada no Git — só VPS + Drive).
