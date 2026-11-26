FROM node:26-alpine
WORKDIR /app
ENV NODE_ENV=production
# 1. copier package.json et package-lock.json, puis installer UNIQUEMENT les dépendances de production :
#    npm ci --omit=dev --ignore-scripts
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts
#    → pourquoi copier ces deux fichiers AVANT le reste du code ?
#    -> car il s'agit des dépendances de production, et que l'on veut profiter du cache Docker pour ne pas réinstaller les dépendances à chaque build si elles n'ont pas changé.

# 2. copier src/ et public/
COPY src/ ./src/
COPY public/ ./public/
# 3. ne pas tourner en root : l'image node fournit l'utilisateur « node »
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]
