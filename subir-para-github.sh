#!/usr/bin/env bash
# Subir o portfolio para o GitHub (repo: Leloo0/portfolio1)
# Envia TODOS os arquivos e pastas desta pasta, substituindo o conteudo antigo.
# Uso:  bash subir-para-github.sh

set -u
cd "$(cd "$(dirname "$0")" && pwd)"

echo "============================================================"
echo "  SUBIR O PORTFOLIO PARA O GITHUB (repo: Leloo0/portfolio1)"
echo "============================================================"
echo

if ! command -v git >/dev/null 2>&1; then
  echo "[ERRO] Git nao encontrado."
  echo "macOS:  xcode-select --install   (ou brew install git)"
  echo "Linux:  sudo apt install git"
  exit 1
fi

git config user.name >/dev/null 2>&1 || git config user.name "Leonardo Boury"
git config user.email >/dev/null 2>&1 || git config user.email "artmaker770@gmail.com"

echo "[1/5] Preparando o repositorio local..."
git init -b main || exit 1

echo "[2/5] Adicionando todos os arquivos e pastas..."
git add . || exit 1

echo "[3/5] Criando o commit..."
git commit -m "Portfolio Leonardo Boury - pacote completo para deploy na Vercel" || exit 1

echo "[4/5] Conectando ao repositorio Leloo0/portfolio1..."
git remote remove origin >/dev/null 2>&1
git remote add origin https://github.com/Leloo0/portfolio1.git || exit 1

echo "[5/5] Enviando para o GitHub (substituindo o conteudo antigo)..."
echo ">> Se pedir login, entre com sua conta GitHub na janela do navegador."
echo
git push --force -u origin main || {
  echo
  echo "[ERRO] O push falhou. Se pediu senha, use um Personal Access Token:"
  echo "       https://github.com/settings/tokens"
  exit 1
}

echo
echo "============================================================"
echo "  PRONTO! Repositorio atualizado com TUDO."
echo "  A Vercel vai detectar o push e publicar o site sozinha."
echo "  Acompanhe em: https://vercel.com/dashboard"
echo "============================================================"
