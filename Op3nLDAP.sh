#!/bin/bash
#autor: Mihail Gabriel Nastase
#Nota: La llamada al script, tiene dos parámetros y son: ProyectoFase1.sh Directorio_Base Fichero_LDIF
# ---------------------------------------------------------------------------------------------------------------------
#  --------------------------------------------- DECLRACIÓN DE VARIABLES ---------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
EstructuraLdif=bbdd.ldif
DataGD=/data/GestorDocumental
#mgnastase-esta es una variable, que al estár fuera de cualquier funcción, es una variable global, que nos permite poder llamarla desde cualquier funcción, estémos donde estémos.
# ---------------------------------------------------------------------------------------------------------------------
#  ------------------------------------------- DECLRACIÓN DE LAS FUNCIONES -------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
fntOpenLDAP() {
wget 
}
# ---------------------------------------------------------------------------------------------------------------------
#  ---------------------------------------------------- SUB-MENÚS ----------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------

fntSubMenuCrearEstructura() {
while [ opcion != "" ]
do
	clear
	echo "                                                       " 
	echo "                     CREAR ESTRUCTURA                  "
	echo "   ----------------------------------------------------"
	echo "                                                       "
  	echo "      [pulse 1] CREAR UNIDADES ORGANIZATIVAS           "
	echo "                                                       "
  	echo "      [pulse 2] CREAR GRUPOS                           "
	echo "                                                       "
  	echo "      [pulse 3] CREAR USUARIOS                         "
	echo "                                                       "
  	echo "      [pulse 4] CREAR EQUIPOS                          "
	echo "                                                       "
	echo "   ----------------------------------------------------"
  	echo "    Escribe esto si quieres:     ayuda | menu | salir  "
	echo "   ----------------------------------------------------"

	read -p "   Por favor, pulse una opción:" opcion
	    #Comprueba si el valor recogido en opcion es 1,2 o 3, si es otra cosa, se ejecuta *)
    	case $opcion in
    	1) 
       		#Llamar a la funcion crear usuarios o llamar a un script que cree usuarios
          #ejemplo: si queremos llamar a la funcion crear usuarios pondríamos
				clear		      
			fntUosCsv2ldif
		read -p "Presione la tecla [Enter] para continuar..."
       		;;
    	2) 
				clear		      
        	fntGruposCsv2ldif
		read -p "Presione la tecla [Enter] para continuar..."
        	;;
    	3) 
				clear		      
        	fntUsuariosCsv2ldif
		      #el comando exit hace que el script finalize con código de error 1
		read -p "Presione la tecla [Enter] para continuar..."
        	;;
      4) 
				clear		      
          fntEquiposCsv2ldif
          #el comando exit hace que el script finalize con código de error 1
    read -p "Presione la tecla [Enter] para continuar..."
          ;;
    	ayuda) 
				clear		      
        	fntAyuda
        	;;
    	menu) 
				clear		      
        	return
        	;;
    	salir) 
				clear		      
        	echo "Saliendo..."
		      #el comando exit hace que el script finalize con código de error 1
        	exit
        	;;
    	OpenLDAP) 
				clear		      
          fntOpenLDAP
        	;;
    	*) 
		echo "Error: Please try again (select 1..4)!"
        	read -p "Presione la tecla [Enter] para continuar..."
		;;
   	esac
done
}

#-------------------------
fntAyuda() { 
while [ opcion != "" ]
do
  clear
  echo "                                                       "
  echo "                         AYUDA                         "
  echo "   ----------------------------------------------------"
  echo "     Ponga atención a lo que se le muestra por pantalla"
  echo "   pues en todo momento está siendo guiado, para evitar"
  echo "   tener problemas con el programa.                    "
  echo "                                                       "
  echo "     De todas formas, en caso de algún error siempre se"
  echo "   podrá poner en contacto con nosotros a través del   "
  echo "   correo electrónico que encuentra a continuación:    "
  echo "                                                       "
  echo "                    nastasemg@gmail.com                "
  echo "                                                       "
  echo "     En todo el programa dispone de varias opciones que"
  echo "   puede utilizar para navegar por dicha aplicación.   "
  echo "                                                       "
  echo "     Como lo es por ejemplo la parte de abajo de esta  "
  echo "   ventana donde se nos indican una serie de palabras, "
  echo "   que en este caso son 'volver' y 'salir', estas dos  "
  echo "   opciones realizarían la acción que cada una indica  "
  echo "   ya sea 'volver' a la anterior ventana o bien 'salir'"
  echo "   del programa.                                       "
  echo "                                                       " 
  echo "   ----------------------------------------------------"
  echo "    Escribe esto si quieres:           volver | salir  "
  echo "   ----------------------------------------------------"

  read -p "   Por favor, pulse una opción:" opcion
      #Comprueba si el valor recogido en opcion es 1,2 o 3, si es otra cosa, se ejecuta *)
      case $opcion in
      volver) 
           return
          ;;
      salir) 
          echo "Saliendo..."
          #el comando exit hace que el script finalize con código de error 1
          exit 1
          ;;

      *) 
    echo "Error: Please try again (select 1..4)!"
          read -p "Presione la tecla [Enter] para continuar..."
    ;;
    esac
