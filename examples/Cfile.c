#include <stdio.h> //sanusb.org/rs/sanusb.php
#include <wiringPi.h>

// LED - pino 1 do wiringPi  é o BCM_GPIO 18 e o pino físico 12

#define   LED   1

int main (void)
{
   wiringPiSetup() ;
   pinMode (LED, OUTPUT) ;

   while(1)
   {
   printf ("Blink C\r\n") ;
   digitalWrite (LED, HIGH) ;   // On
   delay (500) ;                
   digitalWrite (LED, LOW) ;   // Off
   delay (500) ;
   
   system("gpio write 1 1");
   system("sleep 1");
   system("gpio write 1 0");
   system("sleep 1");   
   }
   return 0 ;
}
