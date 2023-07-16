include("../../src/gpio.jl")
using .GPIO

"""
    input(channel::Int)

Reads the value from an input channel and prints the value.

# Arguments
- `channel::Int`: The GPIO input channel number or identifier.

# Example
```julia
input_pin = 15
input(input_pin)
```
"""
function input(channel::Int)
    prev_value = "" # Store the previous input value for comparison
	GPIO.setmode() # Set the GPIO mode
	GPIO.setup(channel, "IN") # Set the input channel as an input pin
    try
        while true
            value = GPIO.input(channel) # Read the value from the input channel
            if value != prev_value # Check if the input value has changed
                if value == GPIO.HIGH
                    value_str = "HIGH"
                else
                    value_str = "LOW"
                end
                prev_value = value  # Update the previous value to the current value
            end
            sleep(1) # Delay for smooth operation
            println(prev_value) # Print the previous value
        end
    finally
        GPIO.cleanup() # Clean up the GPIO resources
    end
end

# Usage example
input_pin = 15
input(input_pin)