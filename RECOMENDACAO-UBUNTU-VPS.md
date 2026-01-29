# 🐧 Recomendação: Ubuntu para VPS - Whaticket Plus

## ✅ Recomendação Principal

### **Ubuntu 22.04 LTS (Jammy Jellyfish)** ⭐ RECOMENDADO

**Por quê?**
- ✅ Mais estável e amplamente testado em produção
- ✅ Suporte até 2027 (5 anos de suporte LTS)
- ✅ Docker Engine funciona perfeitamente
- ✅ Melhor compatibilidade com todas as ferramentas
- ✅ Menos problemas conhecidos
- ✅ Maior comunidade e documentação

### Ubuntu 24.04 LTS (Noble Numbat)

**Considerações:**
- ⚠️ Mais recente, mas menos tempo em produção
- ⚠️ Alguns problemas conhecidos com Docker Desktop (não afeta Docker Engine)
- ✅ Suporte até 2029 (5 anos de suporte LTS)
- ✅ Funciona bem com Docker Engine (que é o que você usa)
- ⚠️ Menos documentação e casos de uso em produção

## 🎯 Recomendação Final

### Para Produção: **Ubuntu 22.04 LTS**

**Motivos:**
1. **Estabilidade**: Mais tempo em produção = menos surpresas
2. **Docker**: Docker Engine funciona perfeitamente (você usa Docker Compose, não Desktop)
3. **Compatibilidade**: Todas as ferramentas (Node.js, PostgreSQL, Redis, Chrome) funcionam sem problemas
4. **Suporte**: Até 2027 é suficiente para migrar depois se necessário
5. **Documentação**: Mais tutoriais e soluções disponíveis

## 📋 Especificações Recomendadas da VPS

### Mínimo Recomendado:
- **CPU**: 4 cores
- **RAM**: 4GB (8GB recomendado)
- **Disco**: 40GB SSD
- **Sistema**: Ubuntu 22.04 LTS Server

### Ideal para Produção:
- **CPU**: 4-8 cores
- **RAM**: 8GB (16GB para muitos usuários)
- **Disco**: 80GB+ SSD
- **Sistema**: Ubuntu 22.04 LTS Server
- **Rede**: 1Gbps

## 🚀 Passos Após Instalar Ubuntu 22.04

### 1. Atualizar Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Docker e Docker Compose

```bash
# Instalar dependências
sudo apt install -y ca-certificates curl gnupg lsb-release

# Adicionar chave GPG do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Adicionar repositório Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Verificar instalação
docker --version
docker compose version
```

### 3. Configurar Firewall (UFW)

```bash
# Permitir SSH
sudo ufw allow 22/tcp

# Permitir portas do Docker (se necessário expor diretamente)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Habilitar firewall
sudo ufw enable
```

### 4. Configurar Swap (Opcional mas Recomendado)

```bash
# Criar arquivo de swap de 2GB
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Tornar permanente
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### 5. Otimizações do Sistema

```bash
# Aumentar limites do sistema para Docker
sudo tee -a /etc/sysctl.conf <<EOF
vm.max_map_count=262144
fs.file-max=2097152
EOF

sudo sysctl -p
```

## 📝 Checklist de Configuração da VPS

Após instalar Ubuntu 22.04:

- [ ] Sistema atualizado (`apt update && apt upgrade`)
- [ ] Docker instalado e funcionando
- [ ] Docker Compose instalado
- [ ] Usuário adicionado ao grupo docker
- [ ] Firewall configurado (UFW)
- [ ] Swap configurado (recomendado)
- [ ] SSH configurado com chave (recomendado)
- [ ] Fail2ban instalado (recomendado para segurança)
- [ ] Backup automático configurado

## 🔒 Segurança Adicional (Recomendado)

### Instalar Fail2ban

```bash
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Configurar SSH com Chave (Mais Seguro)

```bash
# No seu computador local, gerar chave SSH
ssh-keygen -t ed25519 -C "seu-email@exemplo.com"

# Copiar chave para VPS
ssh-copy-id usuario@ip-da-vps

# Desabilitar login por senha (após testar chave)
sudo nano /etc/ssh/sshd_config
# Alterar: PasswordAuthentication no
sudo systemctl restart sshd
```

## 🎯 Resumo

**Recomendação:** Ubuntu 22.04 LTS Server

**Por quê?**
- Mais estável para produção
- Docker funciona perfeitamente
- Melhor suporte e documentação
- Menos problemas conhecidos

**Quando considerar 24.04?**
- Se você quer recursos mais novos
- Se está disposto a lidar com possíveis problemas
- Se precisa de suporte até 2029

## 📚 Próximos Passos

Após configurar a VPS:

1. Clone seu repositório Git
2. Configure as variáveis de ambiente
3. Execute `docker compose up -d`
4. Configure os domínios
5. Execute as migrações do banco

Consulte `CHECKLIST-DEPLOY.md` para mais detalhes.
