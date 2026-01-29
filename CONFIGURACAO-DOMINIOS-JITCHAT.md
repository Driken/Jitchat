# 🔧 Configuração de Domínios - jitchat.com.br

## ✅ Domínios Configurados

- **Frontend**: `app.jitchat.com.br`
- **Backend**: `api.jitchat.com.br`

## 📋 Variáveis de Ambiente Necessárias no EasyPanel

Configure as seguintes variáveis de ambiente no EasyPanel:

### 🔴 OBRIGATÓRIAS (URLs do Sistema)

```bash
BACKEND_URL=https://api.jitchat.com.br
FRONTEND_URL=https://app.jitchat.com.br
ALLOWED_ORIGINS=https://app.jitchat.com.br
```

### 🟡 IMPORTANTES (React Build - Frontend)

Estas variáveis são usadas durante o BUILD do frontend:

```bash
REACT_APP_BACKEND_URL=https://api.jitchat.com.br
REACT_APP_ENV_TOKEN=210897ugn217204u98u8jfo2983u5
REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999
REACT_APP_FACEBOOK_APP_ID=1005318707427295
REACT_APP_NAME_SYSTEM=whaticketplus
REACT_APP_VERSION=1.0.0
REACT_APP_PRIMARY_COLOR=#fffff
REACT_APP_PRIMARY_DARK=2c3145
REACT_APP_NUMBER_SUPPORT=51997059551
```

### 🟢 Banco de Dados e Redis

```bash
DB_USER=postgres
DB_PASS=2000@23
DB_NAME=whaticketwhaticketplus
REDIS_PASSWORD=S3202m097dS=
```

### 🔵 JWT (Tokens de Autenticação)

```bash
JWT_SECRET=53pJTvkL9T6q2jYFFKwXgvLAgQahwbb/BM0opll5NZM=
JWT_REFRESH_SECRET=1/n/QnJtfUphUd9CrXjaxRw+jSAxtRIJwFroFmqrRXY=
```

## ⚠️ Problemas Corrigidos

### 1. ✅ Dockerfile - Variáveis React no Build
- **Problema**: `REACT_APP_BACKEND_URL` estava hardcoded como `localhost`
- **Solução**: Agora aceita variáveis via `ARG` durante o build
- **Impacto**: O frontend agora usa a URL correta do backend durante o build

### 2. ✅ docker-compose.yml - Build Args
- **Problema**: Variáveis React não eram passadas durante o build
- **Solução**: Adicionado `build.args` no docker-compose.yml
- **Impacto**: As variáveis são passadas corretamente durante o build

## 📝 Checklist de Configuração

- [ ] ✅ Domínios configurados no DNS:
  - [ ] `app.jitchat.com.br` → IP do EasyPanel
  - [ ] `api.jitchat.com.br` → IP do EasyPanel

- [ ] ✅ Variáveis de ambiente configuradas no EasyPanel:
  - [ ] `BACKEND_URL=https://api.jitchat.com.br`
  - [ ] `FRONTEND_URL=https://app.jitchat.com.br`
  - [ ] `ALLOWED_ORIGINS=https://app.jitchat.com.br`
  - [ ] `REACT_APP_BACKEND_URL=https://api.jitchat.com.br`

- [ ] ✅ Domínios configurados no EasyPanel:
  - [ ] `app.jitchat.com.br` → serviço `frontend` → porta `3333`
  - [ ] `api.jitchat.com.br` → serviço `backend` → porta `8080`

- [ ] ✅ SSL/TLS habilitado (Let's Encrypt) para ambos os domínios

## 🚀 Próximos Passos

1. **Configure as variáveis de ambiente no EasyPanel** (copie e cole as variáveis acima)

2. **Configure os domínios no EasyPanel**:
   - Vá em "Domains" ou "Networking"
   - Adicione `app.jitchat.com.br` apontando para o serviço `frontend` na porta `3333`
   - Adicione `api.jitchat.com.br` apontando para o serviço `backend` na porta `8080`
   - Habilite SSL/TLS (Let's Encrypt) para ambos

3. **Faça o redeploy**:
   - Após configurar as variáveis e domínios
   - Clique em "Redeploy" no EasyPanel
   - O build agora usará as URLs corretas

## 🔍 Verificação

Após o deploy, verifique:

1. **Frontend acessível**: `https://app.jitchat.com.br`
2. **Backend acessível**: `https://api.jitchat.com.br/health` (deve retornar status 200)
3. **Console do navegador**: Não deve ter erros de CORS
4. **Logs do frontend**: Não deve ter erros de conexão com o backend

## ⚠️ Importante

- **`REACT_APP_BACKEND_URL`** DEVE ser igual a **`BACKEND_URL`**
- **`ALLOWED_ORIGINS`** DEVE ser igual a **`FRONTEND_URL`**
- Use sempre **`https://`** (não `http://`)
- Não use barras no final (`/`) nas URLs

## 🐛 Se algo não funcionar

1. Verifique os logs do serviço no EasyPanel
2. Verifique se os domínios estão resolvendo corretamente:
   ```bash
   nslookup app.jitchat.com.br
   nslookup api.jitchat.com.br
   ```
3. Verifique se o SSL está funcionando:
   - Acesse `https://app.jitchat.com.br` (deve abrir sem avisos)
   - Acesse `https://api.jitchat.com.br/health` (deve retornar JSON)
