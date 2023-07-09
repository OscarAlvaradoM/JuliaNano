using BenchmarkTools

function blink()
	try
		# Set the GPIO 
		# gpio79 is pin 12 on the Jetson Nano Sysfs
		open_channel_command = pipeline(`echo 79`, stdout="/sys/class/gpio/export")
		run(open_channel_command)
	catch e
		println("The port was open")
	end
	# Set if the pin is an Output or Input pin
	setupˍcommand = pipeline(`echo out`, stdout="/sys/class/gpio/gpio79/direction")
	run(setupˍcommand)

	# Set the digital pin 1 (HIGH) or 0 (LOW)
	on_command = pipeline(`echo 1`, stdout="/sys/class/gpio/gpio79/value")
	off_command = pipeline(`echo 0`, stdout="/sys/class/gpio/gpio79/value")

	for i in 1:100
		run(on_command)
		sleep(0.05)
		run(off_command)
		sleep(0.05)
	end

	# To close the port we had open
	close_channel_command = pipeline(`echo 79`, stdout="/sys/class/gpio/unexport")
	run(close_channel_command)
end

@benchmark blink()