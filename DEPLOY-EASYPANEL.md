# 🚀 Guia Rápido de Deploy no EasyPanel

## Checklist Pré-Deploy

- [ ] Repositório Git configurado com todos os arquivos
- [ ] Arquivo `whaticket.zip` extraído na pasta `whaticket_extracted/whaticket/`
- [ ] Dockerfile único criado (com multi-stage builds)
- [ ] Domínios configurados (backend e frontend)
- [ ] Variáveis de ambiente preparadas

## Passos no EasyPanel

### 1. Criar Novo Projeto

1. Acesse o EasyPanel
2. Clique em **"New Project"**
3. Escolha **"Docker Compose"**
4. Conecte seu repositório Git

### 2. Configurar Docker Compose

- **Compose File**: `docker-compose.yml`
- **Root Directory**: `/` (raiz do repositório)

### 3. Adicionar Variáveis de Ambiente

Copie todas as variáveis do arquivo `.env.example` e configure no EasyPanel:

**Obrigatórias:**
```
BACKEND_URL=https://api.seudominio.com
FRONTEND_URL=https://app.seudominio.com
DB_PASS=sua_senha_forte_aqui
REDIS_PASSWORD=sua_senha_redis_aqui
JWT_SECRET=sua_chave_jwt_secreta_aqui
JWT_REFRESH_SECRET=sua_chave_refresh_secreta_aqui
```

### 4. Configurar Domínios

**Backend (API):**
- Domínio: `api.seudominio.com`
- Serviço: `backend`
- Porta: `8080`
- SSL: Habilitado

**Frontend (App):**
- Domínio: `app.seudominio.com`
- Serviço: `frontend`
- Porta: `3333`
- SSL: Habilitado

### 5. Deploy Inicial

1. Clique em **"Deploy"**
2. Aguarde a construção das imagens (pode levar 5-10 minutos)
3. Monitore os logs de cada serviço

### 6. Inicializar Banco de Dados

Após o primeiro deploy bem-sucedido:

1. Acesse o terminal do container `backend`
2. Execute:
```bash
cd /app
npx sequelize db:migrate
npx sequelize db:seed:all
```

### 7. Verificar Status

Verifique se todos os serviços estão rodando:
- ✅ PostgreSQL: Porta 5432
- ✅ Redis: Porta 6379
- ✅ Backend: Porta 8080
- ✅ Frontend: Porta 3333

## ⚠️ Problemas Comuns

### Erro: "Cannot find module"
- **Solução**: Verifique se o `whaticket.zip` foi extraído corretamente na pasta `whaticket_extracted/`

### Erro: "Connection refused" no banco
- **Solução**: Verifique se `DB_HOST=postgres` (nome do serviço no docker-compose)

### Frontend não carrega
- **Solução**: Verifique se `REACT_APP_BACKEND_URL` está correto e apontando para o backend

### WhatsApp não conecta
- **Solução**: Verifique os logs do backend e se o Chrome está instalado no container

## 📊 Recursos Recomendados

- **CPU**: 4 cores
- **RAM**: 4GB mínimo, 8GB recomendado
- **Disco**: 20GB mínimo

## 🔄 Atualizações

Para atualizar o sistema:
1. Faça push das alterações para o Git
2. No EasyPanel, clique em **"Redeploy"**
3. Aguarde a reconstrução

## 📝 Notas

- O primeiro deploy pode demorar mais devido ao download de dependências
- Mantenha backups regulares do volume `postgres_data`
- Configure monitoramento para os serviços críticos
