#!/bin/bash
# Creado por Andres Ruslan Abadias Otal

# Basado en la propia documentacion del creador: https://github.com/Theritex/LinuxGuide/blob/main/WebPage/Apache2/Documentation.md
# Creacion de modelo web con servicio Apache2
# Este premodelo esta creado para su uso y edicion

# Declaracion de variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
mipaginaes="/var/www/mipagina.es"
sitesavailable="/etc/apache2/sites-available"

sudo apt install apache2

# Creacion de pagina
sudo mkdir "$mipaginaes"

# Clonacion de index
sudo cp "$SCRIPT_DIR/local/index.html" "$mipaginaes/index.html"

# Preferencias
read -p "[#] Do you want to add styles? [y/n]: " stylestrue
if [[ $stylestrue == "y" ]]; then
    sudo cp -r "$SCRIPT_DIR/styles" "$mipaginaes/styles"
else
    echo "[#] Styles will not be added to the website."
fi

read -p "[#] Do you want to add scripts? [y/n]: " scriptstrue
if [[ $scriptstrue == "y" ]]; then
    sudo cp -r "$SCRIPT_DIR/scripts" "$mipaginaes/scripts"
else
    echo "[#] Scripts will not be added to the website."
fi

sudo systemctl restart apache2

read -p "[#] Do you want to add SSL Certificate? [y/n]: " sslcertificatetrue
if [[ $sslcertificatetrue == "y" ]]; then
    sudo apt install openssl
    sudo a2enmod ssl
    sudo systemctl restart apache2
    sudo cp "$SCRIPT_DIR/sitesavailable/ssl/mipagina.es.conf" "$sitesavailable/mipagina.es.conf"
    sudo a2ensite "mipagina.es"
    sudo cp -r "$SCRIPT_DIR/certificado" "/etc/apache2/sites-available/certificado"
    cd "/etc/apache2/sites-available/certificado"
    #~Certificado de 1 year
    sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificado.crt -keyout apache.key
    sudo service apache2 restart
else
    sudo systemctl restart apache2
    sudo cp "$SCRIPT_DIR/sitesavailable/default/mipagina.es.conf" "$sitesavailable/mipagina.es.conf"
    sudo a2ensite "mipagina.es"
fi

echo "[#] It's neccessary to follow this in /etc/hosts:"
echo "YourIP        mipagina.es        www.mipagina.es"
echo "Example:"
echo "40.0.0.2        mipagina.es        www.mipagina.es"

while [[ $readytrue != "y" ]]; do
    read -p "[#] Once ready type [y]: " readytrue
done

sudo nano "/etc/hosts"
sudo cp "$SCRIPT_DIR/local/ports.conf" "/etc/apache2/ports.conf"
sudo systemctl restart apache2

echo "[#] Service Fully installed"
if [[ $sslcertificatetrue == "y" ]]; then
    echo "[#] Look for 'https://mipagina.es' online."
else
    echo "[#] Look for http://mipagina.es' online."
fi