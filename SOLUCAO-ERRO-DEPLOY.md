# 🔧 Solução: Erros no Deploy EasyPanel

## ❌ Erros Encontrados

### 1. Aviso sobre `version` obsoleto
```
the attribute `version` is obsolete, it will be ignored
```
**✅ CORRIGIDO**: Removida a linha `version: '3.8'` do docker-compose.yml

### 2. Erro: Dockerfile não encontrado
```
failed to read dockerfile: open Dockerfile: no such file or directory
```

## 🔍 Causa do Problema

O EasyPanel não está encontrando o `Dockerfile` no repositório. Isso pode acontecer por:

1. **Dockerfile não está commitado no Git**
2. **Dockerfile está em subpasta**
3. **Root Directory configurado incorretamente**

## ✅ Soluções

### Solução 1: Verificar se Dockerfile está no Git

1. **No seu computador local**, verifique:
```bash
git status
git ls-files | grep Dockerfile
```

2. **Se o Dockerfile não estiver no Git**, adicione:
```bash
git add Dockerfile
git commit -m "Adicionar Dockerfile"
git push
```

### Solução 2: Verificar Root Directory no EasyPanel

No EasyPanel, verifique a configuração do serviço Compose:

1. Vá em **Settings** do serviço Compose
2. Verifique **Root Directory**:
   - Deve estar como `/` (raiz do repositório)
   - OU vazio (também significa raiz)

### Solução 3: Verificar Estrutura do Repositório

Certifique-se de que a estrutura está assim:

```
seu-repositorio/
├── Dockerfile          ← DEVE ESTAR AQUI
├── docker-compose.yml  ← DEVE ESTAR AQUI
├── .env.example
├── .dockerignore
└── whaticket_extracted/
    └── whaticket/
        ├── backend/
        └── frontend/
```

### Solução 4: Verificar .dockerignore

Certifique-se de que o `.dockerignore` NÃO está ignorando o Dockerfile:

```bash
# Verifique o conteúdo do .dockerignore
cat .dockerignore

# Se tiver algo como "Dockerfile" ou "*Dockerfile*", remova
```

## 📋 Checklist de Verificação

Antes de tentar deploy novamente:

- [ ] Dockerfile existe na raiz do repositório
- [ ] Dockerfile está commitado no Git (`git ls-files Dockerfile`)
- [ ] docker-compose.yml está commitado no Git
- [ ] Root Directory no EasyPanel está como `/` ou vazio
- [ ] .dockerignore não está ignorando o Dockerfile
- [ ] Foi feito `git push` após adicionar o Dockerfile

## 🚀 Passos para Corrigir

### 1. Adicionar Dockerfile ao Git (se necessário)

```bash
# Verificar se está no Git
git ls-files Dockerfile

# Se não aparecer nada, adicionar:
git add Dockerfile
git commit -m "Adicionar Dockerfile para deploy"
git push
```

### 2. Verificar no EasyPanel

1. Vá em **Settings** do serviço Compose
2. Verifique:
   - **Compose File**: `docker-compose.yml`
   - **Root Directory**: `/` (ou vazio)
3. Clique em **Save**

### 3. Tentar Deploy Novamente

1. Clique em **Deploy** ou **Redeploy**
2. Monitore os logs
3. Verifique se o build inicia corretamente

## 🔍 Verificar Logs no EasyPanel

Após tentar deploy, verifique os logs:

1. Vá em **Logs** do serviço Compose
2. Procure por:
   - `Building backend` - indica que encontrou o Dockerfile
   - `failed to read dockerfile` - indica que ainda não encontrou

## ⚠️ Se o Problema Persistir

### Opção A: Verificar Permissões

Certifique-se de que o Dockerfile tem permissões corretas:
```bash
chmod 644 Dockerfile
git add Dockerfile
git commit -m "Corrigir permissões Dockerfile"
git push
```

### Opção B: Verificar Encoding

Certifique-se de que o Dockerfile está em UTF-8:
```bash
file Dockerfile
# Deve mostrar: Dockerfile: ASCII text
```

### Opção C: Recriar o Serviço

Se nada funcionar:
1. Delete o serviço Compose no EasyPanel
2. Crie um novo serviço Compose
3. Configure tudo novamente

## 📝 Arquivos que DEVEM estar no Git

Certifique-se de que estes arquivos estão commitados:

```bash
git ls-files | grep -E "(Dockerfile|docker-compose|\.env\.example)"
```

Deve mostrar:
- `Dockerfile`
- `docker-compose.yml`
- `.env.example`

## ✅ Após Corrigir

1. Faça commit e push de todos os arquivos necessários
2. No EasyPanel, clique em **Redeploy**
3. Monitore os logs para verificar se o build inicia

## 🎯 Resumo

**Problema**: Dockerfile não encontrado  
**Causa**: Arquivo não está no Git ou Root Directory incorreto  
**Solução**: Adicionar Dockerfile ao Git e verificar Root Directory no EasyPanel
