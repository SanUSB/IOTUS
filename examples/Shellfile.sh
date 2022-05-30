#!/bin/sh

#sanusb.org/rs/sanusb.php
#gpio mode 1 out # pino BCM 18 e Pino físico 12
#gpio mode 1 out
echo 18 > /sys/class/gpio/export #wPi 1
echo out > /sys/class/gpio/gpio18/direction



while :
do
   echo "Blink shell"
   #gpio write 1 1
   echo "1" > /sys/class/gpio/gpio18/value
   sleep 1.5

   #gpio write 1 0
   echo "0" > /sys/class/gpio/gpio18/value
   sleep 1.5

done
