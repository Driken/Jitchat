# 🔧 Configuração de Domínios - Jitchat (Whaticket Community)

## ✅ Domínios Configurados

- **Frontend**: `app.jitchat.com.br`
- **Backend**: `api.jitchat.com.br`

## 📋 Variáveis de Ambiente no EasyPanel

Configure estas variáveis no EasyPanel:

```bash
# Sistema
NODE_ENV=production
BACKEND_URL=https://api.jitchat.com.br
FRONTEND_URL=https://app.jitchat.com.br
PROXY_PORT=443

# Banco de Dados
DB_USER=postgres
DB_PASS=SuaSenhaForte123!
DB_NAME=whaticket

# JWT (gere valores únicos!)
JWT_SECRET=kZaOTd+VFLOQDsSgPWN1GGK1opQo6TLz11sX+h5h1TU=
JWT_REFRESH_SECRET=HuB9Dgg12FfgL7g6SD7AB7E1xIb3NfF10oNbRmK1XdS=

# Frontend Build
REACT_APP_BACKEND_URL=https://api.jitchat.com.br
```

## 🚀 Como Fazer Deploy

### 1. Commit e Push das Alterações

```powershell
cd c:\Users\Administrador\Documents\Jitchat
git add .
git commit -m "Migrar para Whaticket Community com código fonte completo"
git push
```

### 2. Configure os Domínios no EasyPanel

**Backend:**
- Domain: `api.jitchat.com.br`
- Service: `backend`
- Port: `8080`
- SSL: Habilitar

**Frontend:**
- Domain: `app.jitchat.com.br`
- Service: `frontend`
- Port: `3333`
- SSL: Habilitar

### 3. Configure o DNS

Aponte ambos os subdomínios para o IP do EasyPanel:
- `app.jitchat.com.br` → IP do EasyPanel
- `api.jitchat.com.br` → IP do EasyPanel

### 4. Redeploy

Após configurar variáveis e domínios, faça o redeploy no EasyPanel.

## 📝 Credenciais Padrão

Após o primeiro deploy, acesse `https://app.jitchat.com.br` com:

- **Email**: `admin@whaticket.com`
- **Senha**: `admin`

⚠️ **Troque a senha imediatamente após o primeiro login!**

## ✅ O que foi Corrigido

1. ✅ Migrado para Whaticket Community (código fonte completo)
2. ✅ Backend com TypeScript compilado corretamente
3. ✅ Frontend com build React funcionando
4. ✅ Erro de rota `/*` corrigido
5. ✅ PostgreSQL configurado
6. ✅ Dockerfiles otimizados

## 🐛 Se houver problemas

1. Verifique os logs no EasyPanel
2. Certifique-se que todas as variáveis estão configuradas
3. Aguarde o DNS propagar (pode levar até 24h)
