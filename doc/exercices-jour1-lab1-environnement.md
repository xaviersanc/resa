# Lab 1 — « Ça marche sur ma machine »

## Séance 1 · 1h05 · en équipe (2–3)

**Objectif :** à la fin du TP, Résa démarre en **3 commandes** sur la machine de **chaque** membre de l'équipe, sans installer PostgreSQL à la main.

> **Terminal :** toutes les commandes de cette fiche sont écrites pour **bash**. Sous Windows, travaille dans **WSL 2** (Ubuntu) : `wsl --install` dans un PowerShell lancé en administrateur, puis redémarre. Clone le dépôt dans ton dossier Linux (`~/`), **pas** dans `/mnt/c/…`, et ouvre-le avec `code .`. Dans Docker Desktop : _Settings → Resources → WSL integration_ → active Ubuntu. PowerShell refuse certaines commandes de la fiche.
>
> Les mots en MAJUSCULES (`PROPRIETAIRE`, `NUMERO`…) sont à remplacer par ta valeur.

> Ce matin, tout le monde pousse directement sur `main`. Ça va coincer : c'est voulu, on en parle cet après-midi.
>
> **Non négociable avant 13h :** `.env` retiré du suivi et poussé (rôle B), et une section `## Équipe` dans le README (elle sert au Lab 2). Le reste peut se terminer en début d'après-midi.
>
> Bloqué·e plus de 10 minutes ? Lève la main.

---

## 0. Avant tout (2 min)

Les téléchargements lancés pendant le cours sont-ils terminés ?

```bash
docker images
```

Tu dois voir `node` (tag `26-alpine`) et `postgres` (tag `17-alpine`). Sinon, lance-les maintenant, ils serviront à l'étape 3 :

```bash
docker pull node:26-alpine
docker pull postgres:17-alpine
```

