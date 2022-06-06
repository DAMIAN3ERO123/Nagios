#!/bin/bash

>listaAlcanzables.txt

echo "Ingresa la red que quieres escanear con su mascara de la 24-30"
echo "Ejemplo 192.168.100.0/24"

read red

mascara=`echo $red | cut -f 2 -d '/'`
mascara=`expr 32 - $mascara`

ips=`echo $((2**mascara))`
ips=`expr $ips - 2`


for (( i=1 ; i<=$ips ; i++ ))
do 
    ip=`echo $red | cut -f 1,2,3 -d '.'`
    ip=`echo $ip.$i`
   
    validando=`ping -c 4 $ip`
    resultado=`echo $validando | cut -d ',' -f 2 | cut -d ' ' -f 2`
    
    if test $resultado -ne 0
    then 
        echo $ip >> listaAlcanzables.txt
    fi
done  

echo "Lista de IPs Alcanzables"
cat listaAlcanzables.txt
