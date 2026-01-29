# Dockerfile para Whaticket Community
# Adaptado para deploy com EasyPanel/Docker

# ============================================
# STAGE 1: Backend Builder
# ============================================
FROM node:18-slim AS backend-builder

WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de dependências
COPY whaticket_community/backend/package*.json ./

# Instalar dependências
RUN npm install

# Copiar código fonte
COPY whaticket_community/backend/ ./

# Compilar TypeScript
RUN npm run build

# ============================================
# STAGE 2: Frontend Builder
# ============================================
FROM node:18-slim AS frontend-builder

WORKDIR /app

# Instalar git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de dependências
COPY whaticket_community/frontend/package*.json ./

# Instalar dependências
RUN npm install

# Copiar código fonte
COPY whaticket_community/frontend/ ./

# Argumentos de build para variáveis React
ARG REACT_APP_BACKEND_URL=http://localhost:8080
ARG REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999

# Criar .env para o build
RUN echo "REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}" > .env

# Build do frontend
RUN npm run build

# ============================================
# STAGE 3: Backend Final
# ============================================
FROM node:18-slim AS backend

# Instalar dependências para Puppeteer/Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Instalar Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar dependências instaladas e código compilado
COPY --from=backend-builder /app/node_modules ./node_modules
COPY --from=backend-builder /app/dist ./dist
COPY --from=backend-builder /app/package*.json ./
COPY whaticket_community/backend/.sequelizerc ./

# Criar diretórios necessários
RUN mkdir -p /app/public /app/.wwebjs_auth

# Variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=8080
ENV CHROME_BIN=/usr/bin/google-chrome-stable
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROME_ARGS="--no-sandbox --disable-setuid-sandbox"

EXPOSE 8080

# Comando para iniciar
CMD ["sh", "-c", "npx sequelize db:migrate && node dist/server.js"]

# ============================================
# STAGE 4: Frontend Final
# ============================================
FROM node:18-slim AS frontend

WORKDIR /app

# Copiar servidor Express
COPY whaticket_community/frontend/server.js ./

# Instalar Express
RUN npm init -y && npm install express dotenv

# Copiar build do frontend
COPY --from=frontend-builder /app/build ./build

# Variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3333

EXPOSE 3333

# Comando para iniciar
CMD ["node", "server.js"]