done
}
#-------------------------
# ---------------------------------------------------------------------------------------------------------------------
#  ----------------------------------------------- FUNCIONES ---------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------
#------------------------------------------------------------
#------------------------------------------------------------
fntUosCsv2ldif() {
  clear
	read -p "Introduzca el nombre del fichero con las uos [ej: uos.csv]: " fUosCsv2ldif
    if [ -f $fUosCsv2ldif ]; then
  iContador=1
	while IFS=':' read c1 c2 #columnas del fichero, ejemplo c1, c2,...,cn etc...
	do
      if [ $iContador -gt 1 ]; then #si el contador es mayor de uno 
    
  		#Leer dc dc
   		#var1=${c1} #con esto ponemos en la variable variable var1 el contenido de la columna 1 (c1) del fichero que estamos 					#leyendo	
		#echo $var1
		echo "dn: $c2" >> $EstructuraLdif
  		echo "ObjectClass: organizationalUnit" >> $EstructuraLdif
    	echo "ou: $c1" >> $EstructuraLdif
    	echo "" >> $EstructuraLdif
      fi
        iContador=`expr $iContador + 1`
	done < $fUosCsv2ldif #aquí se pone el fichero csv con la información a leer en el bucle
else
echo error el fichero no existe.
fi
return
}
#------------------------------------------------------------
#------------------------------------------------------------
#------------------------------------------------------------
fntGruposCsv2ldif() { 
  clear
	read -p "Introduzca el nombre del fichero con los grupos [ej: grupos.csv]: " fGruposCsv2ldif
    if [ -f $fGruposCsv2ldif ]; then
  iContador=1
	while IFS=':' read c1 c2 c3 c4 #columnas del fichero, ejemplo c1, c2,...,cn etc...
	do
      if [ $iContador -gt 1 ]; then #si el contador es mayor de uno 
  		#Leer dc dc
   		#var1=${c1} #con esto ponemos en la variable variable var1 el contenido de la columna 1 (c1) del fichero que estamos 					#leyendo	
		#echo $var1
		echo "dn: $c2" >> $EstructuraLdif
		echo "objectClass: $c3" >> $EstructuraLdif
		echo "cn: $c1" >> $EstructuraLdif
		echo "gidNumber: $c4" >> $EstructuraLdif
		echo "" >> $EstructuraLdif
      fi
        iContador=`expr $iContador + 1`
	done < $fGruposCsv2ldif #aquí se pone el fichero csv con la información a leer en el bucle
else
echo error el fichero no existe.
fi
return
}
#------------------------------------------------------------
#------------------------------------------------------------
#------------------------------------------------------------
fntUsuariosCsv2ldif() {
  clear
	read -p "Introduzca el nombre del fichero con los usuarios [ej: usuarios.csv]: " fUsuariosCsv2ldif
	if [ -f $fUsuariosCsv2ldif ]; then
  iContador=1
	#echo "# Usuarios" >> fichero.ldif
	while IFS=: read c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 #columnas del fichero, ejemplo c1, c2,...,cn 
	do
      if [ $iContador -gt 1 ]; then #si el contador es mayor de uno 
		echo "dn: $c1" >> $EstructuraLdif
		echo "objectClass: $c2" >> $EstructuraLdif
  		echo "objectClass: $c3" >> $EstructuraLdif
  		echo "objectClass: $c4" >> $EstructuraLdif
		echo "uid: $c5" >> $EstructuraLdif
		echo "sn: $c6" >> $EstructuraLdif
		echo "givenName: $c7" >> $EstructuraLdif
		echo "cn: $c8" >> $EstructuraLdif
		echo "displayName: $c9" >> $EstructuraLdif
		echo "uidNumber: $c10" >> $EstructuraLdif
		echo "gidNumber: $c11" >> $EstructuraLdif
		echo "userPassword: $c12" >> $EstructuraLdif
		echo "gecos: $c13" >> $EstructuraLdif
		echo "loginShell: $c14" >> $EstructuraLdif
		echo "homeDirectory: $c15" >> $EstructuraLdif
		echo "shadowExpire: $c16" >> $EstructuraLdif
		echo "shadowFlag: $c17" >> $EstructuraLdif
		echo "shadowWarning: $c18" >> $EstructuraLdif
		echo "shadowMin: $c19" >> $EstructuraLdif
		echo "shadowMax: $c20" >> $EstructuraLdif
		echo "shadowLastChange: $c21" >> $EstructuraLdif
		echo "mail: $c22" >> $EstructuraLdif
		echo "initials: $c23" >> $EstructuraLdif
		echo "" >> $EstructuraLdif

		fi
        iContador=`expr $iContador + 1`
  done < $fUsuariosCsv2ldif #aquí se pone el fichero csv con la información a leer en el bucle
else
echo error el fichero no existe.
fi
return
}
#En Shadow warning el fichero era fichero-ldif y le faltaba la linea echo "" para #separar en cada usuario


