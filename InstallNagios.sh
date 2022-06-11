#!/bin/bash

BANDERA=0

cat /etc/sudoers &> /dev/null
if [ `echo $?` -ne 0 ] 2> /dev/null
then
	echo "Necesitas tener privilegios de administrador para correr este script intentalo nuevamente"

else
	wget --version &> /dev/null
	if [ `echo $?` -ne 0 ] 2> /dev/null
	then
		apt-get install wget
	fi

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

			apt-get update  &> /dev/null 
			clear
			echo "Cargando ... 3%"

			apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev &> /dev/null
			clear
			echo "Cargando ... 6%"

			apt-get install -y openssl libssl-dev &> /dev/null
			clear
			echo "Cargando ... 9%"

			tar xzf nagioscore.tar.gz &> /dev/null
			clear
			echo "Cargando ... 12%"

			cd "/tmp/nagioscore-nagios-$VERSION/" 
			clear
			echo "Cargando ... 15%"

			./configure --with-httpd-conf=/etc/apache2/sites-enabled &> /dev/null
			clear
			echo "Cargando ... 18%"

			make all &> /dev/null
			clear
			echo "Cargando ... 21%"


			sudo make install-groups-users &> /dev/null
			clear
			echo "Cargando ... 24%"


			sudo usermod -a -G nagios www-data &> /dev/null
			clear
			echo "Cargando ... 27%"


			make install &> /dev/null
			clear
			echo "Cargando ... 30%"


			make install-daemoninit &> /dev/null
			clear
			echo "Cargando ... 33%"

			make install-commandmode &> /dev/null
			clear
			echo "Cargando ... 36%"


			make install-config &> /dev/null
			clear
			echo "Cargando ... 39%"


			make install-webconf &> /dev/null
			clear
			echo "Cargando ... 44%"


			sudo a2enmod rewrite &> /dev/null
			clear
			echo "Cargando ... 47%"


			sudo a2enmod cgi &> /dev/null
			clear
			echo "Cargando ... 50%"


			sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT &> /dev/null
			clear
			echo "Cargando ... 53%"


			apt-get install -y iptables-persistent
			clear
			echo "Cargando ... 56%"


			clear

           	echo "escribe un contraseña para el usuario nagiosadmin"

			htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
			clear
			echo "Cargando ... 59%"

			systemctl restart apache2.service &> /dev/null
			# el siguiente comando aplica solo si usamos init
			service apache2 restart &> /dev/null
			clear
			echo "Cargando ... 62%"

 
			systemctl start nagios.service &> /dev/null
			# el siguiente comando aplica solo si usamos init
			service nagios restart &> /dev/null
			clear
			echo "Cargando ... 65%"


			apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext &> /dev/null
			clear
			echo "Cargando ... 69%"


			cd /tmp 
			clear
			echo "Cargando ... 72%"


			wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz &> /dev/null
			clear
			echo "Cargando ... 75%"


			tar zxf nagios-plugins.tar.gz &> /dev/null
			clear
			echo "Cargando ... 78%"

			cd /tmp/nagios-plugins-release-2.3.3/ &> /dev/null
			clear
			echo "Cargando ... 81%"


			./tools/setup &> /dev/null
			clear
			echo "Cargando ... 83%"


			./configure &> /dev/null
			clear
			echo "Cargando ... 86%"


			make &> /dev/null
			clear
			echo "Cargando ... 90%"


			make install &> /dev/null
			clear
			echo "Cargando ... 93%"


			systemctl enable nagios.service &> /dev/null
			clear
			echo "Cargando ... 96%"


			systemctl enable apache2.service &> /dev/null
			clear
			echo "Cargando ... 99%"


			cd

			clear
			echo "Cargando ... 100% Finalizado"
			echo ""
			echo "Felicidades ya esta instalado Nagios Ingresa a tu navegador web e ingresa por ejemplo: http://127.0.0.1/nagios"
			echo ""
			echo "Escribe el usuario \"nagiosadmin\" e ingresa la contraseña que creaste"

		else
			echo "La versión de Nagios no existe intenta con otra"
		
		fi
	done
fi
