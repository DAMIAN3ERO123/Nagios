#!/bin/bash

>listaAlcanzables.txt

echo "Ingresa la red que quieres escanear con su mascara"
echo "Ejemplo 192.168.100.0/24"

read red

#if test `echo $red | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'`

mascara=`echo $red | cut -f 2 -d '/'`
mascara=`expr 32 - $mascara`

ips=`echo $((2**mascara))`
ips=`expr $ips - 2`
#echo $ips

ini_red=`echo $red | cut -f 4 -d '.' | cut -f 1 -d '/'`
ini_red=`expr $ini_red + 1`
#echo $ini_red

for (( i=$ini_red ; i<=$ips ; i++ ))
do 
    ip=`echo $red | cut -f 1,2,3 -d '.'`
    ip=`echo $ip.$i`
    #echo $ip
    validando=`ping -c 4 $ip`
    resultado=`echo $validando | cut -d ',' -f 2 | cut -d ' ' -f 2`
    #echo $resultado
    if test $resultado -ne 0
    then 
        echo $ip >> listaAlcanzables.txt
    fi
done  

echo ""
echo "Lista de IPs Alcanzables"

cat listaAlcanzables.txt
echo ""

opcion=0
while test `echo $opcion -ne 3`
do
    echo "Ingresa 1 para agregar la/las IPs al monitoreo de hosts"
    echo "Ingresa 2 para revisar que servicios tienen activos en las IPs alcanzables"
    echo "Ingresa 3 para salir"

    read opcion

    if test $opcion -eq 1
    then 
        
        ip_opcion=0
        while test `echo $ip_opcion -ne 3` 2> /dev/null
        do
            clear
            echo "Ingresa 1 para agregar todas las IPs encontradas al monitoreo"
            echo "Ingresa 2 para agregar una sola IP"
            echo "Ingresa 3 para volver al menu anterior"
            read ip_opcion
        
            if test $ip_opcion -eq 1 2> /dev/null
            then
                echo "Estoy agregando las IPs al Monitoreo..."
            elif test $ip_opcion -eq 2 2> /dev/null
            then
                echo "Escrbe el numero de IP a Monitorear"
                read ip2
                if test `echo $ip2 | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'`
                then   
                    grep $ip2 /usr/local/nagios/etc/objects/hosts/hosts.cfg &> /dev/null                
                    if [ `echo $?` -eq 0 ]
                    then
                        clear
                        echo -e "La IP \"$ip2\" que quieres agregar ya se encuentra en el Monitoreo \npor favor revisa el archivo de configuración"
                        read
                    else
                        clear
                        echo "Voy a agregar la IP \"$ip2\" al Monitoreo.."
                        read
                    fi
                else 
                    clear
                    echo "El numero de IP es invalido"
                    read
                fi
            elif test $ip_opcion -eq 3
            then 
                echo "Regrensando al menu anterior"
                sleep 3
                clear
            else
                echo "La opcion o IP es Invalida, intentalo de nuevo"
            fi
        done
    fi
done


rm listaAlcanzables.txt
