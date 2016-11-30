until python /home/pi/Documents/FinalProject/ReadSensor.py
do
	echo "'ReadingData.py' crashed with exit code $?.  Respawning.." >&2
	sleep 1
done
