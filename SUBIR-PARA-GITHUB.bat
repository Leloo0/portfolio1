@echo off
chcp 65001 >nul
title Subir portfolio para o GitHub

echo ============================================================
echo   SUBIR O PORTFOLIO PARA O GITHUB (repo: Leloo0/portfolio1)
echo ============================================================
echo.
echo Este script envia TODOS os arquivos e pastas desta pasta para
echo o seu repositorio portfolio1, SUBSTITUINDO o conteudo antigo.
echo Depois o push, a Vercel faz o deploy automaticamente.
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Git nao encontrado neste computador.
    echo.
    echo Instale o Git em: https://git-scm.com/download/win
    echo Depois instale, feche e reabra esta janela e rode de novo.
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

git config user.name >nul 2>nul || git config user.name "Leonardo Boury"
git config user.email >nul 2>nul || git config user.email "artmaker770@gmail.com"

echo [1/5] Preparando o repositorio local...
git init -b main
if errorlevel 1 goto :falha

echo [2/5] Adicionando todos os arquivos e pastas...
git add .
if errorlevel 1 goto :falha

echo [3/5] Criando o commit...
git commit -m "Portfolio Leonardo Boury - pacote completo para deploy na Vercel"
if errorlevel 1 goto :falha

echo [4/5] Conectando ao repositorio Leloo0/portfolio1...
git remote remove origin >nul 2>nul
git remote add origin https://github.com/Leloo0/portfolio1.git
if errorlevel 1 goto :falha

echo [5/5] Enviando para o GitHub (substituindo o conteudo antigo)...
echo.
echo >> Se uma janela do navegador pedir login, entre com sua conta GitHub.
echo >> Se pedir senha, use um Personal Access Token (nao e a senha normal).
echo.
git push --force -u origin main
if errorlevel 1 goto :falha

echo.
echo ============================================================
echo   PRONTO! Repositorio atualizado com TUDO.
echo   A Vercel vai detectar o push e publicar o site sozinha.
echo   Acompanhe em: https://vercel.com/dashboard
echo ============================================================
echo.
pause
exit /b 0

:falha
echo.
echo [ERRO] Algum passo falhou. Leia a mensagem acima.
echo Dicas: confira seu login/internet. Se pediu senha, use um
echo Personal Access Token: github.com/settings/tokens
echo.
pause
exit /b 1
