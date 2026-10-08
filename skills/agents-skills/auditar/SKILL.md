---
name: auditar
description: >
  Diagnóstico sob demanda com evidência: varreduras mecânicas de integridade
  (drift, órfãos, tetos, padrões suspeitos) e leitura forense sequencial do
  LOG para localizar onde a execução degradou. Reporta com gravidade e
  evidência citável; não remedia no mesmo fôlego. Invocada explicitamente —
  nunca automática. Única skill que lê o arquivo histórico, não o estado.
---

# auditar

## Objetivo
Responder "onde o processo falhou" com entrada de LOG na mão, não palpite.
Cada skill do sistema declarou como falha; aqui as assinaturas convergem.

## Dois escopos, dois custos
| Escopo | O que faz | Custo | Quando |
|---|---|---|---|
| varredura | checagens mecânicas, greppáveis | baixo | sintoma leve, rotina |
| forense | LOG em sequência até a divergência | alto | qualidade caiu, entrega errada, retrabalho |

Com sintoma: varredura + forense do objetivo suspeito — paginada via catálogo
de objetivos, que existe para isto. Forense total (todo o LOG, todo objetivo)
é a última opção, nunca a primeira: ler o passado é caro, e é barato
justamente porque é sob demanda.

## Triagem — sintoma → primeiro lugar para olhar
| Sintoma | Primeira parada |
|---|---|
| "entregou errado" | LOG de clarificar (premissas não validadas) + verificar-objetivo (esperado/obtido) |
| retrabalho crescendo | reclassificações em voo, downgrades, specs retroativas |
| "agente ignora as regras" | qual campo falta sistematicamente → a skill dona |
| NOW estourando o teto | decompor: tamanho de micro |
| doc desatualizada | varredura de sincronia; implementar pulou o passo 6 |
| commit fora do fluxo | divergência commit↔touched sem pending = bypass do gate |

## Varredura (as 8 checagens)
1. **Drift**: `última-sincronia` da doc < `git log -1 -- <unidade>` → doc velha.
2. **Órfãos bidirecionais**: CATALOG↔arquivos · ADR↔unidades (frontmatter
   `decisions` ↔ campo `unidades`) · termos do GLOSSARY sem uso.
3. **Tetos**: NOW>100 · doc>40 · entrada de LOG>60 · ADR>50. Estouro
   sistemático aponta upstream — não é problema de escrita.
4. **Padrões no LOG**: 100% pass desde o início · esperado==obtido sempre ·
   trivial com diff grande · downgrades seguidos de objetivo quebrado ·
   "zero ambiguidades" repetido · ≥3 premissas não validadas por task.
5. **contencao:** idade + gatilho já atingido e não migrado.
6. **pending-human antigo**: existe há mais de uma sessão = cold starts
   pulando o §1 do AGENTS.md — pior furo silencioso do sistema.
7. **PLAN**: `concluído` escrito por não-gate · `pendente-verificação` eterno
   (o humano nunca reportou — a dívida ficou em aberto para sempre).
8. **Bypass do gate**: commit com arquivos fora de `touched` e sem pending
   = `--no-verify`. O gate foi contornado; a evidência fica no histórico.

## Forense — a pergunta-guia
Para cada transição do LOG do objetivo, em ordem:
- o input declarado era o recebido de fato (contra os artefatos)?
- o output declarado foi produzido (contra git/arquivos)?
- os campos obrigatórios da skill dona estão presentes?

> **Em qual transição começou a divergência?**
> A PRIMEIRA é a falha; tudo depois é cascata. Corrigir cascata sem achar
> a primeira divergência é patch de sintoma — o bug-irmão fica esperando.
> (É a lei do `conter` — causa raiz — aplicada ao próprio processo.)

## Gravidade
| Nível | Definição |
|---|---|
| **crítico** | o estado MENTE: ghost-state, esperado mudado em silêncio, `concluído` sem gate, bypass, pending não-processado |
| **maior** | mecanismo ignorado: campos de LOG ausentes, sem classificação prévia, sem esperado-antes-de-obtido |
| **menor** | higiene: drift, órfãos, tetos, formato |

Estado que contraria a realidade é pior que estado ausente: ausente custa
uma leitura; mentiroso custa uma decisão errada.

## Reporte
`docs/auditorias/NNN-[escopo].md`:

```markdown
# Auditoria NNN — [escopo] — [data]
gatilho: [sintoma que a disparou]
## Achados
| # | grav. | achado | evidência (LOG/arquivo+linha) | causa provável | correção mínima | skill dona |
|---|---|---|---|---|---|---|
## Conclusão
[onde a degradação começou — ou "sem degradação; X é suspeito por Y"]
```

## Disciplina — diagnóstico, não remediação
- Achado sem evidência citável não é achado, é opinião.
- **Não corrija no mesmo fôlego.** Exceção única: fix trivial de 1 linha
  (linha de catálogo faltando), registrado como `audit-fix` no LOG.
  Fix durante auditoria destrói a cena do crime.
- Achados roteiam para a skill dona — a correção é reforçar/aplicar a
  verificação daquela skill, nunca consertar "por conveniência" aqui.
- Auditoria é transição: entrada no LOG apontando o relatório.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "No geral está tudo bem" | Varredura rodou? Achados citáveis? "No geral" sem evidência é opinião — a regra desta skill. |
| "Corrijo enquanto acho" | Misturar diagnóstico com remediação destrói evidência. 1 linha, no máximo, logada. |
| "LOG grande demais para ler" | Isso É um achado — e é por isto que forense é sob demanda e paginada por objetivo. |
| "Eu lembro do que aconteceu" | Memória de sessão é exatamente o que a auditoria não pode usar. Evidência ou não aconteceu. |
| "Sem achados — auditoria perfeita" | Nove mecanismos com conformidade total desde o dia 1 é ficção. Sem achados = varredura rasa ou leitura condescendente. |

## Verificação
- [ ] Todo achado cita entrada de LOG ou arquivo+linha — sem exceção.
- [ ] Gravidade atribuída; skill dona roteada; correção mínima proposta.
- [ ] Relatório salvo em docs/auditorias/ e apontado pela entrada de LOG.
- [ ] Nenhum fix não-trivial executado durante a auditoria.
- [ ] Forense apontou a PRIMEIRA divergência, não a mais visível.
- [ ] Varredura cobriu as 8 checagens — pulou uma? Registrou qual e por quê.