sudo apt update && sudo apt install -y curl
curl -s https://raw.githubusercontent.com/vezaser/snapchain/main/install_snapchain.sh | bash



#!/bin/bash

# Ustaw ścieżkę do katalogu na zewnętrznym dysku
SNAPCHAIN_DATA_DIR="/mnt/snapchain_data"

# 1. Utwórz katalog na zewnętrznym dysku, jeśli nie istnieje
sudo mkdir -p "$SNAPCHAIN_DATA_DIR"
sudo chown $(id -u):$(id -g) "$SNAPCHAIN_DATA_DIR"

# 2. Pobierz oficjalny plik docker-compose dla mainnetu
curl -L https://raw.githubusercontent.com/farcasterxyz/snapchain/refs/heads/main/docker-compose.mainnet.yml -o docker-compose.yml

# 3. Zmień sekcję volumes w pliku docker-compose.yml na bind mount do zewnętrznego dysku
# (Zamień domyślny wolumen na bind mount do $SNAPCHAIN_DATA_DIR)
sed -i '/volumes:/a\      - '"$SNAPCHAIN_DATA_DIR"':/data' docker-compose.yml
sed -i '/      - snapchain_data:\/data/d' docker-compose.yml

# 4. Usuń sekcję "volumes:" na dole pliku (jeśli istnieje)
sed -i '/^volumes:/,$d' docker-compose.yml

# 5. Uruchom Snapchaina w tle
docker compose up -d

echo "Snapchain uruchomiony. Dane będą przechowywane na zewnętrznym dysku: $SNAPCHAIN_DATA_DIR"
echo "Sprawdź synchronizację poleceniem: docker logs -f snapchain-snap_read-1"
