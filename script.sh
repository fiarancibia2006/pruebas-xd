#!/bin/bash
if [ "$1" = "-d" ]; then
#pkill -f "consolidar.sh" 
echo "Eliminando entorno y finalizando procesos en background"
rm -rf "$HOME/EpNro1"
echo "Entorno eliminado con exito"
exit 0
fi
ejecutando=true

while $ejecutando; do
  echo "1) Crear entorno"
  echo "7)Salir"
  read -p  "Seleccioná una opcion: " opcion
  case $opcion in
  1) echo "Creando entorno..."
     mkdir -p "$HOME/EpNro1"/{entrada,salida,procesado}
     echo "El entorno se creo con exito"
     ;;
  7) echo "saliendo nos vemos pronto" 
     ejecutando=false
     ;;

  esac
done
