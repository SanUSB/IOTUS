import RPi.GPIO #sanusb.org/rs/sanusb.php
import time

RPi.GPIO.setwarnings(False)
RPi.GPIO.setmode(RPi.GPIO.BCM)
RPi.GPIO.setup(18, RPi.GPIO.OUT)

# pisca GPIO18 - Pino phys 12 - wPi 1
# print "Blink Python"

while(True):
        print "Blink Python"
		
        # Liga pino

        RPi.GPIO.output(18,RPi.GPIO.HIGH)

        # Espera 1 segundo

        time.sleep(1)

        # Desliga pino

        RPi.GPIO.output(18,RPi.GPIO.LOW)

        # Espera outro segundo

        time.sleep(1)

