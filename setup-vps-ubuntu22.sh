#!/bin/bash
# Script de configuração inicial para Ubuntu 22.04 LTS
# Execute: bash setup-vps-ubuntu22.sh

set -e

echo "=========================================="
echo "Configuração VPS Ubuntu 22.04 - Whaticket Plus"
echo "=========================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se é root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}Por favor, não execute como root. Use um usuário com sudo.${NC}"
   exit 1
fi

echo -e "${YELLOW}1. Atualizando sistema...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${YELLOW}2. Instalando dependências básicas...${NC}"
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    unzip \
    wget \
    htop \
    nano \
    ufw

echo -e "${YELLOW}3. Instalando Docker...${NC}"
# Remover versões antigas
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

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

echo -e "${GREEN}Docker instalado com sucesso!${NC}"
echo -e "${YELLOW}IMPORTANTE: Faça logout e login novamente para o grupo docker ter efeito.${NC}"

echo -e "${YELLOW}4. Configurando Firewall (UFW)...${NC}"
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
echo -e "${GREEN}Firewall configurado!${NC}"

echo -e "${YELLOW}5. Configurando Swap (2GB)...${NC}"
if [ ! -f /swapfile ]; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo -e "${GREEN}Swap configurado!${NC}"
else
    echo -e "${YELLOW}Swap já existe, pulando...${NC}"
fi

echo -e "${YELLOW}6. Otimizando sistema para Docker...${NC}"
sudo tee -a /etc/sysctl.conf <<EOF

# Otimizações Docker
vm.max_map_count=262144
fs.file-max=2097152
net.core.somaxconn=65535
EOF

sudo sysctl -p

echo -e "${YELLOW}7. Instalando Fail2ban (segurança)...${NC}"
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo ""
echo "=========================================="
echo -e "${GREEN}Configuração concluída!${NC}"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "1. Faça logout e login novamente (para grupo docker)"
echo "2. Verifique Docker: docker --version"
echo "3. Verifique Docker Compose: docker compose version"
echo "4. Clone seu repositório Git"
echo "5. Configure as variáveis de ambiente"
echo "6. Execute: docker compose up -d"
echo ""
echo -e "${YELLOW}IMPORTANTE: Faça logout e login para o grupo docker ter efeito!${NC}"
echo ""