#------------------------------------------------------------
#------------------------------------------------------------
#------------------------------------------------------------
fntEquiposCsv2ldif() { 
  clear
  read -p "Introduzca el nombre del fichero con los equipos [ej: equipos.csv]: " fEquiposCsv2ldif
    if [ -f $fEquiposCsv2ldif ]; then
  iContador=1
  while IFS=':' read c1 c2 c3 #columnas del fichero, ejemplo c1, c2,...,cn etc...
  do
      if [ $iContador -gt 1 ]; then #si el contador es mayor de uno 
      #Leer dc dc
      #var1=${c1} #con esto ponemos en la variable variable var1 el contenido de la columna 1 (c1) del fichero que estamos          #leyendo  
    #echo $var1
    	echo "dn: $c2" >> $EstructuraLdif
		echo "objectClass: $c3" >> $EstructuraLdif
		echo "cn: $c1" >> $EstructuraLdif
		echo "" >> $EstructuraLdif
      fi
        iContador=`expr $iContador + 1`
  done < $fEquiposCsv2ldif #aquí se pone el fichero csv con la información a leer en el bucle
else
echo error el fichero no existe.
fi
return
}

fntInstalarLdif() {
read -p "Introduzca el usuario que va a crearlo [admin] : " USER1
read -p "Introduzca el nombre del subdominio [iesbrochillop] : " NSDOMAIN
read -p "Introduzca el el otro nombre del dominio [edu-gva] : " NSTDOMAIN
read -p "Introduzca el nombre del dominio [es] : " NDOMAIN
read -p "Introduzca el fichero ldif [$EstructuraLdif] : " LDIFFILE
sudo ldapadd -x -D cn=$USER1,dc=$NSDOMAIN,dc=$NSTDOMAIN,dc=$NDOMAIN -W -f $LDIFFILE
}
# ---------------------------------------------------------------------------------------------------------------------
#          ESTA FUNCIÓN CREA LA ESTRUCTURA DE CARPETAS Y ASIGNA LOS PERMISOS PERMITENTES A CADA UNA DE ELLAS

