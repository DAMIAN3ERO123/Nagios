Podemos enviar alertas a nuestro correo electronico sobre el estatus de un host o sobre los servicios, para lo anterior requeriremos instalar
algunas herramientas para realizar esta tarea y que trabaje junto con nagios

1. Instalación de las herramientas
```
apt-get install mailutils
apt-get install sendmail
apt-get install sendmail*
```

2. Editamos el archivo /usr/local/nagios/etc/objects/contacts.cfg

![imagen 10](https://github.com/DAMIAN3ERO123/Nagios/blob/main/Imagenes/contacts.png)

3. Editamos el archivo /usr/local/nagios/etc/objects/commands.cfg
Localizamos el binario que utiliza por defecto nagios como cliente de correo y lo editamos para que sea mailx

![imagen 11](https://github.com/DAMIAN3ERO123/Nagios/blob/main/Imagenes/mailx.png)
