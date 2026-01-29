# Configuração de Domínios - Jitchat (Izing)

## Sistema Izing com FlowBuilder

O Izing é um sistema completo de atendimento com:
- **FlowBuilder Visual** - Crie fluxos de chatbot arrastando e soltando
- **Multi-canal** - WhatsApp, Telegram, Instagram, Messenger
- **Agendamento** - Agende mensagens para envio futuro
- **Campanhas** - Envie mensagens em massa
- **Horário comercial** - Configure horários de funcionamento
- **API Externa** - Integre com outros sistemas

## Domínios Configurados

- **Frontend**: `app.jitchat.com.br`
- **Backend**: `api.jitchat.com.br`

## Variáveis de Ambiente no EasyPanel

Configure estas variáveis no EasyPanel:

```bash
# Sistema
NODE_ENV=production
BACKEND_URL=https://api.jitchat.com.br
FRONTEND_URL=https://app.jitchat.com.br

# Banco de Dados
POSTGRES_USER=postgres
POSTGRES_PASSWORD=SuaSenhaForte123!
POSTGRES_DB=izing

# JWT (gere valores únicos!)
JWT_SECRET=DPHmNRZWZ4isLF9vXkMv1QabvpcA80Rc
JWT_REFRESH_SECRET=EMPehEbrAdi7s8fGSeYzqGQbV5wrjH4i

# RabbitMQ
RABBITMQ_DEFAULT_USER=admin
RABBITMQ_DEFAULT_PASS=SuaSenhaRabbitMQ!

# Tempos do Bot (ms)
MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000
MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000
MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

# Frontend Build
VUE_URL_API=https://api.jitchat.com.br
```

## Como Fazer Deploy

### 1. Commit e Push das Alterações

```powershell
cd c:\Users\Administrador\Documents\Jitchat
git add .
git commit -m "Migrar para Izing com FlowBuilder"
git push
```

### 2. Configure os Domínios no EasyPanel

**Backend:**
- Domain: `api.jitchat.com.br`
- Service: `backend`
- Port: `3100`
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

## Credenciais Padrão

Após o primeiro deploy, acesse `https://app.jitchat.com.br`.

O sistema criará automaticamente um usuário admin. Verifique os logs para obter as credenciais ou use:

- **Email**: `admin@admin.com`
- **Senha**: `admin`

**IMPORTANTE**: Troque a senha imediatamente após o primeiro login!

## Funcionalidades do FlowBuilder

### Acessar o FlowBuilder

1. Faça login no sistema
2. Vá em **Configurações** > **Chatbot**
3. Clique em **Criar Fluxo**

### Elementos Disponíveis

- **Mensagem de texto** - Envie mensagens simples
- **Imagem/Mídia** - Envie imagens, áudios, vídeos
- **Menu de opções** - Crie menus interativos
- **Condição** - Fluxos condicionais (if/else)
- **Transferir** - Transfira para fila ou atendente
- **Finalizar** - Encerre a conversa
- **Webhook** - Integre com APIs externas
- **Delay** - Aguarde antes da próxima ação

## Solução de Problemas

### O FlowBuilder não salva

- Verifique se todas as conexões estão feitas
- Cada nó deve ter entrada e saída conectadas

### Mensagens não são enviadas

- Verifique se o WhatsApp está conectado
- Confira os logs do backend

### Frontend não carrega

- Verifique se `VUE_URL_API` aponta para o backend correto
- Confirme que o backend está rodando
