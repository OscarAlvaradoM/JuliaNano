# Set the GPIO 
# gpio79 is pin 12 on the Jetson Nano Sysfs
setˍcommand = pipeline(`echo 79`, stdout="/sys/class/gpio/export")

# Set if the pin is an Output or Input pin
setupˍcommand = pipeline(`echo out`, stdout="/sys/class/gpio/gpio79/direction")

# Set the digital pin 1 (HIGH) or 0 (LOW)
onˍcommand = pipeline(`echo 1`, stdout="/sys/class/gpio/gpio79/value")
offˍcommand = pipeline(`echo 0`, stdout="/sys/class/gpio/gpio79/value")
#run(setˍcommand)
#run(setupˍcommand)

while true
	run(onˍcommand)
	sleep(0.05)
	run(offˍcommand)
	sleep(0.05)
end
