# 008 — topologia de branches multiagente (média — BACKLOGS/002 parcial)
quando: 2026-10-08
input: pedido do usuário após o incidente de fluxo paralelo (LOG 007):
       "outro agente trabalhou no repositório" → branch por agente já
classificação (conter, ANTES): média — muda a convenção de trabalho
       futura (onde cada agente commita), diff pequeno só em .context
escopo: SÓ a topologia do BACKLOGS/002. Permanece no backlog (contenção):
       gate de branch no hook, claim de micro (dono:), emenda do AGENTS.md
output: dev-ai (de main@4a04042) + dev-ai-codex + dev-ai-opencode +
       dev-ai-zcode (de dev-ai); sessão ZCode ativa em dev-ai-zcode
regras em vigor desde agora (BACKLOGS/002):
  - agente commita SÓ na sua dev-ai-<agente> (ou feature/* dela)
  - nada de commit de agente direto em dev-ai ou main — por enquanto por
    convenção; o gate determinístico no hook é pendência do backlog
  - merge à dev-ai exige verificador ≠ implementador
  - main = estável, promovido pelo humano
observação: main está 2 commits à frente de origin/main (dbbd0b8,
4a04042 não publicados); dev-ai* existem só localmente
evidência:
  $ git branch -vv → dev-ai, dev-ai-codex, dev-ai-opencode, dev-ai-zcode
    (todas em 4a04042; HEAD em dev-ai-zcode)
  este commit vive em dev-ai-zcode — aguardando verificação cruzada
  para subir à dev-ai (verificador: Codex, OpenCode ou humano)
próxima: decidir achados 1–2 da auditoria; resto do BACKLOGS/002; backlogs
