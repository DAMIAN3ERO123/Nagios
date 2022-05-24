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
		echo $VERSION
		wget -O nagioscore.tar.gz 'https://github.com/NagiosEnterprises/nagioscore/archive/nagios-$VERSION.tar.gz' 2> /dev/null

		if [ `echo $?` -eq 8 ] 2> /dev/null
		then 

			BANDERA=1

			apt-get update   
			apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev 
			apt-get install -y openssl libssl-dev 

			tar xzf nagioscore.tar.gz

			cd '/tmp/nagioscore-nagios-$VERSION/'
			./configure --with-httpd-conf=/etc/apache2/sites-enabled
			make all

			sudo make install-groups-users
			sudo usermod -a -G nagios www-data

			make install
			make install-daemoninit
			make install-commandmode
			make install-config
			make install-webconf
			sudo a2enmod rewrite
			a2enmod cgi

			sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
			apt-get install -y iptables-persistent

			htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
			echo hola123.,
			echo hola123.,

			systemctl restart apache2.service
			systemctl start nagios.service

			apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext


			cd /tmp
			wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
			tar zxf nagios-plugins.tar.gz

			cd /tmp/nagios-plugins-release-2.3.3/
			./tools/setup
			./configure
			make
			make install

			systemctl enable nagios.service
			systemctl enable apache2.service

			cd
		else
			echo "La versión de Nagios no existe intenta con otra"
		
		fi
	done
fi





