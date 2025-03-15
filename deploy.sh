sudo apt update && sudo apt install nodejs npm
sudo npm install -g pm2
pm2 stop example _app
cd ExampleApplication/
npm install
pm2 start ./bin/www --name example_app
