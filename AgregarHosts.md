Para agregar un host a nuestro monitoreo debemos crear el archivo que contenga los paramentros necesarios que identifiquen al host, de bajo 
del siguiente directorio "/usr/local/nagios/etc/objects" podemos agregar nuestra carpeta y archivo con terminación .cfg

Usa el siguiente comando para crear el directorio y el archivo en la misma linea 

```
#mkdir /usr/local/nagios/etc/objects/hosts && > /usr/local/nagios/etc/objects/hosts/hosts.cfg
```

Ahora haz que el directorio hosts y su contenido pertenezcan al usuario nagios y grupo nagios

```
#chown -R nagios:nagios /usr/local/nagios/etc/objects/hosts
```

Dentro del archivo hosts.cfg hay que agregar la siguiente plantilla, para añadir paramentros adicionales asi como información
más detallada puedes ver el link del final.

```
define host {
    host_name               <nombre del equipo a monitorear>
    alias                   <alias>
    address                 <dirección ip>
    check_command           check-host-alive
    check_interval          5
    retry_interval          1
    max_check_attempts      5
    check_period            24x7
}
```

Ahora editaremos el archivo de configuración de nagios para indicarle que revise el archivo hosts.cfg y así nos muestre su monitoreo

```
vi /usr/local/nagios/etc/nagios.cfg
```

Agrega la siguiente linea como se muestra en la imagen
![imagen 8]()

https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/objectdefinitions.html


