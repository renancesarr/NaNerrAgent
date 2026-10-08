# 009 — publicação das branches no origin (trivial — fast path)
quando: 2026-10-08
classificação (conter, ANTES): trivial — push de branches, zero diff de código
o quê: git push -u origin main dev-ai dev-ai-codex dev-ai-opencode dev-ai-zcode
porque: usuário mandou publicar — a topologia multiagente passa a valer
       agora para os outros agentes (fetch + checkout da sua branch no origin)
