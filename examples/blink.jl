include("../src/gpio.jl")
using .GPIO

function blink(channel)
	# Set the GPIO
	GPIO.setmode()
	# Set if the pin is an Output or Input pin
	GPIO.setup(channel, "OUT"; initial=GPIO.HIGH)

	# Set the digital pin 1 (HIGH) or 0 (LOW)
	try
		while true 
			GPIO.output(channel, GPIO.HIGH)
			sleep(0.1)
			GPIO.output(channel, GPIO.LOW)
			sleep(0.1)
		end
	finally
		GPIO.output(channel, GPIO.LOW)
		# To reset all the ports
		GPIO.cleanup()
	end
end

output_pin = 12
blink(output_pin)