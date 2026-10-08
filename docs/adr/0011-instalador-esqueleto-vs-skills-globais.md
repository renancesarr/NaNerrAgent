---
id: 0011
status: aceita
supersedes: —
unidades: [installer/install.sh, installer/templates/, installer/test-install.sh]
---
# Instalador: esqueleto copiado por projeto, skills globais por máquina

## contexto
Instalar o sistema em projetos novos exigia decidir o que entra no
repo-alvo. O alvo precisa das leis (AGENTS.md), do gate e de catálogos/
contexto ZERADOS — nunca do histórico do meta-repo (DELTA_VERSION, IDEIA,
BACKLOGS, auditorias, LOG). As 9 skills, porém, já têm fonte única no
meta-repo com symlinks por CLI (LOG 002); copiá-las por projeto criaria
N fontes divergentes.

## alternativas
- Copiar tudo (skills inclusas) por projeto: rejeitada — quebra o DRY;
  evoluir uma skill exigiria re-propagação em todos os repos.
- Symlink do alvo apontando o meta-repo: rejeitada — o alvo quebraria em
  clones sem o meta-repo no mesmo caminho de máquina.
- Esqueleto copiado + skills globais (escolhida): alvo versiona só o que
  é dele (leis, gate, catálogos, contexto); skills chegam pelo CLI.

## consequências
Ganhamos: alvo autocontido e versionável desde o primeiro commit (touched
já vem declarando os plantados); fonte única das skills; whitelist torna
o instalador idempotente e incapaz de vazar histórico do meta-repo.
Abrimos mão: o alvo não documenta as skills localmente (depende do CLI
configurado); projetos que divergirem do núcleo resolvem via
implements-skills próprias, não via fork das agent-skills.
