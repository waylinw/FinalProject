#!/usr/bin/python

import sys
import time
import Adafruit_DHT
import MySQLdb

db = MySQLdb

db = MySQLdb.connect(host="localhost",    # your host, usually localhost
                     user="root",         # your username
                     passwd="root",       # your password
                     db="sfm")            # name of the data base

GPIO_PORT = 18
SENSOR = Adafruit_DHT.DHT11

while True:
    cur = db.cursor()   
    humidity, temp_c = Adafruit_DHT.read_retry(SENSOR, GPIO_PORT)
    temp_f = temp_c * 9 / 5.0 + 32
    cur.execute('''INSERT INTO Data (created_at, temp_f, temp_c, humidity) VALUES (NOW(), %s, %s, %s)''',
            (temp_f, temp_c, humidity))
    print "Temperature: %.2f deg F (%.2f deg C), Humidity: %.2f" % (temp_f, temp_c, humidity)
    cur.close()
    db.commit()
    time.sleep(2)

db.close()

