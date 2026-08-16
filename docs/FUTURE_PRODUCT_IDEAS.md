# ai-hub — Pensamentos futuros

> Possibilidades ainda não aprovadas. Nada aqui é compromisso — é registro de direção para futuras decisões.

---

## 1. Multi-provedor no Harness (uma sessão, vários modelos)

- Adicionar **OpenAI (GPT)** como provedor direto (é OpenAI-compatible).
- Adicionar **Claude (Anthropic)** — **não** dá direto (protocolo diferente); precisa de ponte (LiteLLM/OpenRouter).
- Trocar de modelo no meio do chat mantendo **sessão e contexto** (o modelo é só o "cérebro" do turno).
- **Visão:** usar modelo com visão (GPT-5.x, Claude, Qwen-VL) para a ferramenta `read_image` funcionar — o `deepseek-v4-pro` é text-only.

## 2. LiteLLM self-hosted na VPS

- Roteador de API que expõe vários provedores por **um endpoint OpenAI-compatível** (`http://ai-hub-litellm:4000/v1`).
- Chaves centralizadas, retry/fallback, limites/orçamento, logs/telemetria por projeto.
- **Privado:** dados não passam por terceiro (diferente do OpenRouter).
- Candidato a virar o "gateway de modelos" da plataforma (usado por Harness, upexnote web e novos projetos).

## 3. Authelia como SSO único do ecossistema

- Proteger novos apps (upexnote web, LiteLLM UI, outras ferramentas) com a **mesma tela de login + 2FA**: adicionar rota no Traefik com o middleware `authelia-forward` + DNS + rede.
- Um login para tudo; usuários gerenciados num lugar só (`users.yml`).
- **Tema custom:** logo + CSS da UpexFlow na tela de login (Authelia suporta `logo.svg` + `styles.css` via `resources/themes/<nome>` + `theme:`).

## 4. Telemetria e metrificação contínua

- Alimentar semanalmente via **Export** do DeepSeek Platform (separa por chave).
- Comparar custo por token vs assinaturas (GPT Plus/Claude Pro) — primeiros dados já indicam que **agente/automação = API é mais econômico**; assinatura = chat interativo humano.

## 5. Harness agindo nos repos (GitHub)

- Com a credencial do GitHub na VPS, o Harness vira a "pessoa 2" da equipe: clona, edita, testa, commita e faz pull/push — trabalhando 24/7 sem o PC ligado.

## 6. Direção estratégica

- **Local (upexnote):** aplicação local-first desktop (mídia fica na máquina).
- **VPS (ai-hub + web):** execução, agentes, serviços e futuros projetos web — 100% na VPS.
- **GitHub:** ponte central de sincronização entre os dois mundos.
