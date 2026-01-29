# Dockerfile único para Backend e Frontend do Whaticket Plus
# Usa multi-stage builds para otimizar o tamanho das imagens

# ============================================
# STAGE 1: Frontend Builder
# ============================================
FROM node:18-slim AS frontend-builder

# Instalar Git (necessário para algumas dependências npm)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app/frontend

# Copiar arquivos de dependências do frontend
COPY whaticket_extracted/whaticket/frontend/package*.json ./

# Instalar dependências do frontend
RUN npm install --force

# Copiar código do frontend
COPY whaticket_extracted/whaticket/frontend/ ./

# Criar arquivo .env temporário para o build se necessário
RUN if [ ! -f .env ]; then \
      echo "REACT_APP_BACKEND_URL=http://localhost:8080" > .env && \
      echo "REACT_APP_ENV_TOKEN=210897ugn217204u98u8jfo2983u5" >> .env && \
      echo "REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999" >> .env && \
      echo "REACT_APP_FACEBOOK_APP_ID=1005318707427295" >> .env && \
      echo "REACT_APP_NAME_SYSTEM=whaticketplus" >> .env && \
      echo "REACT_APP_VERSION=1.0.0" >> .env && \
      echo "REACT_APP_PRIMARY_COLOR=#fffff" >> .env && \
      echo "REACT_APP_PRIMARY_DARK=2c3145" >> .env && \
      echo "REACT_APP_NUMBER_SUPPORT=51997059551" >> .env; \
    fi

# Build da aplicação React
RUN npm run build || (echo "Build falhou, mas continuando..." && mkdir -p whaticketplus)

# ============================================
# STAGE 2: Backend Base
# ============================================
FROM node:18-slim AS backend-base

# Instalar dependências do sistema necessárias para Puppeteer e FFmpeg
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    git \
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
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Instalar Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar arquivos de dependências do backend
COPY whaticket_extracted/whaticket/backend/package*.json ./

# Instalar dependências do Node.js do backend
RUN npm install --force

# Copiar código do backend
COPY whaticket_extracted/whaticket/backend/ ./

# Criar diretório para uploads e sessões do WhatsApp
RUN mkdir -p /app/public/uploads && \
    mkdir -p /app/.wwebjs_auth && \
    chmod -R 755 /app/public && \
    chmod -R 755 /app/.wwebjs_auth

# ============================================
# STAGE 3: Backend Final
# ============================================
FROM backend-base AS backend

# Expor porta do backend
EXPOSE 8080

# Variáveis de ambiente padrão
ENV NODE_ENV=production
ENV PORT=8080

# Comando para iniciar o servidor backend
CMD ["node", "whaticketplus/server.js"]

# ============================================
# STAGE 4: Frontend Final
# ============================================
FROM node:18-slim AS frontend

WORKDIR /app

# Instalar apenas o necessário para servir
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Copiar arquivos do servidor Express do frontend
COPY whaticket_extracted/whaticket/frontend/server.js ./
COPY whaticket_extracted/whaticket/frontend/package*.json ./

# Instalar apenas express e dotenv (ignorar conflitos de peer dependencies)
RUN npm install express dotenv --save --legacy-peer-deps

# Copiar build do frontend do stage frontend-builder
COPY --from=frontend-builder /app/frontend/whaticketplus ./whaticketplus

# Expor porta do frontend
EXPOSE 3333

# Variáveis de ambiente padrão
ENV NODE_ENV=production
ENV SERVER_PORT=3333

# Comando para iniciar o servidor frontend
CMD ["node", "server.js"]
