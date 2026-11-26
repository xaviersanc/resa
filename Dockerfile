FROM node:26-alpine
WORKDIR /app
ENV NODE_ENV=production

# package*.json d'abord : la couche « npm ci » reste en cache tant que les dépendances ne changent pas
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

COPY src/ ./src/
COPY public/ ./public/

# ne pas tourner en root
USER node

EXPOSE 3000
CMD ["node", "src/server.js"]