fntCrearGD () {
#--- AQUÍ CREAMOS LA ESTRUCTURA DE CARPETAS DEL GESTOR DOCUMENTAL ---
#mkdir -p GestorDocumental/DepDireccion/{Imagenes,Archivos,Documentos} GestorDocumental/DepDocenciaBACH/{Imagenes,Archivos,Documentos} GestorDocumental/DepInformatica/{Imagenes,Archivos,Documentos} GestorDocumental/DepConserjeria/{Imagenes,Archivos,Documentos}

#mgnastase - lo que hacemos aquí es crear toda la estructura con todas las carpetas que habrán en ella. Encima de este comentario hay otro comentario con una parte del script que haría lo mismo que la parte del script que tenemos a continuación de este párrafo. Solo que en caso de ejecutar dos veces ese script, este fallaría y crearía una carpeta que no debe crear, para evitarlo, utilizaré la verisón menos optima, que es la siguiente:
mkdir -p $DataGD/DepDireccion/Imagenes $DataGD/DepDireccion/Archivos $DataGD/DepDireccion/Documentos $DataGD/DepDocenciaBACH/Imagenes $DataGD/DepDocenciaBACH/Archivos $DataGD/DepDocenciaBACH/Documentos $DataGD/DepInformatica/Imagenes $DataGD/DepInformatica/Archivos $DataGD/DepInformatica/Documentos $DataGD/DepConserjeria/Imagenes $DataGD/DepConserjeria/Archivos $DataGD/DepConserjeria/Documentos
clear

#--- AQUÍ OTORGAMOS PERMISOS A LAS CARPETAS CREADAS ANTERIORMENTE ---
#mgnastase - aquí establecemos los permisos a las carpetas creadas anteriormente
#mgnastase - damos permisos de lectura en todas las carpetas a todos los usuarios
chmod -R 755 $DataGD
#mgnastase - asignamos los grupos a las carpetas de cada departamento
chgrp -R 20000 $DataGD/DepDireccion
chgrp -R 20001 $DataGD/DepDocenciaBACH
chgrp -R 20002 $DataGD/DepInformatica
chgrp -R 20003 $DataGD/DepConserjeria
#mgnastase - damos permisos de escritura a las carpetas de archivos de cada departamento
chmod -R 775 $DataGD/DepDireccion/Imagenes $DataGD/DepDireccion/Archivos $DataGD/DepDireccion/Documentos
chmod -R 775 $DataGD/DepDocenciaBACH/Imagenes $DataGD/DepDocenciaBACH/Archivos $DataGD/DepDocenciaBACH/Documentos
chmod -R 775 $DataGD/DepInformatica/Imagenes $DataGD/DepInformatica/Archivos $DataGD/DepInformatica/Documentos
chmod -R 775 $DataGD/DepConserjeria/Imagenes $DataGD/DepConserjeria/Archivos $DataGD/DepConserjeria/Documentos
#mgnastase - aquí instalamos la herramienta samba para su posterior uso. Nos servirá para poder compartir por red la estructura de carpetas del GestorDocumental
apt-get install samba -y /dev/null
clear
#mgnastase - realizamos una copia de seguridad del archivo de configuarcion de samba antes de modificarlo
cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
#mgnastase - modificamos el archivo de configuración para poder compartir la estructura de carpetas del GestorDocumental por la red
echo "[GestorDocumental]" >> /etc/samba/smb.conf
echo "path = /data/GestorDocumental" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "public = yes" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
#mgnastase - reiniciamos el servicio samba para aplicar los cambios de la configuración
service smbd restart
#--------------------------------------
clear
read -p "
     LA ESCTRUCTURA DE CARPETAS DEL GESTOR DOCUMENTAL AL IGUAL
       QUE LOS PERMISOS SE HAN CREADO Y ASIGNADO CORRECTAMENTE
       PULSE LA TECLA [INTRO] PARA VOLVER AL MENÚ PRINCIPAL: "
}
#----------------------------------------------------------------------------
#                          ESTA FUNCIÓN ELIMINA LA ESTRUCTURA DE CARPETAS AL IGUAL QUE LA COMPARTICIÓN 

fntEliminarGD () {
#mgnastase - aquí borramos el archivo de configuración modificado de samba
rm /etc/samba/smb.conf
#mgnastase - aquí renombramos el archivo de la copia de seguridad que anteriormente creamos para posteriormente reconfigurar samba con la configuración por defecto
mv /etc/samba/smb.conf.backup /etc/samba/smb.conf
#mgnastase - reiniciamos el servicio samba para aplicar los cambios de la configuración
service smbd restart
#mgnastase - aquí eliminamos toda la estructura de carpetas del GestorDocumental
rm -Rf GestorDocumental/
#--------------------------------------
clear
read -p "
     LA ESCTRUCTURA DE CARPETAS DEL GESTOR DOCUMENTAL HA SIDO ELIMINADA
     CORRECTAMENTE PULSE LA TECLA [INTRO] PARA VOLVER AL MENÚ PRINCIPAL: "
}
#----------------------------------------------------------------------------
#          ESTA FUNCIÓN HACE USO DE LA HERRAMIENTA "TREE" PARA LISTAR EL ARBOL DEL GESTOR DOCUMENTAL
fntListarGD () {
apt-get install tree -y > /dev/null
clear
tree -d GestorDocumental
read -p " PULSE LA TECLA [INTRO] PARA VOLVER AL MENÚ PRINCIPAL:"
}
#----------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
#  ------------------------------------------------- MENÚ PRINCIPAL --------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------

