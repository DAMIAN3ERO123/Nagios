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

			BANDERA=1

			apt-get update  1> /dev/null 

			apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev 1> /dev/null

			apt-get install -y openssl libssl-dev 1> /dev/null

			tar xzf nagioscore.tar.gz 1> /dev/null

			cd "/tmp/nagioscore-nagios-$VERSION/" 

			./configure --with-httpd-conf=/etc/apache2/sites-enabled 1> /dev/null

			make all 1> /dev/null

			sudo make install-groups-users 1> /dev/null

			sudo usermod -a -G nagios www-data 1> /dev/null

			make install 1> /dev/null

			make install-daemoninit 1> /dev/null

			make install-commandmode 1> /dev/null

			make install-config 1> /dev/null

			make install-webconf 1> /dev/null

			sudo a2enmod rewrite 1> /dev/null

			a2enmod cgi 1> /dev/null

			sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT 1> /dev/null

			apt-get install -y iptables-persistent

            echo "escribe un contraseña para el usuario nagiosadmin"
			htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin


			systemctl restart apache2.service 1> /dev/null
 
			systemctl start nagios.service 1> /dev/null

			apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext 1> /dev/null

			cd /tmp 

			wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz 1> /dev/null

			tar zxf nagios-plugins.tar.gz 1> /dev/null

			cd /tmp/nagios-plugins-release-2.3.3/ 1> /dev/null

			./tools/setup 1> /dev/null

			./configure 1> /dev/null

			make 1> /dev/null

			make install 1> /dev/null

			systemctl enable nagios.service 1> /dev/null

			systemctl enable apache2.service 1> /dev/null

			cd

			echo "Felicidades ya esta instalado Nagios Ingresa a tu navegador web e ingresa por ejemplo: http://127.0.0.1/Nagios"

		else
			echo "La versión de Nagios no existe intenta con otra"
		
		fi
	done
fi
