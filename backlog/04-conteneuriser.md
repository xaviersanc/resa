---
title: Conteneuriser l'application et sa base de données
labels: env
---

Installer PostgreSQL à la main sur chaque poste n'est pas reproductible.

**Critères d'acceptation**

- [x] `docker-compose.yml` : un service `db` (PostgreSQL 17, initialisé avec `db/init.sql`, données dans un volume nommé) et un service `app`
- [x] `Dockerfile` pour l'application : image officielle, dépendances de production uniquement, utilisateur non-root
- [x] `.dockerignore` (au minimum `node_modules`, `.env`, `.git`)
- [x] `docker compose up --build` → http://localhost:3000 affiche les salles
