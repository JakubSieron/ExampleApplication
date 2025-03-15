#!/bin/bash

# Aktualizacja systemu i instalacja Node.js, npm oraz pm2
sudo apt update && sudo apt install -y nodejs npm
sudo npm install -g pm2

# Usunięcie starej wersji aplikacji
if [ -d "ExampleApplication" ]; then
  rm -rf ExampleApplication
fi

# Klonowanie repozytorium
git clone https://github.com/JakubSieron/ExampleApplication.git || exit 1
cd ExampleApplication || exit 1

# Instalacja zależności Node.js
npm install || exit 1
npm install http-errors || exit 1  # Upewnienie się, że 'http-errors' jest obecny

# Nadanie uprawnień do uruchamiania aplikacji
chmod +x ./bin/www || true

# Tworzenie katalogu na certyfikaty SSL
mkdir -p ssl

# Generowanie certyfikatów SSL, jeśli ich brakuje
if [ ! -f "ssl/privatekey.pem" ] || [ ! -f "ssl/server.crt" ]; then
  echo "Generowanie certyfikatu SSL..."
  openssl req -x509 -newkey rsa:4096 -keyout ssl/privatekey.pem -out ssl/server.crt -days 10000 -nodes -subj "/C=IE/ST=Leinster/L=Dublin/O=National College of Ireland/OU=School of Computing/CN=ncirl.ie"
fi

# Otwieranie portu 8443 dla HTTPS
sudo ufw allow 8443/tcp

# Sprawdzenie, czy aplikacja już działa w PM2
pm2 list | grep -q example_app
if [ $? -eq 0 ]; then
  pm2 stop example_app
  pm2 delete example_app
fi

# Uruchomienie aplikacji w PM2
pm2 start ./bin/www --name example_app -f || exit 1
pm2 save || true
pm2 startup || true

exit 0
