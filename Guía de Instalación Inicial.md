Para realizar la instalación de Nagios asi como sus pre-requisitos necesitamos tener privilegios de administrador.

Si usas Debian coloca el siguiente comando

```
$su
```

Si usus Raspbian coloca el siguiente comando

```
$sudo -i

```

Es importante verificar que selinux este en modo permisivo o no este instalado


```
#getenforce

```

Si el comando anteriror indica que selinux esta en modo enforcing colocamos lo siguiente para ponerlo en modo permisivo momentaneamente, de lo contrario
no es necesario realiar nada

```
#setenforce 0
```

Actualizamos e instalamos los paquetes necesarios

```
#apt-get update
#apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev
#apt-get install -y openssl libssl-dev

```

Descargamos y desempaquetamos el archivo source en el directorio tmp

```
#cd /tmp
#wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
#tar xzf nagioscore.tar.gz

```

Compilamos nagios

```
#cd /tmp/nagioscore-nagios-4.4.6/
#./configure --with-httpd-conf=/etc/apache2/sites-enabled
#make all
```

Creación del usuario y grupo nagios, y adición del usuario www-data al grupo nagios

```
#sudo make install-groups-users
#sudo usermod -a -G nagios www-data
```

Instalar los binarios

```
make install
```

Instalar el demonio y caracteristicas necesarias para que funcione completamente nagios

```
#make install-daemoninit
#make install-commandmode
#make install-config
#make install-webconf
#sudo a2enmod rewrite
#sudo a2enmod cgi
```

Añadir una regla a iptables para aceptar el acceso por el puerto 80

```
#sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
#apt-get install -y iptables-persistent
```

Crear un usuario Apache para acceder a nagios e Ingresar contraseña

```
#htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```


Iniciar el servidor web 

```
#sudo systemctl restart apache2.service
```

Iniciar el demonio de nagios

```
#systemctl start nagios.service
```

Instalar prerrequisitos para añadir plugins y funcione correctamente nagios

```
#apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
```

Descargar y desempaquetar los plugins

```
#cd /tmp
#wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
#tar zxf nagios-plugins.tar.gz
```

Compilar e instalar los plugins

```
#cd /tmp/nagios-plugins-release-2.3.3/
#./tools/setup
#./configure
#make
#make install
```

Hemos terminado regresemos al inicio

```
#cd
```















