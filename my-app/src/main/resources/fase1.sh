#! /usr/bin/env bash
start=$(date +%s)   
#inicializar script llamando el bash
if [[ -z $(ls /bin/7z) ]]; then
#condicional para saber sí en el sistema se encuentra instalado 7zip para descomprimir
	echo "Para ejecutar este script es necesario instalar 7zip"
	exit
fi   

if [[ -z "$1" ]]; then
#condicional que comprueba que no este el archivo vacio si lo esta pide la url si no lo esta lo pasa directo al parametro
	read -p 'Introduce la url del archivo (EJ.  http://xxx.xxx/xxx):' url_file
else
	url_file=$1

fi

file=$(echo $url_file | rev |cut -d/ -f 1 | rev)

#escribe el url como nombre del file diciendo que corte hasta el ultimo delimitador /     

curl $url_file -o $file 
#renombra el archivo como parametro file  y lo descarga
if [[ -z $(file $file | grep ASCII) ]]; then
	7z e $file
#condicional que verifica sí esta vacio y con el comando file al archivo verifica que tenga la propiedad de ASCII
#si no lo tiene descomprime
fi
#condicional verifica que no tenga salto de carro de windows, si cuenta las lineas e imprime 0 significa que tiene salto de 
#windows entonces con sed reemplaza y lo guarda
if [[ $(wc -l $file)=='0'$file ]]; then 
	cat $file | sed 's/\r/\n/g' >  LF-$file
	file=LF-$file
fi

echo '# de lineas del archivo'
wc -l $file
sleep 2
echo '\n10 primeras lineas del archivo'
head -10 $file
sleep 2
echo '\n10 ultimas lineas del archivo'
tail -10 $file
sleep 2
echo '\nMatch Multi-Family'
grep Multi-Family $file
echo '\n# de Multi-Family'
grep Multi-Family $file | wc -l
 
time=$(date +%s)
echo "Tiempo de ejecución:$((time-start))segundos."
