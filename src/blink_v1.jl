main_path = "/sys/class/gpio/"

function blink()
	try
		# Set the GPIO 
		# gpio79 is pin 12 on the Jetson Nano Sysfs
		write(joinpath(main_path, "export"), "79")
	catch e
		println("The port was open")
	end

	# Set if the pin is an Output or Input pin
	write(joinpath(main_path, "gpio79/direction"), "out")

	# Set the digital pin 1 (HIGH) or 0 (LOW)
	for _ in 1:10
		write(joinpath(main_path, "gpio79/value"), "1")
		sleep(0.1)
		write(joinpath(main_path, "gpio79/value"), "0")
		sleep(0.1)
	end

	# To close the port we had open
	write(joinpath(main_path, "unexport"), "79")
end

blink()