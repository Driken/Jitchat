# ============================================
# Dockerfile para Izing - Sistema de Atendimento
# Com FlowBuilder, Multi-canal e Chatbot
# ============================================

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
COPY izing/backend/package*.json ./

# Instalar dependências
RUN npm install

# Copiar código fonte
COPY izing/backend/ ./

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
COPY izing/frontend/package*.json ./

# Instalar dependências
RUN npm install

# Copiar código fonte
COPY izing/frontend/ ./

# Argumentos de build para variáveis Vue
ARG VUE_URL_API=http://localhost:3100
ARG VUE_FACEBOOK_APP_ID=23156312477653241

# Criar .env para o build
RUN echo "VUE_URL_API=${VUE_URL_API}" > .env && \
    echo "VUE_FACEBOOK_APP_ID=${VUE_FACEBOOK_APP_ID}" >> .env

# Build do frontend (Quasar)
RUN npx quasar build -m spa || npm run build

# ============================================
# STAGE 3: Backend Final
# ============================================
FROM node:18-slim AS backend

# Instalar dependências para Chrome/Puppeteer e FFmpeg
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    nano \
    ffmpeg \
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
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

# Instalar Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Instalar PM2 globalmente
RUN npm install pm2@latest -g

WORKDIR /app

# Copiar dependências instaladas e código compilado
COPY --from=backend-builder /app/node_modules ./node_modules
COPY --from=backend-builder /app/dist ./dist
COPY --from=backend-builder /app/package*.json ./
COPY izing/backend/.sequelizerc ./

# Criar diretórios necessários
RUN mkdir -p /app/public /app/.wwebjs_auth

# Variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3000
ENV PROXY_PORT=3100
ENV CHROME_BIN=/usr/bin/google-chrome-stable
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

EXPOSE 3100

# Comando para iniciar
CMD ["sh", "-c", "npx sequelize db:migrate && pm2-runtime start ./dist/server.js"]

# ============================================
# STAGE 4: Frontend Final
# ============================================
FROM node:18-slim AS frontend

WORKDIR /app

# Instalar servidor estático
RUN npm install -g serve

# Copiar build do frontend
COPY --from=frontend-builder /app/dist/spa ./dist

# Variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3333

EXPOSE 3333

# Comando para iniciar
CMD ["serve", "-s", "dist", "-l", "3333"]
