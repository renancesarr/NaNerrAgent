---
name: modelar-dominio
description: >
  Mantém a linguagem ubíqua (GLOSSARY.md) e as ADRs do projeto: granularidade
  correta, catálogo indexado, vínculo bidirecional às unidades. É estágio do
  pipeline grande quando há decisão de domínio — e skill de manutenção sob
  demanda quando clarificar detecta conflito com ADR, capturar-humano
  invalida decisão, ou auditar acha vínculos furados. Não usar em triviais.
---

# modelar-dominio

## Objetivo
Termo significa uma coisa só. Decisão com trade-off duradouro tem endereço,
historicamente rastreável — inclusive as decisões de que nos arrependemos.

## Dois repositórios, dois ritmos
| Artefato | Ritmo | Custo | Cuida de |
|---|---|---|---|
| `GLOSSARY.md` | contínuo, fast path | 1 linha por termo | como o sistema FALA |
| `docs/adr/NNN-*.md` + `ADR-CATALOG.md` | por decisão | ~50 linhas cada | como o sistema DECIDE |

## A granularidade — teste de promoção (a régua central desta skill)
Decisões nascem no LOG de toda execução. A pergunta é quando uma vira ADR:

> **Se um agente fresco, trabalhando numa unidade DIFERENTE desta, tomaria
> uma decisão diferente sem conhecer isto → ADR.**
> Se só afeta a unidade/task atual → fica no LOG. Ponto.

As duas falhas simétricas que este teste evita:
- **Explosão**: toda decisão local virando ADR (40 ADRs num sistema pequeno
  = alguém documentou não-decisões).
- **Fome**: decisão de domínio apodrecendo no LOG, descoberta por arqueologia
  no próximo bug que ela causou.

## Glossário — processo
1. Termo novo ou uso inconsistente? **Cheque o glossário antes de cunhar**:
   sinônimo já existe → reutilize. Sinonimia é o DRY do vocabulário; cada
   sinônimo novo é um termo que o agente paga duas vezes para não achar.
2. Entrada: `**termo** — definição em uma linha (sinônimos: ...)`.
3. Definição não cabe em uma linha? O termo está fazendo dois papéis —
   quebre em dois termos, ou a fronteira do domínio está mal cortada.
4. Termo sem uso no código/doc → marque órfão; remoção proposta na
   próxima auditoria.
5. Fast path: termo sozinho, sem decisão → 1 linha no LOG. Sem cerimônia.

## ADR — quando emendar vs. substituir (régua)
| Situação | Ação | Por quê |
|---|---|---|
| detalhe/consequência aprendida; a **escolha continua a mesma** | **emenda** no lugar: edita a seção, status segue `aceita`, LOG registra o que mudou | a decisão não mudou, o entendimento dela amadureceu |
| a **escolha se inverte** (alternativa que perdemos passa a ganhar) | **nova ADR** com `supersedes: NNN`; antiga → `status: substituída`; unidades re-vinculadas à nova | emenda no lugar apagaria o porquê original — e o porquê de termos errado é a arqueologia mais valiosa que existe |

Supersede é o LOG append-only aplicado a decisões: o passado nunca é
reescrito, é apontado por um sucessor.

## ADR — processo
1. Passou no teste de promoção? Crie `docs/adr/NNN-slug.md` (NNN sequencial):

```markdown
---
id: NNN
status: aceita        # aceita | substituída
supersedes: —         # ADR-NNN quando esta substitui
unidades: [caminhos das unidades que a sustentam]
---
# [decisão em uma frase]

## contexto
[que pressão motivou]

## alternativas
[as consideradas, com o contra de cada uma — mínimo 2]

## consequências
[o que ganhamos, o que abrimos mão]
```

2. Corpo ≤ ~50 linhas, uma tela. Passou? São duas decisões — quebre.
3. Linha no `ADR-CATALOG.md`: `| NNN | status | decisão em 1 linha | unidades |` — no mesmo commit (mesma lei do §7 do AGENTS.md).
4. **Vínculo, donos claros**: esta skill mantém o lado da ADR (campo
   `unidades`) e **dispara `catalogar`** para o lado da unidade (frontmatter
   `decisions`). O vínculo bidirecional não viola DRY: ponteiros são navegação,
   conhecimento vive uma vez — na ADR.
5. Terminou: registra transição. LOG: `ADR NNN criada/substituída/emendada + por quê`,
   `termos adicionados/ajustados`.

## Pontos de entrada (única skill nuclear que é estágio E manutenção)
| Gatilho | Origem | Ação |
|---|---|---|
| pipeline grande | `decompor` achou micro com decisão embutida | ADR antes das specs finais |
| conflito de clarificação | `clarificar` passo 7: escolha contradiz ADR | escolha validada → emenda ou nova ADR |
| edição humana | `capturar-humano`: diff invalida decisão | reconciliar + re-vincular unidades |
| auditoria | `auditar`: órfãs, vínculos velhos | corrigir catálogo e vínculos |

## DDD-lite — onde para
Sim: linguagem ubíqua, decisões rastreáveis, fronteiras por domínio.
Não: bounded contexts formais, agregados, eventos de domínio, cerimônia.
CRUD é CRUD. Forçar DDD num CRUD gera o arquivo-morto que este sistema existe para matar.

## Anti-racionalização
| Desculpa | Resposta |
|---|---|
| "Decido e documento depois" | Depois nunca chega; a decisão vira arqueologia no próximo bug. |
| "É detalhe técnico, não ADR" | Então é comentário no código — confirme a granularidade, não pule o registro. |
| "A decisão é óbvia" | Óbvia até o bug que a reverte. Tinha alternativas reais e consequência duradoura? Passou no teste de promoção? Não é óbvia. |
| "Emendo direto, é mais rápido" | Se a escolha se inverteu, emenda apaga o porquê original. A economia de agora custa a arqueologia de depois. |
| "Toda decisão merece ADR" | Teste de promoção: afeta unidade OUTRA? Não? LOG. 40 ADRs num sistema pequeno é ninguém lendo nenhuma. |
| "Crio o termo na hora que preciso" | Checou o glossário? Sinônimo novo é vocabulário duplicado — o agente paga para não achar. |

## Verificação
- [ ] ADR sem `alternativas` com ≥ 2 opções reais = inválida.
- [ ] ADR substituída aponta sucessora E sucessora aponta `supersedes` — catálogo bidirecional.
- [ ] Unidade vinculada apenas a ADR `substituída` = vínculo velho; re-vincular.
- [ ] Termo do glossário com 2 significados no código = falha desta skill.
- [ ] Toda ADR nova tem linha no ADR-CATALOG no mesmo commit.
- [ ] Toda decisão promovida passou pelo teste de promoção — registrado no LOG ("promovida porque afeta ...").