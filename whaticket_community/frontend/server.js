//simple express server to run frontend production build;
const express = require("express");
const path = require("path");
const app = express();

const buildPath = path.join(__dirname, "build");

// Servir arquivos estáticos
app.use(express.static(buildPath));

// Fallback para SPA - qualquer rota não encontrada retorna index.html
app.use(function (req, res) {
	res.sendFile(path.join(buildPath, "index.html"));
});

const port = process.env.PORT || 3333;
app.listen(port, () => {
	console.log(`Frontend rodando na porta ${port}`);
});