> **Plan B — pas de Docker, ou pas de droits administrateur sur ton poste :** travaille dans **GitHub Codespaces** (voir l'encadré en fin de fiche). Tu fais exactement le même TP, dans un onglet du navigateur.

---

## 1. Créer le dépôt de l'équipe (10 min)

**Une seule personne (le ou la « propriétaire ») :**

1. Ouvre <https://github.com/peauc/resa-starter> → **Use this template** → **Create a new repository**.
2. Owner : ton compte GitHub **personnel** · Repository name : `resa` · **Public** → **Create repository**.
3. **Settings → Collaborators → Add people** : ajoute chaque coéquipier·e. Un·e coéquipier·e absent·e ? Ajoute-le/la quand même (l'invitation reste valable 7 jours).
4. Onglet **Actions** → workflow **Seed backlog** → **Run workflow**, **une seule fois**. Après ~30 s, l'onglet **Issues** contient 20 tickets, de #1 à #20.
   - Le workflow n'apparaît pas encore ? Attends 30 secondes et recharge la page.
   - **Ne crée aucun ticket à la main avant la fin du workflow** : les numéros #1 à #20 sont ceux des fiches.

**Les coéquipier·e·s :** acceptez l'invitation (mail, ou <https://github.com/notifications>).

**Tout le monde :**

```bash
git clone https://github.com/PROPRIETAIRE/resa.git
cd resa
git config user.name "Prénom Nom"
git config user.email "TON-EMAIL-GITHUB"
npm run doctor
```

- `TON-EMAIL-GITHUB` : ton adresse personnelle, ou l'adresse `…@users.noreply.github.com` affichée sur <https://github.com/settings/emails> (_Keep my email addresses private_). **Pas l'adresse de ton entreprise** : le dépôt est public, et tes commits doivent être rattachés à ton compte.
- `npm run doctor` n'a besoin d'aucun paquet, mais il lui faut Node.js. « npm n'est pas reconnu » ? Passe en Plan B (Codespaces). Note les ❌ : certains sont normaux à ce stade.

> `git push` te demande un mot de passe ? Sous Windows, Git Credential Manager ouvre le navigateur. Ailleurs, installe GitHub CLI, puis `gh auth login` (HTTPS, _Login with a web browser_) et `gh auth setup-git`. GitHub n'accepte pas le mot de passe de ton compte.

**✓ Checklist**

- [ ] Chaque membre a un clone de `resa` et a configuré `user.name` / `user.email`
- [ ] Les tickets #1 à #20 sont visibles dans l'onglet Issues

---

## 2. Suivre le README (5 min)

Lis le README de Résa et essaie de le suivre **sans installer PostgreSQL**. Ensuite, en équipe : listez tout ce qui empêche un·e nouvel·le arrivant·e de lancer le projet, puis comparez avec les tickets **#1 à #5** (label `env`).

---

## 3. Se répartir le travail (40 min)

| Rôle                             | Tickets                                                                                   | Fichiers                                                                                                                  |
| -------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **A** — versions et éditeur      | #2 « Fixer la version de Node.js du projet », #5 « Partager la configuration de l'éditeur » | `.nvmrc`, `package.json` (`engines`), `.editorconfig`, `.gitattributes`, `.vscode/extensions.json`, `.vscode/settings.json` |
| **B** — configuration et secrets | #3 « Le fichier .env contient un mot de passe et il est versionné »                       | `.gitignore`, `.env.example`, `src/db.js`, `src/server.js`                                                                |
| **C** — conteneurs               | #4 « Conteneuriser l'application et sa base de données »                                  | `Dockerfile`, `.dockerignore`, `docker-compose.yml`                                                                       |

En binôme : une personne prend **A + B**, l'autre **C**.

> **Ordre imposé :** **B pousse en premier**, dans les 10 premières minutes (`.gitignore`, `git rm --cached .env`, `.env.example`). Tant que B n'a pas poussé, **personne ne modifie `.env`**. Ensuite, chacun fait `git pull --rebase`, puis `cp .env.example .env`, et choisit son mot de passe.
>
> **Dès que tu as fini ton rôle (A ou B), rejoins C** : un seul clavier, et un·e « pilote » qui change toutes les 10 minutes. Chacun·e doit savoir expliquer pourquoi `PGHOST` vaut `db` dans le conteneur, à quoi sert `healthcheck` et ce que fait `volumes`.

Ce matin, chacun pousse directement sur `main` :

```bash
git add FICHIERS
git commit -m "MESSAGE" -m "Closes #2, closes #5"     # un mot-clé par ticket : le ticket se ferme au push
git push
# refusé ? quelqu'un a poussé avant toi :
git pull --rebase
git push
```

Conflit pendant `git pull --rebase` ? Ouvre le fichier signalé, garde ce qui a du sens (souvent les deux versions), puis :

```bash
git add FICHIER
git rebase --continue
```

Perdu·e ? `git rebase --abort` revient à l'état d'avant le `pull`.

Les noms des variables d'environnement, à utiliser par **tous** les rôles :

| Variable                | Rôle                                  | Valeur en local                                    |
| ----------------------- | ------------------------------------- | -------------------------------------------------- |
| `PORT`                  | port de l'application                 | `3000`                                             |
| `PGHOST`                | hôte PostgreSQL                       | `localhost`                                        |
| `PGPORT`                | port PostgreSQL publié sur ta machine | `5433`                                             |
| `PGUSER` / `PGDATABASE` | utilisateur et base                   | `resa` / `resa`                                    |
| `PGPASSWORD`            | mot de passe                          | **à choisir** (lettres et chiffres), jamais versionné |

La bibliothèque `pg` lit ces variables `PG*` toute seule : pas besoin de construire une URL de connexion.

### Rôle A — versions et éditeur (#2, #5)

1. Crée `.nvmrc` contenant `26`, puis installe cette version :
   - macOS / Linux / WSL : `nvm install`, puis `nvm use` (pas de `nvm` ? installe-le : <https://github.com/nvm-sh/nvm#installing-and-updating>) ;
   - Windows : nvm-windows (droits administrateur nécessaires) ne lit pas `.nvmrc` : `nvm install 26`, puis `nvm use 26` ;
   - poste verrouillé : passe ton chemin, la version sera vérifiée dans Docker ou Codespaces. Il te faut quand même Node 22 ou plus pour le Lab 2.
2. Dans `package.json`, ajoute :
   ```json
   "engines": { "node": ">=26 <27" }
   ```
3. Crée `.editorconfig` :

   ```ini
   root = true

   [*]
   charset = utf-8
   end_of_line = lf
   indent_style = space
   indent_size = 2
   insert_final_newline = true
   trim_trailing_whitespace = true

   [*.md]
   trim_trailing_whitespace = false
   ```

4. Crée `.gitattributes` contenant `* text=auto eol=lf`. Question : à quoi sert-il pour un·e coéquipier·e sous Windows ?
5. Crée `.vscode/extensions.json` qui recommande ESLint, Prettier, EditorConfig, Docker et SonarQube for IDE (cherche leur identifiant dans l'onglet Extensions de VS Code : clic droit → _Copy Extension ID_).
6. Crée `.vscode/settings.json` : VS Code enregistrera alors tous les fichiers avec des fins de ligne Unix (LF), indispensables aux hooks Git du Lab 2.
   ```json
   {
     "files.eol": "\n"
   }
   ```

**✓** `npm run doctor` : la ligne Node est ✅.

### Rôle B — configuration et secrets (#3) — tu pousses en premier

1. Crée `.gitignore` : `node_modules/`, `.env`, `coverage/`, `*.log`.
2. Arrête de suivre `.env` **sans le supprimer de ton disque** : `git rm --cached .env`
3. Crée `.env.example` (versionné) avec les variables du tableau ci-dessus et `PGPASSWORD=change-me`.
4. **Pousse ces trois changements maintenant** (`Closes #3` viendra avec la suite), puis préviens l'équipe.
5. `src/db.js` : supprime la chaîne de connexion écrite en dur. `new Pool()` sans argument suffit, puisque `pg` lit les variables `PG*`. Garde les lignes `types.setTypeParser(…)` et `pool.on("error", …)`.
6. `src/server.js` : juste après `require("dotenv").config()`, arrête l'application avec un message clair si `PGHOST`, `PGUSER`, `PGPASSWORD` ou `PGDATABASE` manque.
7. Ton propre `.env` : `cp .env.example .env`, puis choisis un mot de passe (lettres et chiffres uniquement : `$`, `#`, les espaces et les guillemets posent problème). **Pas** `Resa2026!Bdx` : il est sur GitHub, il est grillé.

**✓** `git status` ne montre plus `.env` ; `npm run doctor` : « .env non versionné » est ✅.

### Rôle C — conteneurs (#4)

1. Complète ce `Dockerfile` :
   ```dockerfile
   FROM node:26-alpine
   WORKDIR /app
   ENV NODE_ENV=production
   # 1. copier package.json et package-lock.json, puis installer UNIQUEMENT les dépendances de production :
   #    npm ci --omit=dev --ignore-scripts
   #    → pourquoi copier ces deux fichiers AVANT le reste du code ?
   # 2. copier src/ et public/
   # 3. ne pas tourner en root : l'image node fournit l'utilisateur « node »
   EXPOSE 3000
   CMD ["node", "src/server.js"]
   ```
2. Crée `.dockerignore` : qu'est-ce qui ne doit **jamais** entrer dans l'image ? (au minimum `node_modules`, `.env`, `.git`)
3. Complète ce `docker-compose.yml` :

   ```yaml
   services:
     db:
       image: postgres:17-alpine
       environment:
         POSTGRES_USER: ${PGUSER}
         POSTGRES_PASSWORD: ${PGPASSWORD}
         POSTGRES_DB: ${PGDATABASE}
       volumes:
         # - un volume nommé monté sur /var/lib/postgresql/data
         # - ./db/init.sql monté dans /docker-entrypoint-initdb.d/ (exécuté au premier démarrage)
       ports:
         - "127.0.0.1:${PGPORT}:5432" # base joignable depuis ta machine uniquement
       healthcheck:
         test:
           [
             "CMD-SHELL",
             "pg_isready -h 127.0.0.1 -U $${POSTGRES_USER} -d $${POSTGRES_DB}",
           ]
         interval: 2s
         retries: 30

     app:
       # - construire l'image depuis le Dockerfile
       # - charger les variables depuis .env (env_file)…
       # - …mais, dans le réseau Compose, la base s'appelle « db » et écoute sur 5432 : surcharge PGHOST et PGPORT
       # - dans le conteneur, l'application écoute toujours sur 3000 : surcharge aussi PORT: "3000"
       # - publier le port ${PORT} de ta machine vers le port 3000 du conteneur : "${PORT:-3000}:3000"
       # - attendre que db soit « healthy » (depends_on + condition)

   # déclarer le volume nommé
   ```

4. Teste, **après le push de B** : `git pull --rebase`, puis `cp .env.example .env`, choisis un mot de passe, et lance `docker compose up --build`.

**✓** <http://localhost:3000> affiche les salles F204, F205… et les réservations.

---

## 4. README : démarrer en 3 commandes (5 min, une seule personne écrit)

**Une seule personne** réécrit le README (ticket #1) ; les autres relisent et poussent autre chose, puis font `git pull --rebase` à la fin. Contenu :

- une phrase de description ;
- **Prérequis** : Git, Docker + Compose v2, Node.js 26 (pour les hooks Git du Lab 2 et pour développer hors conteneur) ;
- **Démarrer en 3 commandes** :
  ```bash
  git clone https://github.com/PROPRIETAIRE/resa.git
  cd resa
  cp .env.example .env
  docker compose up --build
  ```
- **Développer sans reconstruire l'image** : `nvm use`, `npm ci`, `docker compose up -d db`, `npm run dev` ;
- **Dépannage** : port déjà utilisé (changer `PORT` ou `PGPORT` dans `.env`) ; `docker compose down -v` pour réinitialiser la base (`init.sql` ne s'exécute que sur un volume vide) ; Linux : `permission denied` sur Docker ;
- une section vide `## Équipe` en bas du fichier (elle sert cet après-midi).

Commit : `git commit -m "docs: README démarrer en 3 commandes" -m "Closes #1"`.

---

## ✓ Point de contrôle final (chaque membre, sur sa machine)

```bash
git pull --rebase
cp .env.example .env      # seulement si tu n'as pas encore de .env, puis choisis un mot de passe
docker compose up --build
```

- [ ] <http://localhost:3000> affiche les salles et les réservations
- [ ] `npm run doctor` : tout est ✅
- [ ] `git ls-files .env` n'affiche rien
- [ ] Les tickets #1 à #5 sont fermés
- [ ] Je sais expliquer chaque ligne de notre `docker-compose.yml`

---

> **Plan B — GitHub Codespaces**
>
> Sur la page du dépôt de l'équipe : **Code → Codespaces → Create codespace on main**. Chacun·e ouvre **son propre** Codespace, avec son compte : tes commits restent les tiens. Dans le terminal du Codespace :
>
> ```bash
> nvm install
> nvm use
> cp .env.example .env
> docker compose up --build
> ```
>
> Onglet **Ports** → port 3000 → icône globe pour ouvrir l'application. Git y est déjà configuré : `commit` et `push` comme sur ta machine.
> Quota gratuit : 60 h par mois sur une machine 2 cœurs. Pense à arrêter le Codespace en fin de séance (<https://github.com/codespaces> → ⋯ → Stop).

## Pour aller plus loin

- Image **multi-stage** et `HEALTHCHECK` pour l'application.
- `docker compose watch` (section `develop.watch`) pour recharger l'application à chaque modification.
- Déboguer `npm run dev` dans VS Code (_JavaScript Debug Terminal_, points d'arrêt dans `bookings.service.js`).
