try
	# Set the GPIO 
	# gpio79 is pin 12 on the Jetson Nano Sysfs
	write("/sys/class/gpio/export", "79")
catch e
	println("The port was open")
end

# Set if the pin is an Output or Input pin
write("/sys/class/gpio/gpio79/direction", "out")

# Set the digital pin 1 (HIGH) or 0 (LOW)
for i in 1:100
	write("/sys/class/gpio/gpio79/value", "1")
	sleep(0.05)
	write("/sys/class/gpio/gpio79/value", "1")
	sleep(0.05)
end

# To close the port we had open
write("/sys/class/gpio/unexport", "79")