include("../../src/gpio.jl")
using .GPIO

"""
    blink(channel::Int)

Blinks an output channel by alternating between HIGH and LOW states.

# Arguments
- `channel::Int`: The GPIO channel number or identifier.

# Example
```julia
output_pin = 12
blink(output_pin)
```
"""
function blink(channel::Int)
	GPIO.setmode() # Set the GPIO
	GPIO.setup(channel, "OUT", GPIO.HIGH) # Set the channel as an output pin

	try
		while true 
			GPIO.output(channel, GPIO.HIGH) # Set the pin to HIGH state
			sleep(0.1) # Delay for ON state
			GPIO.output(channel, GPIO.LOW) # Set the pin to LOW state
			sleep(0.1) # Delay for OFF state
		end
	finally
		GPIO.output(channel, GPIO.LOW) # Ensure the pin is set to LOW state
		GPIO.cleanup() # Clean up the GPIO resources
	end
end

# Usage example
output_pin = 32
blink(output_pin)
