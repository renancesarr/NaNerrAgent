# AGENTS.md

Você trabalha com estado fora da conversa: catálogos indexam o que existe,
ADRs registram por que existe, NOW/LOG registram onde a execução está.
Nada de importante vive só na sua memória de sessão.

## 1. Primeira ação de toda sessão

1. Existe `.context/pending-human.md` com `porque:` preenchido?
   → rode `capturar-humano` antes de qualquer task. A edição humana pode
   invalidar o NOW; reconcilie antes de retomar.
2. Existe `.context/NOW.md` com status `em-progresso`?
   → leia o NOW + a última entrada do LOG → confira contra `git status`
   e os artefatos reais. Divergência? Re-valide a etapa; nunca retome cego.
   Sem divergência? Execute o "próximo passo imediato".
3. Nada existe → toda task nova começa em `conter` (classificação, §4).

## 2. Leis de engenharia

1. **Unidade coesa**: um arquivo = um conceito = um motivo para
   mudar. Se o nome do arquivo não é o nome do único conceito dele, ele faz
   coisa demais. Guia: 50–150 linhas.
2. **DRY**: cada conhecimento tem UMA representação autoritativa.
   Catálogo aponta; nunca duplica.
3. **KISS/YAGNI**: implemente quando precisar, nunca quando prevê que vai
   precisar. Sem abstração não pedida; stdlib antes de custom; dependência
   nova exige justificativa no LOG.
4. **SOLID traduzido**: um motivo para mudar (S) · variantes novas sem tocar
   consumidores (O) · contratos honrados (L) · interfaces pequenas (I) ·
   dependências passadas, não globais (D).
5. **Doc obrigatória** : toda unidade tem `.md` de contexto com
   vínculo às ADRs. Unidade sem doc ou doc sem unidade = commit bloqueado.
6. **Bug = causa raiz**: grep todo caller antes de tocar. Patch no sintoma
   deixa o irmão quebrado.

## 3. Skills — taxonomia e visibilidade

| Camada | Quem conhece | Conteúdo |
| agent-skills (9, fixas) | sempre carregadas | clarificar, decompor, modelar-dominio, catalogar, implementar, verificar-objetivo, conter, capturar-humano, auditar |
| implements-skills | **só `implementar`**, via IMPLEMENTS-CATALOG.md | varia por projeto: dialeto, testes, padrões |
| platform-skills | só quando a task é de deploy | vercel, cloudflare, … |

**Lei da visibilidade**: `implementar` é a ÚNICA porta para implements-skills.
Nenhuma outra skill — nem este arquivo — conhece uma única delas. A seleção de
cada execução é registrada no LOG com justificativa (ausência também:
"nenhuma aplicável porque…").

**Critério de classificação**: sobrevive a um repo vazio → agent-skill.
Precisa de código para existir → implements-skill.

## 4. Pipeline e classificação

`conter` classifica ANTES de executar:

| Classe | Critério | Caminho |
|---|---|---|
| trivial | diff < 10 linhas, sem mudança de contrato | diff mínimo + 1 linha de LOG. Fim. |
| média | uma unidade ou um micro | clarificar leve → implementar → verificar-objetivo |
| grande | muda entendimento, várias unidades, decisão de domínio | clarificar → decompor → (modelar-dominio) → implementar → verificar-objetivo |

Toda etapa de média/grande termina com registro context-now (§6). Sem exceção.
Burocracia em tarefa trivial é o caminho mais curto para ódio ao processo.

## 5. Verificação — QA-first

O **teste do objetivo** é o gate de entrega: como um QA testaria? Comportamento,
integração, aceitação — com evidência executável (comando + saída no LOG).
A forma varia por projeto (mora em implements-skills); a exigência é fixa.

- Unitário segue TDD à risca, mas é higiene interna.
- Unitário verde + objetivo quebrado = **REPROVADO**.
- "Vou validar depois" = onde objetivos vão morrer. Não existe depois.

## 6. Protocolo context-now

```markdown

.context/NOW.md        snapshot, reescrito a cada transição, teto 100 linhas
.context/log/NNN-*.md  append-only; o passado nunca é reescrito

```

**Escreve sempre** (via tool de arquivo — não polui a janela), ao fim de toda
skill de média/grande. **Lê sob demanda**, em 3 gatilhos: (1) cold start com
NOW em-progresso; (2) pós-compaction ou queda de confiança no estado;
(3) auditoria ou escolha de rota, via catálogo de objetivos.

**Regra de linha do NOW**: entra se, e somente se, muda uma decisão futura.
**Teto como diagnóstico** (ADR-0009): estourou 100 linhas → a decomposição
falhou. Volte uma etapa; não escreva um NOW maior.

## 7. Commits

- Commit que toca unidade toca (ou declara inalterada) a doc dela e as ADRs
  vinculadas — no mesmo commit (ADR-0004).
- O agente declara os arquivos que vai tocar em `.context/touched`;
  `hooks/pre-commit` compara contra o staged.
- Divergência (arquivo fora do fluxo) exige `.context/pending-human.md`
  preenchido: `porque` + `conceito` (ADR-0007). Sem isso, commit bloqueado.
  Fast path do gate: lockfiles e `.md` sem frontmatter de unidade → basta
  `porque`. `capturar-humano` expande o pending em entrada completa do LOG
  na sessão seguinte.

```markdown

As unidades, ADRs e skills deste repo estão indexadas em CATALOG.md e ADR-CATALOG.md. Consulte-os; não os duplique aqui.

```
