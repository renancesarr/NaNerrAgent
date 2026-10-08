---
id: 002
status: backlog
tipo: implementacao-futura
unidades-alvo: [hooks/pre-commit, .context/, BACKLOGS/001-estrutura-goal.md, skills/agents-skills/verificar-objetivo, skills/agents-skills/decompor]
criado: 2026-10-08
fonte: pedido do usuário (LOG 006)
---
# Fluxo multiagente — 3 agentes, branch própria, verificação cruzada

## Objetivo
O projeto evolui com 3 agentes de código (Codex, ZCode, OpenCode) em
paralelo, sem sobrescrever trabalho alheio, com regra inegociável:
**agente nenhum valida o próprio trabalho — quem verificou é sempre outro**.

## Proposta original (do usuário)
- `dev-ai` — branch de integração principal
- `dev-ai-codex`, `dev-ai-zcode`, `dev-ai-opencode` — branch por agente
- `feature/nome-da-feature` nasce da branch do agente, retorna para ela,
  depois merge da branch do agente na `dev-ai`
- cuidados para não sobrepor trabalhos; tarefas estruturadas
- agente nunca cria teste para si mesmo

## Topologia proposta (v2)
```
main      (estável — promoção decidida pelo HUMANO)
└─ dev-ai (integração — SÓ recebe merge verificado por OUTRO agente)
   ├─ dev-ai-codex     ── feature/<slug>
   ├─ dev-ai-zcode     ── feature/<slug>
   └─ dev-ai-opencode  ── feature/<slug>
```

## Fluxo de uma feature (v2)
1. Agente pega micro SEM dono no goal/ (BACKLOGS/001) e grava `dono:` no
   frontmatter — commit do claim na dev-ai-<agente> ANTES de codar.
2. `feature/<slug>` nasce da dev-ai-<agente>.
3. Implementa; unitários (TDD, higiene interna) são do implementador.
4. Feature retorna à dev-ai-<agente> (merge do próprio autor).
5. dev-ai-<agente> → dev-ai SÓ após OUTRO agente executar o teste do
   objetivo da spec e revisar o diff. Conflito: resolve o autor do incoming.
6. dev-ai → main: decisão do humano (o humano é o gate de release).

## Melhorias sobre a proposta original
| # | Mudança | Por quê |
|---|---|---|
| 1 | claim de micro antes de codar (`dono:` no goal/) | branch isola, não coordena; o claim é o que impede sobreposição |
| 2 | verificador ≠ implementador no gate de entrada da dev-ai | "nunca testa a si mesmo" com um único ponto de checagem |
| 3 | unitários do implementador; o que cruza agente é o teste do objetivo | hierarquia QA-first (AGENTS.md §5) preservada |
| 4 | gate de branch no pre-commit (extensão da ADR-0007) | commit direto de agente em dev-ai/main = bloqueio determinístico |
| 5 | .context por branch; dev-ai carrega o estado integrado | NOW/LOG da feature viajam na feature; o merge reconcilia |
| 6 | main = estável, promovido pelo humano | fecha o arco: gate humano no commit, gate humano no release |

## Anti-sobreposição (o que de fato protege o trabalho)
- Dois agentes podem codar a MESMA task em branches diferentes — quem
  coordena isso é o claim (`dono:` no micro do goal/), não o branch.
- Nunca `--force`/overwrite; conflito de merge resolvido pelo autor do
  incoming, com o verificador conferindo o resultado do outro lado.
- Micro com dono só muda de dono se o dono liberar (`status: abandonado`).

## Aberturas (decidir na implementação)
1. "Nunca testa a si mesmo": só o teste do objetivo, ou também unitários?
   (proposta: só o gate — unitário é higiene interna do autor)
2. Fallback com um único agente ativo: humano verifica, ou espera 2º agente?
3. Janela de corrida no claim (2 agentes pegam o mesmo micro quase juntos):
   resolve por ordem de commit no goal/, ou lock?
4. Gate de branch: bloquear dev-ai E main no pre-commit, ou só main?
5. Merge `--no-ff` na dev-ai para a história de integração ficar visível?
6. Remote: todos pusham origin, ou só dev-ai e main (evita branch-zumbi)?
7. ADRs a criar: "verificador ≠ implementador", "topologia dev-ai"

## Critérios de aceite (QA da implementação)
- [ ] 3 agentes em paralelo sem trabalho sobreposto sem revisão: todo
      caminho até dev-ai passa por verificador ≠ autor, com evidência no LOG
- [ ] commit direto de agente em dev-ai/main bloqueado pelo hook
- [ ] micro tem UM dono ativo; claim visível no goal/ antes do código
- [ ] teste do objetivo executado por outro agente (comando+saída no LOG)
- [ ] .context da dev-ai reflete o estado integrado pós-merge
- [ ] AGENTS.md e skills tocadas (decompor, verificar-objetivo) emendadas
