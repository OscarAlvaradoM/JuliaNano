include("../../src/gpio.jl")
using .GPIO

"""
    inout(in_channel::Int, out_channel::Int)

Reads the value from an input channel and sets the value to an output channel.

# Arguments
- `in_channel::Int`: The GPIO input channel number or identifier.
- `out_channel::Int`: The GPIO output channel number or identifier.

# Example
```julia
input_pin = 15
output_pin = 12
inout(input_pin, output_pin)
```
"""
function inout(in_channel::Int, out_channel::Int)
    prev_value = "" # Store the previous input value for comparison
	GPIO.setmode() # Set the GPIO mode
	GPIO.setup(in_channel, "IN") # Set the input channel as an input pin
    GPIO.setup(out_channel, "OUT") # Set the output channel as an output pin
    try
        while true
            value = GPIO.input(in_channel) # Read the value from the input channel
            if value != prev_value # Check if the input value has changed
                GPIO.output(out_channel, value) # Set the output channel value
                prev_value = value # Update the previous value to the current value
            end
            sleep(0.1) # Delay for smooth operation
        end
    finally
        GPIO.cleanup() # Clean up the GPIO resources
    end
end

# Usage example
input_pin = 15
output_pin = 12
inout(input_pin, output_pin)