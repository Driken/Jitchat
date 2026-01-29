# 🌐 Guia Rápido: Configurar Domínios no EasyPanel

## 📋 O que você precisa saber

### Opções de Domínios

1. **Domínios Próprios** (Recomendado para produção)
   - Exemplo: `api.seudominio.com` e `app.seudominio.com`
   - Requer configuração DNS

2. **Subdomínios do EasyPanel** (Para testes)
   - Exemplo: `seuprojeto-backend.easypanel.io`
   - Configuração automática

## 🚀 Passo a Passo no EasyPanel

### Passo 1: Acessar Configuração de Domínios

1. No EasyPanel, abra seu projeto
2. Vá na aba **"Domains"** ou **"Networking"**
3. Clique em **"Add Domain"** ou **"New Domain"**

### Passo 2: Configurar Domínio do Backend

**Configurações:**
- **Domain Name**: `api.seudominio.com` (ou o seu)
- **Service**: Selecione `backend` da lista
- **Port**: `8080`
- **SSL/TLS**: ✅ Habilitar
- **Certificate**: Let's Encrypt (automático)
- **Force HTTPS**: ✅ Habilitar

**Clique em "Save" ou "Add"**

### Passo 3: Configurar Domínio do Frontend

**Configurações:**
- **Domain Name**: `app.seudominio.com` (ou o seu)
- **Service**: Selecione `frontend` da lista
- **Port**: `3333`
- **SSL/TLS**: ✅ Habilitar
- **Certificate**: Let's Encrypt (automático)
- **Force HTTPS**: ✅ Habilitar

**Clique em "Save" ou "Add"**

## 🔧 Configurar DNS (Apenas se usar domínios próprios)

### Se você tem domínios próprios:

1. **Acesse o painel do seu provedor de DNS** (Registro.br, GoDaddy, etc)

2. **Para o Backend (`api.seudominio.com`):**
   - Tipo: `A` ou `CNAME`
   - Nome/Host: `api`
   - Valor/Target: 
     - IP do EasyPanel (fornecido pelo EasyPanel), OU
     - Domínio do EasyPanel (ex: `seuprojeto.easypanel.io`)
   - TTL: `3600` (ou padrão)

3. **Para o Frontend (`app.seudominio.com`):**
   - Tipo: `A` ou `CNAME`
   - Nome/Host: `app`
   - Valor/Target: 
     - IP do EasyPanel (fornecido pelo EasyPanel), OU
     - Domínio do EasyPanel (ex: `seuprojeto.easypanel.io`)
   - TTL: `3600` (ou padrão)

4. **Aguardar propagação DNS:**
   - Pode levar de alguns minutos até 24 horas
   - Verifique em: https://www.whatsmydns.net/

## ✅ Verificar Configuração

### No EasyPanel:

1. Verifique se os domínios aparecem na lista
2. Verifique se o status está "Active" ou "Healthy"
3. Verifique se o SSL está configurado (ícone de cadeado)

### Testar Manualmente:

**Backend:**
```bash
curl https://api.seudominio.com/health
# Deve retornar status 200 (após deploy)
```

**Frontend:**
```bash
curl https://app.seudominio.com
# Deve retornar HTML da aplicação (após deploy)
```

## ⚠️ Problemas Comuns

### Domínio não resolve

**Solução:**
- Verifique se o DNS está configurado corretamente
- Aguarde a propagação DNS (pode levar até 24h)
- Use `nslookup api.seudominio.com` para verificar

### SSL não funciona

**Solução:**
- Certifique-se de que o DNS está apontando corretamente
- Aguarde alguns minutos após configurar o domínio
- O EasyPanel precisa validar o domínio antes de emitir o certificado

### Domínio não aparece no EasyPanel

**Solução:**
- Verifique se você salvou a configuração
- Recarregue a página
- Verifique se o serviço está rodando

## 📝 Checklist

Antes de fazer deploy:

- [ ] Domínio do backend configurado no EasyPanel
- [ ] Domínio do frontend configurado no EasyPanel
- [ ] SSL/TLS habilitado em ambos
- [ ] DNS configurado (se usando domínios próprios)
- [ ] DNS propagado (verificado em whatsmydns.net)
- [ ] Variáveis de ambiente com URLs corretas

## 🎯 Próximo Passo

Após configurar os domínios, você está pronto para fazer o deploy!

Consulte `CHECKLIST-DEPLOY.md` para continuar.
