# Résa

Application de réservation des salles du campus.

## Prérequis

| Outil                      | Version            | Pour quoi faire                                 |
| -------------------------- | ------------------ | ----------------------------------------------- |
| Git                        | récent             | cloner le dépôt                                 |
| Docker + Docker Compose v2 | Docker 24 ou plus  | lancer l'application et PostgreSQL              |
| Node.js                    | 26 (voir `.nvmrc`) | développer hors conteneur, hooks Git (Lab 2)    |

PostgreSQL n'est **pas** à installer : il tourne dans Docker.

## Démarrer en 3 commandes

```bash
git clone https://github.com/xaviersanc/resa.git
cd resa
cp .env.example .env      # puis choisir un mot de passe pour PGPASSWORD
docker compose up --build
```

L'application est disponible sur <http://localhost:3000>.

`PGPASSWORD` : lettres et chiffres uniquement (`$`, `#`, espaces et guillemets posent problème).
Ne versionnez jamais `.env`.

## Vérifier son poste

```bash
npm run doctor
```

## Développer sans reconstruire l'image

```bash
nvm use            # Windows (nvm-windows) : nvm use 26
npm ci
docker compose up -d db
npm run dev
```

## Dépannage

- **Port déjà utilisé** : changez `PORT` (application) ou `PGPORT` (base) dans `.env`, puis relancez.
- **Réinitialiser la base** : `docker compose down -v`. `db/init.sql` ne s'exécute qu'au premier démarrage, sur un volume vide.
- **`Configuration manquante : PG…`** : `.env` n'existe pas ou est incomplet. Refaites `cp .env.example .env`.
- **`password authentication failed`** : vous avez changé `PGPASSWORD` après le premier démarrage. Faites `docker compose down -v`.
- **Linux, `permission denied` sur Docker** : `sudo usermod -aG docker $USER`, puis reconnectez-vous.
- **Windows, le démon Docker ne répond pas** : lancez Docker Desktop.
- **Mauvaise version de Node** : `nvm use` (Windows : `nvm use 26`).

## Équipe

