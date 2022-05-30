#!/bin/bash

profile=  #add your profile name. The same of http://sanusb.org/iotus/sanusb.php
   	# install curl
	if [ ! -f "/usr/bin/curl" ] && [ ! -f "/bin/curl" ]; then     
     apt-get upgrade
     apt-get update
     apt-get install curl
	fi

	# install Wpi
    if [ ! -f "/usr/include/wiringPi.h" ]; then
 	  sudo apt-get install wiringpi
    fi
	
	# install sanusb (sanusb.org)
	if [ ! -f "/usr/share/sanusb/sanusb" ]; then
     cd /home/share
     wget http://sanusb.org/tools/SanUSBrpi.zip
	 unzip SanUSBrpi.zip
	 cd SanUSBrpi
	 sudo dpkg -i sanusb_raspberry.deb
	 chmod +x sanusb
	 cp sanusb /usr/share/sanusb
	fi
	
	# install Samba #smbd.service must last to start
	# To access tyte \\IP\share in Explorer
	 # http://sanusb.org/arquivos/embarcadoslinux.pdf
	if [ ! -f "/etc/samba/smb.conf.old" ]; then
    apt-get upgrade
	apt-get update
	apt-get install samba samba-common-bin
	mkdir /home/share/
	cd /home
	chmod 777 share
	cd /etc
	chmod 777 samba
    cd /etc/samba
	mv smb.conf  smb.conf.old 
	wget  http://sanusb.org/arquivos/smb.zip
	unzip smb.zip
	service smbd restart
	fi

#echo 17 > /sys/class/gpio/export #wPi 0
#echo out > /sys/class/gpio/gpio17/direction
gpio mode 0 out

#echo 18 > /sys/class/gpio/export #wPi 1
#echo out > /sys/class/gpio/gpio18/direction 
gpio mode 1 out


##***********************************************************************************************  
contini=$(curl -sl sanusb.org/iotus/$profile/view.txt)
echo contini = $contini
sleep 1

indini=$(curl -sl sanusb.org/iotus/$profile/viewi.txt)
echo indini = $indini
##***********************************************************************************************

#Diretorio onde sera efetuado o download
DIR=/home/share/temp

if [ ! -d "$DIR" ]; then
	mkdir /home/share/temp
fi


