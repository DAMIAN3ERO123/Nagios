#!/bin/bash

>listaAlcanzables.txt

echo "Ingresa la red que quieres escanear con su mascara"
echo "Ejemplo 192.168.100.0/24"

read red

#if test `echo $red | grep ^[0-255].[0-255].[0-255].[0-255][/][1-30]?`

mascara=`echo $red | cut -f 2 -d '/'`
mascara=`expr 32 - $mascara`

ips=`echo $((2**mascara))`
ips=`expr $ips - 2`
#echo $ips

ini_red=`echo $red | cut -f 4 -d '.' | cut -f 1 -d '/'`
ini_red=`expr $ini_red + 1`
#echo $ini_red
date
for (( i=$ini_red ; i<=$ips ; i++ ))
do 
    ip=`echo $red | cut -f 1,2,3 -d '.'`
    ip=`echo $ip.$i`
    #cho $ip
    if test `ping -c 1 $ip | grep received | cut -d ',' -f 2 | cut -d ' ' -f 2` -ne 0
    then 
        echo $ip >> listaAlcanzables.txt
    fi
done  

echo "Lista de IPs Alcanzables"
cat listaAlcanzables.txt

rm listaAlcanzables.txt

