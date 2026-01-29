# ✅ Checklist Final - Pronto para Deploy no EasyPanel

## 📋 Verificações Pré-Deploy

### ✅ Arquivos Essenciais
- [x] `Dockerfile` - Dockerfile único com multi-stage builds
- [x] `docker-compose.yml` - Configurado corretamente
- [x] `.env.example` - Template de variáveis criado
- [x] `whaticket_extracted/whaticket/backend/` - Código do backend presente
- [x] `whaticket_extracted/whaticket/frontend/` - Código do frontend presente

### ⚠️ Antes de Fazer Deploy

1. **Repositório Git**
   - [ ] Todos os arquivos foram commitados
   - [ ] Push feito para o repositório remoto
   - [ ] Repositório está acessível pelo EasyPanel

2. **Variáveis de Ambiente**
   - [ ] Prepare todas as variáveis do `.env.example`
   - [ ] Configure senhas fortes para `DB_PASS` e `REDIS_PASSWORD`
   - [ ] Configure `BACKEND_URL` e `FRONTEND_URL` com seus domínios reais
   - [ ] Configure `JWT_SECRET` e `JWT_REFRESH_SECRET` com valores seguros

3. **Domínios**
   - [ ] Domínio do backend configurado (ex: `api.seudominio.com`)
   - [ ] Domínio do frontend configurado (ex: `app.seudominio.com`)
   - [ ] DNS apontando para o EasyPanel (se necessário)

## 🚀 Passos no EasyPanel

### 1. Criar Projeto Docker Compose

1. Acesse o EasyPanel
2. Clique em **"New Project"**
3. Escolha **"Docker Compose"**
4. Conecte seu repositório Git
5. Configure:
   - **Compose File**: `docker-compose.yml`
   - **Root Directory**: `/` (raiz)

### 2. Adicionar Variáveis de Ambiente

No EasyPanel, vá em **Environment Variables** e adicione:

**Obrigatórias (copie do .env.example):**
```
BACKEND_URL=https://api.seudominio.com
FRONTEND_URL=https://app.seudominio.com
DB_PASS=sua_senha_forte_aqui
REDIS_PASSWORD=sua_senha_redis_aqui
JWT_SECRET=sua_chave_jwt_secreta_aqui
JWT_REFRESH_SECRET=sua_chave_refresh_secreta_aqui
```

**Importante**: Substitua os valores de exemplo pelos seus valores reais!

### 3. Configurar Domínios

**Backend:**
- Domínio: `api.seudominio.com` (ou o seu)
- Serviço: `backend`
- Porta: `8080`
- SSL: Habilitado

**Frontend:**
- Domínio: `app.seudominio.com` (ou o seu)
- Serviço: `frontend`
- Porta: `3333`
- SSL: Habilitado

### 4. Fazer Deploy

1. Clique em **"Deploy"** ou **"Save & Deploy"**
2. Aguarde a construção (pode levar 10-15 minutos na primeira vez)
3. Monitore os logs de cada serviço

### 5. Após o Deploy

1. **Inicializar Banco de Dados:**
   - Acesse o terminal do container `backend`
   - Execute:
     ```bash
     cd /app
     npx sequelize db:migrate
     npx sequelize db:seed:all
     ```

2. **Verificar Logs:**
   - Backend deve mostrar: "Server started on port: 8080"
   - Frontend deve estar respondendo na porta 3333
   - PostgreSQL e Redis devem estar saudáveis

## ⚠️ Possíveis Problemas

### Build falha
- Verifique se `whaticket_extracted/whaticket/` existe no repositório
- Verifique os logs de build no EasyPanel

### Serviços não iniciam
- Verifique as variáveis de ambiente
- Verifique os logs de cada serviço
- Certifique-se de que os domínios estão configurados

### Banco de dados não conecta
- Verifique se `DB_HOST=postgres` (nome do serviço)
- Verifique as credenciais do banco

## ✅ Status Atual

- ✅ Dockerfile único criado
- ✅ docker-compose.yml configurado
- ✅ Código extraído e presente
- ✅ Documentação completa

## 🎯 Você está pronto para deploy!

Siga os passos acima e monitore os logs durante o processo.
