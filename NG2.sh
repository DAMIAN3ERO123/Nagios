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

			apt-get update  1> /dev/null 
            echo "apt-get update realizado"
            read ""

			apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev 
            echo "apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev"
            read ""

			apt-get install -y openssl libssl-dev 
            echo "apt-get install -y openssl libssl-dev "
            read ""

			tar xzf nagioscore.tar.gz
            echo "tar xzf nagioscore.tar.gz"
            read ""

			cd '/tmp/nagioscore-nagios-$VERSION/'
            echo "cd '/tmp/nagioscore-nagios-$VERSION/'"
            read ""

			./configure --with-httpd-conf=/etc/apache2/sites-enabled
            echo "./configure --with-httpd-conf=/etc/apache2/sites-enabled"
            read ""

			make all
            echo "make all"
            read ""

			sudo make install-groups-users
            echo "sudo make install-groups-users"
            read ""

			sudo usermod -a -G nagios www-data
            echo "sudo usermod -a -G nagios www-data"
            read ""

			make install
            echo "make install"
            read ""

			make install-daemoninit
            echo "make install-daemoninit"
            read ""

			make install-commandmode
            echo "make install-commandmode"
            read ""

			make install-config
            echo "make install-config"
            read ""

			make install-webconf
            echo "make install-webconf"
            read ""

			sudo a2enmod rewrite
            echo "sudo a2enmod rewrite"
            read ""

			a2enmod cgi
            echo "a2enmod cgi"
            read ""

			sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
            echo "sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT"
            read ""

			apt-get install -y iptables-persistent
            echo "apt-get install -y iptables-persistent"
            read ""

            echo "escribe un contraseña para el usuario nagiosadmin"
			htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
            echo "htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin"
            read ""


			systemctl restart apache2.service
            echo "systemctl restart apache2.service"
            read ""

			systemctl start nagios.service
            echo "systemctl start nagios.service"
            read ""

			apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
            echo "apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext"
            read ""

			cd /tmp
            echo "cd /tmp"
            read ""

			wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
            echo "wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz"
            read ""

			tar zxf nagios-plugins.tar.gz
            echo "tar zxf nagios-plugins.tar.gz"
            read ""

			cd /tmp/nagios-plugins-release-2.3.3/
            echo "cd /tmp/nagios-plugins-release-2.3.3/"
            read ""

			./tools/setup
            echo "./tools/setup"
            read ""

			./configure
            echo "./configure"
            read ""

			make
            echo "make"
            read ""

			make install
            echo "make install"
            read ""

			systemctl enable nagios.service
            echo "systemctl enable nagios.service"
            read ""

			systemctl enable apache2.service
            echo "systemctl enable apache2.service"
            read ""

			cd
		else
			echo "La versión de Nagios no existe intenta con otra"
		
		fi
	done
fi
