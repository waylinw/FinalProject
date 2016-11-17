import sys
import time
import Adafruit_DHT

GPIO_PORT = 18
SENSOR = Adafruit_DHT.DHT11

while True:
    humidity, temperature = Adafruit_DHT.read_retry(SENSOR, GPIO_PORT)
    temperature *= 9/5.0 + 32
    print("Temperature: ", temperature, " deg F, Humidity: ", humidity, " %")
    time.sleep(2)

