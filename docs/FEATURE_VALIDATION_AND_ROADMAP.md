# ai-hub — Validação de frentes e roadmap

> Atualizar sempre que uma frente mudar de estado ou o roadmap evoluir.

---

## 1. Estado por frente

| Frente | Estado | Observação |
|---|---|---|
| Deploy do dsh (VPS) | ✅ **feito/validado** | proxy HTTP+WebSocket, volume persistente, ripgrep, env key |
| Authelia + 2FA + SMTP | ✅ **feito/validado** | TOTP + passkey, reset por e-mail, forward Gmail |
| Traefik / rotas | ✅ **feito/validado** | `dsh.yaml`, forward-auth, `authai` + `deepseek` |
| Chaves por canal | ✅ **feito** | 4 ativas; `deepseek-agent` revogada |
| Telemetria / custo | ✅ **feito** | registrada no doc MD (seção 12) |
| Dossiê DOCX + doc MD | ✅ **feito** | v1.1 / v1.2 no Google Drive |
| Orquestração documental (`docs/`) | ✅ **feito** | este `CONTEXT_ORCHESTRATION.md` + `PROJECT_CONTEXT.md` |
| Credencial do GitHub na VPS | ⏳ **pendente** | Harness poder clonar/pull/push nos repos |
| LiteLLM (gateway multi-provedor) | ⬜ **futuro** | OpenAI/Claude/Gemini por 1 endpoint |
| Tema customizado do Authelia | ⬜ **futuro** | logo UpexFlow + CSS |
| Multi-provedor no Harness | ⬜ **futuro** | visão via modelo com visão |

---

## 2. Roadmap

### Próximo (curto prazo)
1. [ ] **Credencial do GitHub na VPS** — gerar *fine-grained token* (escopo mínimo) para o Harness agir nos repos privados.
2. [ ] **Clone do repo no workspace do Harness** — para o agente trabalhar sobre código real (editar, testar, commit).

### Médio prazo (opcional)
3. [ ] **LiteLLM na VPS** — gateway self-hosted: 1 endpoint OpenAI-compatível, chaves dos provedores centralizadas, telemetria/custo por projeto.
4. [ ] **Tema do Authelia** — logo e CSS da UpexFlow na tela de login (reversível, baixo risco).

### Visão
5. [ ] **Multi-provedor no Harness** — DeepSeek (texto) + OpenAI/Claude via LiteLLM/OpenRouter (visão/imagem) na mesma sessão/contexto.
6. [ ] **Plataforma reutilizável** — Authelia como SSO e LiteLLM como gateway para upexnote (web, futuro) e novos projetos.

---

## 3. Como validar uma frente concluída

- **UI/UX é requisito arquitetural:** a funcionalidade deve operar de ponta a ponta (não basta protótipo visual).
- Para o Harness: teste real no navegador (enviar mensagem, sessão no workspace, sem "Ungrouped").
- Para segurança: verificar `curl` de `authai` (200) e `deepseek` (302 → login), fluxo 2FA, reset por e-mail.
- Atualizar `PROJECT_CONTEXT.md` (Registro + Estado atual) e este documento ao concluir.
