# 🔧 Guia Completo: Configurar Variáveis de Ambiente e Domínios

## 📋 Passo 1: Preparar Variáveis de Ambiente

### 1.1. Gerar Senhas Seguras

Você precisa gerar senhas seguras para:
- `DB_PASS` - Senha do PostgreSQL
- `REDIS_PASSWORD` - Senha do Redis  
- `JWT_SECRET` - Chave secreta JWT (mínimo 32 caracteres)
- `JWT_REFRESH_SECRET` - Chave secreta para refresh token (mínimo 32 caracteres)

**Opções para gerar senhas:**

**Opção A - Online (rápido):**
- Acesse: https://www.lastpass.com/pt/features/password-generator
- Configure: 32+ caracteres, incluir símbolos
- Gere uma senha para cada item acima

**Opção B - PowerShell (Windows):**
```powershell
# Gerar senha de 32 caracteres
-join ((48..57) + (65..90) + (97..122) + (33..47) | Get-Random -Count 32 | % {[char]$_})
```

**Opção C - Usar valores padrão seguros (copie e altere alguns caracteres):**
```
DB_PASS=Whaticket2024!Secure@Pass#123
REDIS_PASSWORD=Redis2024!Secure@Pass#456
JWT_SECRET=JwtSecret2024!VerySecureKey@12345678901234567890
JWT_REFRESH_SECRET=RefreshSecret2024!VerySecure@12345678901234567890
```

### 1.2. Configurar URLs dos Domínios

**IMPORTANTE**: Você precisa ter 2 domínios ou subdomínios:

1. **Backend (API)**: Exemplo: `api.seudominio.com` ou `api-whaticket.seudominio.com`
2. **Frontend (App)**: Exemplo: `app.seudominio.com` ou `whaticket.seudominio.com`

**Se você NÃO tem domínios ainda:**

**Opção A - Usar subdomínios gratuitos:**
- Freenom (freenom.com) - domínios .tk, .ml, .ga gratuitos
- No-IP (noip.com) - subdomínios dinâmicos gratuitos

**Opção B - Comprar domínio:**
- Registro.br (para .br)
- Namecheap, GoDaddy (para .com, .net, etc)

**Opção C - Usar domínio do EasyPanel (se disponível):**
- O EasyPanel pode fornecer um subdomínio temporário
- Exemplo: `seuprojeto.easypanel.io`

### 1.3. Template de Variáveis para EasyPanel

Copie e cole no EasyPanel, substituindo os valores:

```env
# ============================================
# CONFIGURAÇÕES GERAIS
# ============================================
NODE_ENV=production

# URLs do Sistema (SUBSTITUA pelos seus domínios)
BACKEND_URL=https://api.seudominio.com
FRONTEND_URL=https://app.seudominio.com
ALLOWED_ORIGINS=https://app.seudominio.com
PROXY_PORT=443

# ============================================
# BANCO DE DADOS POSTGRESQL
# ============================================
DB_TIMEZONE=-03:00
DB_DIALECT=postgres
DB_HOST=postgres
DB_USER=postgres
DB_PASS=SUA_SENHA_FORTE_AQUI
DB_NAME=whaticketwhaticketplus
DB_PORT=5432
DB_DEBUG=false
DB_BACKUP=/app/backup

# ============================================
# REDIS
# ============================================
REDIS_PASSWORD=SUA_SENHA_REDIS_AQUI
REDIS_URI=redis://:SUA_SENHA_REDIS_AQUI@redis:6379
REDIS_OPT_LIMITER_MAX=1
REGIS_OPT_LIMITER_DURATION=3000

# ============================================
# JWT (Tokens de Autenticação)
# ============================================
JWT_SECRET=SUA_CHAVE_JWT_SECRETA_AQUI_MINIMO_32_CARACTERES
JWT_REFRESH_SECRET=SUA_CHAVE_REFRESH_SECRETA_AQUI_MINIMO_32_CARACTERES

# ============================================
# CHAVES MASTER
# ============================================
MASTER_KEY=
ENV_TOKEN=
WHATSAPP_UNREADS=

# ============================================
# FACEBOOK/INSTAGRAM (Opcional)
# ============================================
VERIFY_TOKEN=Whaticket
FACEBOOK_APP_ID=
FACEBOOK_APP_SECRET=

# ============================================
# CONFIGURAÇÕES DO NAVEGADOR
# ============================================
BROWSER_CLIENT=
BROWSER_NAME=Chrome
BROWSER_VERSION=10.0
VIEW_QRCODE_TERMINAL=true

# ============================================
# CONFIGURAÇÕES DE EMAIL (Opcional)
# ============================================
MAIL_HOST=
MAIL_USER=
MAIL_PASS=
MAIL_FROM=
MAIL_PORT=587

# ============================================
# GERENCIANET (Opcional)
# ============================================
GERENCIANET_SANDBOX=false
GERENCIANET_CLIENT_ID=
GERENCIANET_CLIENT_SECRET=
GERENCIANET_PIX_CERT=
GERENCIANET_PIX_KEY=

# ============================================
# OPENAI (Opcional)
# ============================================
OPENAI_API_KEY=

# ============================================
# FRONTEND - Variáveis React
# ============================================
REACT_APP_BACKEND_URL=https://api.seudominio.com
REACT_APP_ENV_TOKEN=210897ugn217204u98u8jfo2983u5
REACT_APP_HOURS_CLOSE_TICKETS_AUTO=9999999
REACT_APP_FACEBOOK_APP_ID=1005318707427295
REACT_APP_NAME_SYSTEM=whaticketplus
REACT_APP_VERSION=1.0.0
REACT_APP_PRIMARY_COLOR=#fffff
REACT_APP_PRIMARY_DARK=2c3145
REACT_APP_NUMBER_SUPPORT=51997059551
```