#Start Loop
while :
do
	#debug "echo hello blink"
	#Verifica o índice content
	content=$(curl -sl sanusb.org/iotus/$profile/view.txt)
	echo content = $content
	sleep 1
	
	if (( "$content" != "$contini" )); then    
	  
		#curl -L --output /var/www/$profile$content.hex   http://sanusb.org/iotus/$profile/$profile$content.hex     
		#wget http://sanusb.org/iotus/$profile/$profile$content.hex
				
		#echo ".hex file"
		wget --spider --quiet http://sanusb.org/iotus/$profile/$profile$content.hex && arq="Ok" || arq="No"
		if [ "$arq" == "Ok" ]; then
			ls $DIR 2> /dev/null
						
			if [ $? -ne 0 ]; then
				echo "Diretorio vazio!"
			else
				oldps=$(ls $DIR)
				kill $(ps | grep $oldps | cut -d' ' -f1) 2>/dev/null
				kill $(ps | grep python | cut -d' ' -f1) 2>/dev/null
				kill $(ps | grep $oldps | cut -d' ' -f2) 2>/dev/null 
				kill $(ps | grep python | cut -d' ' -f2) 2>/dev/null
				rm $DIR/$oldps
			fi
					
			wget http://sanusb.org/iotus/$profile/$profile$content.hex

			#echo 0 > /sys/class/gpio/gpio17/value  
			gpio write 0 0
			#echo 1 > /sys/class/gpio/gpio18/value 
			gpio write 1 1 
			#echo "gpio write 0 0 -> Estado de gravacao";
			sleep 2
			
			#./sanusb -w $profile.hex -r
			/usr/share/sanusb/./sanusb -w /home/share/$profile$content.hex -r

			#echo 1 > /sys/class/gpio/gpio17/value  
			gpio write 0 1
			#echo 0 > /sys/class/gpio/gpio18/value  
			gpio write 1 0
			
			rm $profile$content.hex 
						
			#Atualiza o índice atual contini
			contini=$(curl -sl sanusb.org/iotus/$profile/view.txt)
			echo $contini				
		
		else
			#echo ".c file"
			wget --spider --quiet http://sanusb.org/iotus/$profile/$profile$content.c && arq="Ok" || arq="No"
			if [ "$arq" == "Ok" ]; then
					
				ls $DIR 2> /dev/null
								
				if [ $? -ne 0 ]; then
					echo "Diretorio vazio!"
				else
					oldps=$(ls $DIR)
					kill $(ps | grep $oldps | cut -d' ' -f1) 2>/dev/null
					kill $(ps | grep python | cut -d' ' -f1) 2>/dev/null
					kill $(ps | grep $oldps | cut -d' ' -f2) 2>/dev/null
					kill $(ps | grep python | cut -d' ' -f2) 2>/dev/null
					rm $DIR/$oldps
				fi
						
				wget http://sanusb.org/iotus/$profile/$profile$content.c -O $DIR/$profile$content.c
				#kill $(ps | grep $profile$contRM | cut -d' ' -f2)
				#kill $(ps -l | grep sleep | cut -d' ' -f11)
						

				gcc -o $DIR/$profile$content $DIR/$profile$content.c -l wiringPi
				rm $DIR/$profile$content.c
				chmod 777 $DIR/$profile$content		
				($DIR/./$profile$content)&
						
				#rm $profile$content.c
						
				#Atualiza o índice atual contini
				contini=$(curl -sl sanusb.org/iotus/$profile/view.txt)
				echo $contini
						
			else
				#echo ".sh file"
				wget --spider --quiet http://sanusb.org/iotus/$profile/$profile$content.sh && arq="Ok" || arq="No"
				if [ "$arq" == "Ok" ]; then
						
					ls $DIR 2> /dev/null
								
					if [ $? -ne 0 ]; then
						echo "Diretorio vazio!"
					else
						oldps=$(ls $DIR)
						kill $(ps | grep $oldps | cut -d' ' -f1) 2>/dev/null
						kill $(ps | grep python | cut -d' ' -f1) 2>/dev/null
						kill $(ps | grep $oldps | cut -d' ' -f2) 2>/dev/null
						kill $(ps | grep python | cut -d' ' -f2) 2>/dev/null
						rm $DIR/$oldps
					fi
								
					wget http://sanusb.org/iotus/$profile/$profile$content.sh -O $DIR/$profile$content.sh
					
					#kill $(ps -l | grep sleep | cut -d' ' -f11) #O f11 indica a coluna do Pai do Processo do sleep, ou seja, o BASH
							  
					chmod 777 $DIR/$profile$content.sh
					($DIR/./$profile$content.sh)&
						
					#rm $profile$content.sh
						
					#Atualiza o índice atual contini
					contini=$(curl -sl sanusb.org/iotus/$profile/view.txt)
					echo $contini
				else
					#echo ".py file"
					wget --spider --quiet http://sanusb.org/iotus/$profile/$profile$content.py && arq="Ok" || arq="No"
					if [ "$arq" == "Ok" ]; then
							
						ls $DIR 2> /dev/null
									
						if [ $? -ne 0 ]; then
							echo "Diretorio vazio!"
						else
							oldps=$(ls $DIR)
							kill $(ps | grep $oldps | cut -d' ' -f1) 2>/dev/null
							kill $(ps | grep python | cut -d' ' -f1) 2>/dev/null
							kill $(ps | grep $oldps | cut -d' ' -f2) 2>/dev/null
							kill $(ps | grep python | cut -d' ' -f2) 2>/dev/null
							rm $DIR/$oldps
						fi
									
						wget http://sanusb.org/iotus/$profile/$profile$content.py -O $DIR/$profile$content.py
						
						#kill $(ps | grep $rpf8 | cut -d' ' -f2)
						#kill $(ps | grep $profile$contRM | cut -d' ' -f2)
						#kill $(ps -l | grep sleep | cut -d' ' -f11) #O f11 indica a coluna do Pai do Processo do sleep, ou seja, o BASH
								  
						chmod 777 $DIR/$profile$content.py
						(python $DIR/$profile$content.py)&
							
						#Atualiza o índice atual contini
						contini=$(curl -sl sanusb.org/iotus/$profile/view.txt)
						echo $contini	
					fi
				fi
			fi
		fi

	#else echo "No SanUSB Firmware Updating."
	fi
##***********************************************************************************************  
	indice=$(curl -sl sanusb.org/iotus/$profile/viewi.txt)
	sleep 1
	#echo indice = $indice
##***********************************************************************************************
	if [ "$indice" != "$indini" ]; then      
	
		comando=$(curl -sl sanusb.org/iotus/$profile/viewc.txt)
		sleep 1
		echo comando = $comando
		sleep 1
		if test "$comando" = "wi"; then 	#test compare long strings(one =)
		ssid=$(curl -sl sanusb.org/iotus/$profile/views.txt) #ssid
		pass=$(curl -sl sanusb.org/iotus/$profile/viewp.txt) #pass
		sleep 1
curl -F "password=$profile" -F "ssidw=$ssid" -F "passw=$pass" -F "arquivo=@/etc/wpa_supplicant/wpa_supplicant.conf"  http://sanusb.org/iotus/upwifi.php
			sleep 1
			if [ "$pass" != "" ]; then
				cd /etc
				chmod 777 wpa_supplicant
				cd /etc/wpa_supplicant
				mv wpa_supplicant.conf  wpa_supplicant.conf.old 
				wget http://sanusb.org/iotus/$profile/wifi.txt
				mv wifi.txt /etc/wpa_supplicant/wpa_supplicant.conf			
				cd /home/share
			fi  #reboot #the Rpi
		 else
			echo $(date +%d/%m/%Y) $(date +%H:%M:%S)  $($comando) >> /home/share/$profile.txt #captura a resposta do comando executado
			sleep 1
			curl -F "password=$profile" -F "arquivo=@/home/share/$profile.txt"  http://sanusb.org/iotus/upload.php
			sleep 1
		fi
		
		indini=$(curl -sl sanusb.org/iotus/$profile/viewi.txt)
		sleep 1
		echo indini = $indini

	fi
##***********************************************************************************************

	sleep 5
done