#Cada vez que se selecciona una opción, ejecuta su código y se pone a la
#espera que pulsemos una tecla para volver al menú principal
#fntMenuPrincipal() { 
while [ opcion != "" ]
do
	clear
	echo "                                                       "
	echo "                      MENÚ PRINCIPAL                   "
	echo "   ----------------------------------------------------"
	echo "              O   P   E   N   L   D   A   P            "
	echo "   ----------------------------------------------------"
	echo "                                                       "
  	echo "      [pulse 1] CREAR ESTRUCTURA                       "
	echo "                                                       "
  	echo "      [pulse 2] INSTALAR ESTRUCTURA*                   "
	echo "                                                       "
	echo "   * - tenga en cuenta que para instalar la estructura "
	echo "   esta, tiene que estar creada con la primera opcion. "
	echo "                                                       "
	echo "   ----------------------------------------------------"
	echo "     G  E  S  T  O  R - D  O  C  U  M  E  N  T  A  L   "
	echo "   ----------------------------------------------------"
	echo "                                                       "
  	echo "      [pulse 3] CREAR GESTOR DOCUMENTAL                "
	echo "                                                       "
  	echo "      [pulse 4] ELIMINAR GESTOR DOCUMENTAL**           "
	echo "                                                       "
  	echo "      [pulse 5] VER ESTRUCTURA DEL GESTOR DOCUMENTAL** "
	echo "                                                       "
	echo "  ** - esta opción necesita que antes se haya realizado"
	echo "       la creación del gestor documental [opción 3]    "
	echo "                                                       "
	echo "   ----------------------------------------------------"
	echo "    Escribe esto si quieres:            ayuda | salir  "
	echo "   ----------------------------------------------------"

	echo "                                                       "
	echo "                      MENÚ PRINCIPAL                   "
	echo "   ----------------------------------------------------"
	echo "         M I H A I L  G A B R I E L  N A S T A S E     "
	echo "   ----------------------------------------------------"
	echo "                                                       "
  	echo "      [pulse 1] OpenLDAP                               "
	echo "                                                       "
  	echo "      [pulse 2] GESTOR DOCUMENTAL                      "
	echo "                                                       "
  	echo "      [pulse 3] SERVIDOR DE IMPRESIÓN                  "
	echo "                                                       "
	echo "   ----------------------------------------------------"
	echo "    Escribe esto si quieres:            ayuda | salir  "
	echo "   ----------------------------------------------------"

	read -p "   Por favor, pulse una opción:" opcion
	    #Comprueba si el valor recogido en opcion es 1,2 o 3, si es otra cosa, se ejecuta *)
    	case $opcion in
    	1) 
       		#Llamar a la funcion crear usuarios o llamar a un script que cree usuarios
          #ejemplo: si queremos llamar a la funcion crear usuarios pondríamos
		clear  
			fntSubMenuCrearEstructura
		read -p "Presione la tecla [Enter] para continuar..."
       		;;
    	2) 
			clear
			fntInstalarLdif
   	 	read -p "Presione la tecla [Enter] para continuar..."  
		    ;;
    	3) 
			clear
       		#mgnastase - Llamar a la funcion crear estructura de carpetas del gestor documental y asignar los permisos de las mismas
		      fntCrearGD
       		;;
    	4) 
			clear
       		#mgnastase - Llamar a la funcion eliminar estructura de carpetas del gestor documental
			  fntEliminarGD
		    ;;		
    	5) 
			clear
       		#mgnastase - Llamar a la funcion listar estructura de carpetas del gestor documental
			  fntListarGD
		    ;;		
    	ayuda) 
			clear
        	fntAyuda
        	;;
    	salir) 
        	echo "Saliendo..."
        	clear
			exit
        	;;
    	SALIR) 
        	echo "Saliendo..."
			clear
        	exit
        	;;
    	*) 
			echo "Error: Please try again (select 1..4)!"
        read -p "Presione la tecla [Enter] para continuar..."
			;;
   	esac
done
#}

#---------------------------------------------------------------------------------CAMBIAR VARIABLES---

