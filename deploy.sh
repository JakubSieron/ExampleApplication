#!/bin/bash
sudo apt update && sudo apt install -y nodejs npm
sudo npm install -g pm2
if [ -d "ExampleApplication" ]; then
  rm -rf ExampleApplication
fi

git clone https://github.com/JakubSieron/ExampleApplication.git || exit 1
cd ExampleApplication || exit 1

npm install || exit 1
chmod +x ./bin/www || true

pm2 list | grep -q example_app
if [ $? -eq 0 ]; then
  pm2 stop example_app
  pm2 delete example_app
fi

pm2 start ./bin/www --name example_app -f || exit 1
pm2 save || true
pm2 startup || true

exit 0 