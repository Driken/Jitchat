# Script PowerShell para gerar senhas seguras
# Execute: .\gerar-senhas.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Gerador de Senhas Seguras - Whaticket Plus" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Função para gerar senha segura
function Gerar-SenhaSegura {
    param([int]$Tamanho = 32)
    
    $caracteres = (48..57) + (65..90) + (97..122) + (33..47) + (58..64) + (91..96)
    $senha = -join ($caracteres | Get-Random -Count $Tamanho | ForEach-Object {[char]$_})
    return $senha
}

Write-Host "Gerando senhas seguras de 32 caracteres..." -ForegroundColor Yellow
Write-Host ""

# Gerar senhas
$dbPass = Gerar-SenhaSegura -Tamanho 32
$redisPass = Gerar-SenhaSegura -Tamanho 32
$jwtSecret = Gerar-SenhaSegura -Tamanho 64
$jwtRefreshSecret = Gerar-SenhaSegura -Tamanho 64

Write-Host "========================================" -ForegroundColor Green
Write-Host "SENHAS GERADAS:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "DB_PASS=" -NoNewline -ForegroundColor White
Write-Host $dbPass -ForegroundColor Yellow
Write-Host ""
Write-Host "REDIS_PASSWORD=" -NoNewline -ForegroundColor White
Write-Host $redisPass -ForegroundColor Yellow
Write-Host ""
Write-Host "JWT_SECRET=" -NoNewline -ForegroundColor White
Write-Host $jwtSecret -ForegroundColor Yellow
Write-Host ""
Write-Host "JWT_REFRESH_SECRET=" -NoNewline -ForegroundColor White
Write-Host $jwtRefreshSecret -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IMPORTANTE:" -ForegroundColor Red
Write-Host "- Copie essas senhas e guarde em local seguro" -ForegroundColor Yellow
Write-Host "- Use essas senhas nas variáveis de ambiente do EasyPanel" -ForegroundColor Yellow
Write-Host "- NÃO compartilhe essas senhas" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Perguntar se quer salvar em arquivo
$salvar = Read-Host "Deseja salvar essas senhas em um arquivo? (s/n)"
if ($salvar -eq "s" -or $salvar -eq "S") {
    $conteudo = @"
# Senhas geradas em $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# GUARDE ESTE ARQUIVO EM LOCAL SEGURO E NÃO COMMITE NO GIT!

DB_PASS=$dbPass
REDIS_PASSWORD=$redisPass
JWT_SECRET=$jwtSecret
JWT_REFRESH_SECRET=$jwtRefreshSecret
"@
    $arquivo = "senhas-geradas.txt"
    $conteudo | Out-File -FilePath $arquivo -Encoding UTF8
    Write-Host ""
    Write-Host "Senhas salvas em: $arquivo" -ForegroundColor Green
    Write-Host "IMPORTANTE: Adicione este arquivo ao .gitignore!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Pressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
