#!/bin/bash
# Script para inicializar o banco de dados
# Execute este script após o primeiro deploy

echo "Aguardando PostgreSQL estar pronto..."
sleep 10

echo "Executando migrações..."
cd /app
npx sequelize db:migrate

echo "Executando seeds..."
npx sequelize db:seed:all

echo "Banco de dados inicializado com sucesso!"
