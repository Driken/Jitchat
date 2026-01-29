# Solução: "password authentication failed for user postgres"

## O que está acontecendo

O backend não consegue conectar ao PostgreSQL porque a **senha que o backend está usando é diferente da senha com que o banco foi inicializado**.

O PostgreSQL **só define a senha na primeira vez** que o volume é criado. Se você mudar `POSTGRES_PASSWORD` depois, o container não altera a senha do banco — ele continua usando a senha antiga.

---

## Solução 1: Usar a mesma senha em todo o projeto (recomendado)

No **EasyPanel**, defina **uma única** senha para o PostgreSQL e use ela nos dois lugares:

1. **Serviço `postgres`**  
   Variável: `POSTGRES_PASSWORD` = `SuaSenhaForteAqui`

2. **Serviço `backend`**  
   Variável: `POSTGRES_PASSWORD` = `SuaSenhaForteAqui` (a mesma)

O backend lê a conexão do banco em `izing/backend/src/config/database.ts` usando:

- `POSTGRES_HOST`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

Se no primeiro deploy você não definiu `POSTGRES_PASSWORD` no EasyPanel, o `docker-compose` usou o valor padrão: **`strongpassword`**.

Nesse caso, no EasyPanel você deve colocar:

- **Serviço postgres:** `POSTGRES_PASSWORD` = `strongpassword`
- **Serviço backend:** `POSTGRES_PASSWORD` = `strongpassword`

Depois salve, reinicie os serviços (ou faça Redeploy) e teste de novo.

---

## Solução 2: Volume já existe com outra senha — quer usar senha nova

Se o volume do PostgreSQL **já foi criado** com uma senha antiga e você **quer** usar uma senha nova:

1. **No EasyPanel**, pare o projeto.
2. **Remova o volume do PostgreSQL** (em Volumes, exclua o volume usado pelo serviço `postgres`).
3. Defina a **nova** senha:
   - Serviço `postgres`: `POSTGRES_PASSWORD` = `NovaSenhaForte`
   - Serviço `backend`: `POSTGRES_PASSWORD` = `NovaSenhaForte`
4. Faça **Deploy** de novo.

O PostgreSQL vai inicializar de novo e usar a nova senha. O backend passará a conectar com sucesso.

---

## Resumo

| Situação | O que fazer |
|----------|-------------|
| Primeiro deploy, ainda sem volume | Defina `POSTGRES_PASSWORD` igual no serviço **postgres** e no **backend**. |
| Já fez deploy antes e não mudou senha | Use `POSTGRES_PASSWORD` = `strongpassword` em **postgres** e **backend** (valor padrão do compose). |
| Quer trocar a senha e o volume já existe | Pare o projeto, **apague o volume do postgres**, defina a nova senha em **postgres** e **backend** e faça Deploy de novo. |

Sempre que alterar a senha do PostgreSQL, **postgres** e **backend** precisam usar **exatamente** o mesmo valor em `POSTGRES_PASSWORD`.
