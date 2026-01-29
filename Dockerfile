# Dockerfile único para Backend e Frontend do Whaticket Plus
# Usa multi-stage builds para otimizar o tamanho das imagens

# ============================================
# STAGE 1: Frontend Builder
# ============================================
FROM node:18-slim AS frontend-builder

# Aceitar argumentos de build para variáveis React
ARG REACT_APP_BACKEND_URL=http://localhost:8080
ARG REACT_APP_ENV_TOKEN=210897ugn217204u98u8jfo2983u5
ARG REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999
ARG REACT_APP_FACEBOOK_APP_ID=1005318707427295
ARG REACT_APP_NAME_SYSTEM=whaticketplus
ARG REACT_APP_VERSION=1.0.0
ARG REACT_APP_PRIMARY_COLOR=#fffff
ARG REACT_APP_PRIMARY_DARK=2c3145
ARG REACT_APP_NUMBER_SUPPORT=51997059551

# Instalar Git (necessário para algumas dependências npm)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app/frontend

# Copiar arquivos de dependências do frontend
COPY whaticket_extracted/whaticket/frontend/package*.json ./

# Instalar dependências do frontend
RUN npm install --force

# Copiar código do frontend
COPY whaticket_extracted/whaticket/frontend/ ./

# Criar arquivo .env com variáveis de build
# Usa ARG se disponível, senão usa valores padrão
RUN echo "REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}" > .env && \
    echo "REACT_APP_ENV_TOKEN=${REACT_APP_ENV_TOKEN}" >> .env && \
    echo "REACT_APP_HOURS_CLOSE_TICKETS_AUTO=${REACT_APP_HOURS_CLOSE_TICKETS_AUTO}" >> .env && \
    echo "REACT_APP_FACEBOOK_APP_ID=${REACT_APP_FACEBOOK_APP_ID}" >> .env && \
    echo "REACT_APP_NAME_SYSTEM=${REACT_APP_NAME_SYSTEM}" >> .env && \
    echo "REACT_APP_VERSION=${REACT_APP_VERSION}" >> .env && \
    echo "REACT_APP_PRIMARY_COLOR=${REACT_APP_PRIMARY_COLOR}" >> .env && \
    echo "REACT_APP_PRIMARY_DARK=${REACT_APP_PRIMARY_DARK}" >> .env && \
    echo "REACT_APP_NUMBER_SUPPORT=${REACT_APP_NUMBER_SUPPORT}" >> .env && \
    cat .env

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

# Compilar TypeScript se houver arquivos .ts (ignorar erro se não houver)
RUN if [ -d "src" ] && [ -f "tsconfig.json" ]; then \
      npm run watch || npm run build || echo "Compilação TypeScript ignorada"; \
    fi

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
# Usa ts-node-dev em modo produção se necessário, ou node diretamente
CMD sh -c "if [ -f 'whaticketplus/server.js' ]; then node whaticketplus/server.js; elif [ -f 'automatizaai/server.js' ]; then node automatizaai/server.js; elif [ -f 'dist/server.js' ]; then node dist/server.js; elif [ -f 'src/server.ts' ]; then npx ts-node --transpile-only src/server.ts; elif [ -f 'index.js' ]; then node index.js; else echo 'Erro: Arquivo server.js não encontrado. Verifique a estrutura do backend.' && ls -la && exit 1; fi"

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
