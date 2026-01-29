# 🐳 Deploy do Whaticket Plus no EasyPanel

Este guia explica como fazer o deploy do Whaticket Plus usando Docker no EasyPanel.

## 📋 Pré-requisitos

- Conta no EasyPanel
- Repositório Git com o código do projeto
- Domínios configurados (um para frontend e outro para backend)

## 🚀 Passo a Passo para Deploy no EasyPanel

### 1. Preparar o Repositório

Certifique-se de que seu repositório contém:
- `Dockerfile` (único Dockerfile com multi-stage builds)
- `docker-compose.yml`
- `.env.example`
- O arquivo `whaticket.zip` extraído na pasta `whaticket_extracted/`

### 2. Configurar Variáveis de Ambiente no EasyPanel

1. Acesse seu projeto no EasyPanel
2. Vá em **Environment Variables**
3. Adicione todas as variáveis do arquivo `.env.example`
4. **IMPORTANTE**: Configure especialmente:
   - `BACKEND_URL`: URL do seu backend (ex: `https://api.seudominio.com`)
   - `FRONTEND_URL`: URL do seu frontend (ex: `https://app.seudominio.com`)
   - `DB_PASS`: Senha forte para o PostgreSQL
   - `REDIS_PASSWORD`: Senha forte para o Redis
   - `JWT_SECRET` e `JWT_REFRESH_SECRET`: Chaves secretas fortes

### 3. Criar Aplicação no EasyPanel

#### Opção A: Usando Docker Compose (Recomendado)

1. No EasyPanel, crie um novo projeto
2. Selecione **Docker Compose**
3. Conecte seu repositório Git
4. Configure o arquivo `docker-compose.yml` como arquivo principal
5. O EasyPanel irá:
   - Construir as imagens automaticamente
   - Iniciar todos os serviços (PostgreSQL, Redis, Backend, Frontend)
   - Configurar a rede entre os containers

#### Opção B: Usando Dockerfile Individual

Se preferir criar serviços separados:

**Backend:**
1. Crie um novo serviço
2. Selecione **Dockerfile**
3. Configure o Dockerfile como `Dockerfile.backend`
4. Porta: `8080`
5. Adicione todas as variáveis de ambiente do backend

**Frontend:**
1. Crie outro serviço
2. Selecione **Dockerfile**
3. Configure o Dockerfile como `Dockerfile.frontend`
4. Porta: `3333`
5. Adicione todas as variáveis de ambiente do frontend

**PostgreSQL:**
1. Crie um serviço de banco de dados PostgreSQL
2. Use a imagem: `postgres:15-alpine`
3. Configure as variáveis de ambiente do banco

**Redis:**
1. Crie um serviço Redis
2. Use a imagem: `redis:7-alpine`
3. Configure a senha do Redis

### 4. Configurar Domínios

No EasyPanel, configure os domínios:

1. **Backend**: Configure o domínio da API (ex: `api.seudominio.com`)
   - Aponte para o serviço backend na porta `8080`
   - Configure SSL/TLS

2. **Frontend**: Configure o domínio do frontend (ex: `app.seudominio.com`)
   - Aponte para o serviço frontend na porta `3333`
   - Configure SSL/TLS

### 5. Executar Migrações do Banco de Dados

Após o primeiro deploy, você precisa executar as migrações:

1. Acesse o terminal do container backend no EasyPanel
2. Execute:
```bash
cd /app
npx sequelize db:migrate
npx sequelize db:seed:all
```

### 6. Verificar Logs

Monitore os logs de cada serviço no EasyPanel para garantir que tudo está funcionando:

- **Backend**: Deve mostrar "Server started on port: 8080"
- **Frontend**: Deve estar servindo na porta 3333
- **PostgreSQL**: Deve estar aceitando conexões
- **Redis**: Deve estar rodando

## 🔧 Configurações Importantes

### Volumes Persistentes

O EasyPanel deve criar automaticamente volumes para:
- Dados do PostgreSQL
- Dados do Redis
- Uploads do backend (`/app/public/uploads`)
- Sessões do WhatsApp (`.wwebjs_auth`)

### Health Checks

Os containers têm health checks configurados. O EasyPanel usará isso para:
- Reiniciar containers que falharem
- Verificar se os serviços estão saudáveis

### Recursos Necessários

Recomendações mínimas:
- **Backend**: 2GB RAM, 2 CPU cores
- **Frontend**: 512MB RAM, 1 CPU core
- **PostgreSQL**: 1GB RAM, 1 CPU core
- **Redis**: 512MB RAM, 1 CPU core

## 🐛 Troubleshooting

### Backend não conecta ao banco de dados

- Verifique se o `DB_HOST` está correto (deve ser `postgres` no docker-compose)
- Verifique as credenciais do banco de dados
- Verifique se o PostgreSQL está rodando e saudável

### Frontend não conecta ao backend

- Verifique se `REACT_APP_BACKEND_URL` está correto
- Verifique se o backend está acessível
- Verifique CORS no backend

### WhatsApp não conecta

- Verifique os logs do backend
- Verifique se o Chrome está instalado corretamente no container
- Verifique permissões do diretório `.wwebjs_auth`

### Erro de migração

- Certifique-se de que o PostgreSQL está rodando antes de executar migrações
- Verifique as credenciais do banco de dados
- Execute `npx sequelize db:migrate:status` para ver o status

## 📝 Notas Importantes

1. **Primeira Execução**: Na primeira vez, o sistema pode demorar mais para iniciar enquanto executa as migrações
2. **QR Code WhatsApp**: O QR code será exibido nos logs do backend. Configure `VIEW_QRCODE_TERMINAL=true` para ver no terminal
3. **Backups**: Configure backups regulares do volume `postgres_data`
4. **Atualizações**: Ao atualizar o código, o EasyPanel reconstruirá automaticamente os containers

## 🔐 Segurança

- **NUNCA** commite o arquivo `.env` no Git
- Use senhas fortes para `DB_PASS`, `REDIS_PASSWORD`, `JWT_SECRET`
- Configure SSL/TLS para todos os domínios
- Mantenha as imagens Docker atualizadas

## 📞 Suporte

Para mais informações sobre o EasyPanel, consulte a [documentação oficial](https://easypanel.io/docs).

Para suporte sobre o Whaticket Plus, entre em contato através do [WhatsApp](https://wa.me/555131916861) ou [E-mail](mailto:whaticketplus@gmail.com).
