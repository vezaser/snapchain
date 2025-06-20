#!/bin/bash

# Snapchain node installer by Przyjacielu

set -e

echo "🚀 Snapchain Node Installer"

# --- 1. Sprawdź i zainstaluj wymagane pakiety ---
echo "🔍 Sprawdzanie wymaganych pakietów..."

if ! command -v docker &> /dev/null; then
  echo "📦 Instaluję Docker..."
  apt update && apt install -y ca-certificates curl gnupg lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  echo "✅ Docker już zainstalowany"
fi

# --- 2. Stwórz folder roboczy ---
echo "📁 Tworzenie folderu ~/snapchain-node"
mkdir -p ~/snapchain-node
cd ~/snapchain-node

# --- 3. Pobierz docker-compose.yml ---
echo "📥 Pobieranie docker-compose.yml z repozytorium Snapchain"
curl -L -o docker-compose.yml https://raw.githubusercontent.com/snapchain/snapchain/main/docker/docker-compose.yml

# --- 4. Uruchomienie kontenera ---
echo "🐳 Uruchamianie kontenera Snapchain"
docker compose up -d

echo "✅ Snapchain node uruchomiony. Sprawdź logi: docker compose logs -f"