## 📋 Passo 2: Configurar Domínios no EasyPanel

### 2.1. Antes de Configurar Domínios

**Se você JÁ tem domínios:**
1. Configure os registros DNS apontando para o EasyPanel
2. Aguarde a propagação DNS (pode levar até 24h)

**Se você NÃO tem domínios:**
1. Use o domínio temporário do EasyPanel primeiro
2. Depois configure seus domínios reais

### 2.2. Configurar Domínio do Backend

No EasyPanel:

1. Vá em **"Domains"** ou **"Networking"**
2. Clique em **"Add Domain"** ou **"New Domain"**
3. Configure:
   - **Domain**: `api.seudominio.com` (ou o seu)
   - **Service**: Selecione `backend`
   - **Port**: `8080`
   - **SSL/TLS**: Habilitar (Let's Encrypt)
   - **Force HTTPS**: Habilitar

### 2.3. Configurar Domínio do Frontend

No EasyPanel:

1. Vá em **"Domains"** ou **"Networking"**
2. Clique em **"Add Domain"** ou **"New Domain"**
3. Configure:
   - **Domain**: `app.seudominio.com` (ou o seu)
   - **Service**: Selecione `frontend`
   - **Port**: `3333`
   - **SSL/TLS**: Habilitar (Let's Encrypt)
   - **Force HTTPS**: Habilitar

### 2.4. Configurar DNS (se necessário)

Se você está usando seus próprios domínios, configure os registros DNS:

**Para o Backend (`api.seudominio.com`):**
- Tipo: `A` ou `CNAME`
- Nome: `api` (ou `@` se for domínio raiz)
- Valor: IP do EasyPanel ou domínio fornecido pelo EasyPanel
- TTL: `3600` (ou padrão)

**Para o Frontend (`app.seudominio.com`):**
- Tipo: `A` ou `CNAME`
- Nome: `app` (ou `@` se for domínio raiz)
- Valor: IP do EasyPanel ou domínio fornecido pelo EasyPanel
- TTL: `3600` (ou padrão)

**Verificar DNS:**
- Use: https://www.whatsmydns.net/
- Digite seu domínio e verifique se está apontando corretamente

## 📋 Passo 3: Checklist Final

Antes de fazer deploy, verifique:

- [ ] Senhas geradas e seguras (32+ caracteres)
- [ ] `DB_PASS` configurada
- [ ] `REDIS_PASSWORD` configurada
- [ ] `JWT_SECRET` configurada (32+ caracteres)
- [ ] `JWT_REFRESH_SECRET` configurada (32+ caracteres)
- [ ] `BACKEND_URL` configurada com seu domínio real
- [ ] `FRONTEND_URL` configurada com seu domínio real
- [ ] `REACT_APP_BACKEND_URL` igual ao `BACKEND_URL`
- [ ] `ALLOWED_ORIGINS` igual ao `FRONTEND_URL`
- [ ] Domínios configurados no EasyPanel
- [ ] DNS apontando corretamente (se usando domínios próprios)
- [ ] SSL/TLS habilitado nos domínios

## 🚨 Importante

1. **NUNCA** compartilhe suas senhas ou chaves secretas
2. **SEMPRE** use HTTPS (SSL/TLS) em produção
3. **ALTERE** todas as senhas padrão antes do deploy
4. **MANTENHA** backup das variáveis de ambiente em local seguro

## ✅ Próximo Passo

Após configurar tudo acima, você está pronto para fazer o deploy no EasyPanel!

Consulte o arquivo `CHECKLIST-DEPLOY.md` para os próximos passos.
