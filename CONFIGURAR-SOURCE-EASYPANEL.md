# ⚙️ Configurar Source no EasyPanel

## 📋 Tela de Configuração - Source

Baseado na imagem, aqui está o que você precisa configurar:

## ✅ Campos da Tela

### 1. Repository URL *
**Valor atual**: `https://github.com/Driken/Jitchat`

**Verificação:**
- ✅ Se este é seu repositório correto, está OK
- ⚠️ Se não for, altere para o URL do seu repositório Git

**Formato correto:**
- GitHub: `https://github.com/USUARIO/REPOSITORIO`
- GitLab: `https://gitlab.com/USUARIO/REPOSITORIO`
- Bitbucket: `https://bitbucket.org/USUARIO/REPOSITORIO`

### 2. Branch *
**Valor atual**: `main`

**Verificação:**
- ✅ Se você usa `main` como branch principal, está OK
- ⚠️ Se usa `master` ou outra branch, altere aqui

**Branches comuns:**
- `main` (mais comum hoje)
- `master` (antigo padrão)
- `develop` (se usa Git Flow)

### 3. Build Path *
**Valor atual**: `/`

**✅ CORRETO**: Deixe como `/` (raiz do repositório)

**Explicação:**
- `/` significa raiz do repositório
- É onde estão seus arquivos: `Dockerfile`, `docker-compose.yml`, etc.
- Não altere este campo!

### 4. Docker Compose File *
**Valor atual**: `docker-compose.yml`

**✅ CORRETO**: Deixe como `docker-compose.yml`

**Verificação:**
- ✅ Seu arquivo se chama `docker-compose.yml` (correto)
- ⚠️ Se tiver outro nome, altere aqui

## 🔍 Checklist Antes de Salvar

Antes de clicar em **"Save"**, verifique:

- [ ] **Repository URL** está correto (seu repositório Git)
- [ ] **Branch** está correto (`main` ou a branch que você usa)
- [ ] **Build Path** está como `/` (raiz)
- [ ] **Docker Compose File** está como `docker-compose.yml`
- [ ] O repositório está público OU você configurou SSH Key (se privado)

## 🔐 Repositório Privado

Se seu repositório for **privado**:

1. Clique em **"Generate SSH Key"**
2. Copie a chave SSH gerada
3. Adicione no seu repositório Git:
   - **GitHub**: Settings → Deploy keys → Add deploy key
   - **GitLab**: Settings → Repository → Deploy Keys → Add key
   - **Bitbucket**: Settings → Access keys → Add key
4. Use o formato SSH do repositório:
   - `git@github.com:USUARIO/REPOSITORIO.git`

## ✅ Configuração Recomendada

Para o projeto Whaticket Plus, use:

```
Repository URL: https://github.com/Driken/Jitchat
Branch: main
Build Path: /
Docker Compose File: docker-compose.yml
```

## 🚀 Após Salvar

1. Clique em **"Save"**
2. O EasyPanel irá:
   - Clonar o repositório
   - Verificar o docker-compose.yml
   - Preparar para deploy

3. **Próximos passos:**
   - Configure as variáveis de ambiente
   - Configure os domínios
   - Faça o deploy

## ⚠️ Problemas Comuns

### Erro: "Repository not found"
- Verifique se o URL está correto
- Verifique se o repositório existe
- Se for privado, configure SSH Key

### Erro: "Branch not found"
- Verifique se a branch existe no repositório
- Use `main` ou `master` conforme seu repositório

### Erro: "Docker Compose File not found"
- Verifique se `docker-compose.yml` está na raiz do repositório
- Verifique se está commitado no Git
- Verifique se o Build Path está como `/`

## 📝 Resumo

**O que preencher:**

1. ✅ **Repository URL**: Seu repositório Git (já preenchido)
2. ✅ **Branch**: `main` (já preenchido, verifique se está correto)
3. ✅ **Build Path**: `/` (já preenchido, está correto)
4. ✅ **Docker Compose File**: `docker-compose.yml` (já preenchido, está correto)

**Ação:**
- Verifique se o Repository URL está correto
- Verifique se a Branch está correta
- Clique em **"Save"**

## 🎯 Próximo Passo

Após salvar a configuração Source:

1. Configure as **Environment Variables** (variáveis de ambiente)
2. Configure os **Domains** (domínios)
3. Faça o **Deploy**

Consulte `CONFIGURAR-VARIAVEIS.md` e `GUIA-RAPIDO-DOMINIOS.md` para os próximos passos!
