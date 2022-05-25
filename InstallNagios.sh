#!/bin/bash

BANDERA=0

cat /etc/sudoers &> /dev/null
if [ `echo $?` -ne 0 ] 2> /dev/null
then
	echo "Necesitas tener privilegios de administrador para correr este script intentalo nuevamente"

else

	sestatus 2> /dev/null

	if [ `echo $?` -eq 0 ] 2> /dev/null
	then
	setenforce 0 2> /dev/null

	fi

	cd /tmp

	while [ `echo $BANDERA` -eq 0 ]
	do 

		echo "¿Que versión de Nagios deseas instalar?"
		read VERSION
		

		wget -O nagioscore.tar.gz "https://github.com/NagiosEnterprises/nagioscore/archive/nagios-$VERSION.tar.gz" 2> /dev/null

		if [ `echo $?` -eq 0 ] 2> /dev/null
		then 

			clear

			echo "Gracias ya me encuentro instalando Nagios"

			BANDERA=1

			apt-get update  &> /dev/null 

			apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev &> /dev/null

			apt-get install -y openssl libssl-dev &> /dev/null

			tar xzf nagioscore.tar.gz &> /dev/null

			cd "/tmp/nagioscore-nagios-$VERSION/" 

			./configure --with-httpd-conf=/etc/apache2/sites-enabled &> /dev/null

			make all &> /dev/null

			sudo make install-groups-users &> /dev/null

			sudo usermod -a -G nagios www-data &> /dev/null

			make install &> /dev/null

			make install-daemoninit &> /dev/null

			make install-commandmode &> /dev/null

			make install-config &> /dev/null

			make install-webconf &> /dev/null

			sudo a2enmod rewrite &> /dev/null

			a2enmod cgi &> /dev/null

			sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT &> /dev/null

			apt-get install -y iptables-persistent

			clear

           		echo "escribe un contraseña para el usuario nagiosadmin"

			htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

			clear

			echo "Sigo Instalando, ya casí termino"

			systemctl restart apache2.service &> /dev/null
 
			systemctl start nagios.service &> /dev/null

			apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext &> /dev/null

			cd /tmp 

			wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz &> /dev/null

			tar zxf nagios-plugins.tar.gz &> /dev/null

			cd /tmp/nagios-plugins-release-2.3.3/ &> /dev/null

			./tools/setup &> /dev/null

			./configure &> /dev/null

			make &> /dev/null

			make install &> /dev/null

			systemctl enable nagios.service &> /dev/null

			systemctl enable apache2.service &> /dev/null

			cd

			clear

			echo "Felicidades ya esta instalado Nagios Ingresa a tu navegador web e ingresa por ejemplo: http://127.0.0.1/nagios"
			echo ""
			echo "Escribe el usuario \"nagiosadmin\" e ingresa la contraseña que creaste"

		else
			echo "La versión de Nagios no existe intenta con otra"
		
		fi
	done
fi



