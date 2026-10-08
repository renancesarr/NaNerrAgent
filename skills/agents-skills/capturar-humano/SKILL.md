---
name: capturar-humano
description: >
  Converte edição humana fora do fluxo em conhecimento: lê o porquê e o
  conceito de .context/pending-human.md, gera o "como" a partir do diff real,
  registra no LOG, reconcilia NOW/PLAN/ADRs/docs. Roda no cold start de toda
  sessão com pending preenchido — antes de qualquer task, porque a edição pode
  invalidar o estado. Não roda se pending vazio (o gate cuida da obrigatoriedade).
---

# capturar-humano

## Objetivo
A edição humana entra no fluxo como conhecimento capturado, não como buraco
negro. O porquê é capturado no único momento em que existe: antes do commit.
Depois, vira arqueologia.

## O ponto de partida não é o pending — é a janela da session
A captura mora no `.context/log/NNN-capturar-humano.md` — como qualquer transição.
O pending (`porque:` + `conceito:`) é o **handshake barato com o gate**: as duas
linhas que o pre-commit exige do humano às 3h da manhã. Handshake ≠ captura.
Handshake paga fricção mínima; captura paga o resto — adiada até a sessão do
agente, quando há tempo e contexto.

## Protocolo do cold start (AGENTS.md §1)
Existe pending com `porque:` preenchido? Rode antes de QUALQUER task.
A edição pode invalidar o NOW, o PLAN, uma ADR, a doc de unidade — por isso
capturar-humano é a exceção à regra da exceção à regra da sessão:
**o pending é lido no cold start mesmo sendo "apenas" estado**.
Sem pending, o cold start normal (NOW + LOG) segue.

## Processo
1. **Valide o gate que já rodou.** O commit já passou pelo pre-commit: pending
   existia e estava preenchido. Confira que o `porquê` casa com o diff —
   porquê de pergunta "por que você alterou?" com diff que não explica
   = handshake vazio, o gate foi satisfeito sem capturar nada.
2. **Obtenha o diff real.** O humano pode ter escrito "ajustei o login" e
   commitado 6 arquivos. O pending nunca é a fonte técnica — é o complemento.
   Diff do commit correspondente + estado atual (`git status` — pode haver
   alteração não commitada por cima).
2. **Leia porque/conceito verbatim.** Verbatim é regra, não cortesia:
   paráfrase do agente apaga o matiz que torna o conhecimento valioso.
   "O botão não tava funcionando" ≠ "usuários não conseguiam submeter".
3. **Gere o "como" conectando técnica ao porquê.** A partir do diff:
   o que a edição faz tecnicamente, conectado ao porquê escrito. O gerado
   recebe etiqueta — o humano pode ter escrito coisas erradas; o agente não
   tem como saber se "o cache era o problema" é verdade. Etiqueta preserva
   honestidade epistêmica: `[gerado por IA a partir do diff]` no campo como.
4. **Registre a entrada no LOG:**

```markdown
# NNN — capturar-humano (origem: edição manual)
quando: [timestamp do commit]
porque: [verbatim do humano]
conceito: [verbatim do humano]
como: [gerado, conectando técnica ao porquê — etiquetado]
unidades afetadas: [do diff]
impacto no NOW: [nenhum | ajuste feito: ...]
impacto em ADRs: [nenhuma | ver modelar-dominio]
impacto em docs: [nenhuma | ver catalogar]
```

5. **Reconciliação em cascata** (ordem: estado vivo primeiro, arquivos mortos depois):

| Ação | Quando | Skill dona |
|---|---|---|
| NOW reescrito | a edição muda o próximo passo | aqui |
| PLAN ajustado | a edição resolve/quebra um micro | aqui |
| ADR emendada ou substituída | a edição contradiz uma decisão | `modelar-dominio` |
| Doc de unidade reescrita | a edição muda contrato | `catalogar` |
| CATALOG atualizado | unidade criada/removida | `catalogar` |

A cascata dispara skills, não as executa: cada dona faz o seu trabalho sob as
suas próprias regras. `modelar-dominio` decide emenda vs. substituição pelo seu
teste de promoção — não é decisão daqui.

6. **Fast path do humano-quebrado: "não sei por que mudei".**
   Humano sem porquê não é recusa — é o caso real mais comum. Rota:
   - agente gera 2–3 hipóteses do porquê a partir do diff;
   - humano escolhe ou descarta;
   - escolhida → vira `porque:` com etiqueta `[hipótese confirmada]`;
   - descartadas todas → `porque: [não determinado — diff autônomo]`.
   Sem porquê nenhum, o commit era YAGNI puro — registra e segue.
   Não interrogue além disso: todo porquê tem um custo, e este já pagou.
7. **Limpeza.** pending-human.md volta a vazio; `.context/touched` limpo
   (consumido). Estado consumido é estado limpo.
8. **Registre a transição** — a entrada acima É o registro.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Diff pequeno, não precisa capturar" | O diff pequeno com o porquê errado é o bug caro. Custo: ler 2 linhas. |
| "Só sincronizo o NOW e sigo" | Sem porquê, a edição vira mistério permanente — arqueologia na próxima auditoria. |
| "O porquê tá no commit message" | Não está. E mesmo estando, não tem formato nem garantia de existência. |
| "Gero o como sem etiqueta, é mais limpo" | A etiqueta separa o que o humano disse do que o agente infere. Sem ela, inferência vira fato no LOG. |
| "Hipótese não confirmada é igual a sem porquê" | É melhor: tem direção, contexto, e pode ser confirmada depois. O LOG tem história. |
| "A edição foi trivial, pulo a cascata" | Trivial para o diff, não para o estado. Uma linha de uma ADR pode exigir reconciliação total. |

## Verificação
- [ ] Entrada de LOG com porque/conceito verbatim + como etiquetado.
- [ ] Diff real obtido e confrontado com o pending (handshake não-vazio).
- [ ] Cascata avaliada: NOW/PLAN/ADR/doc/CATALOG — impacto registrado para cada um.
- [ ] Pending e touched limpos após a captura.
- [ ] Fast path executado quando o humano não sabia o porquê.
- [ ] Toda acão da cascata disparou a skill dona — nada executado "no escopo por conveniência".