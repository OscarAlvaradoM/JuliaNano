include("../../src/gpio.jl")
using .GPIO

"""
    pwmbreath(channel::Int)

Starts a PWM breath effect on the specified `channel`.

# Arguments
- `channel::Int`: The PWM channel number or identifier.

# Example
```julia
output_pin = 32
pwmbreath(output_pin)
```
"""
function pwmbreath(channel::Int)
	GPIO.setmode() # Set the GPIO mode
    pwm = GPIO.PWM(channel, 50) # Create a PWM object with the specified channel and frequency
    val = 5  # Initialize the initial duty cycle value
    incr = 5  # Initialize the increment value for changing the duty cycle
    GPIO.start(pwm, val) # Start the PWM with the initial duty cycle value
    try
        while true
            sleep(0.1)  # Delay for smooth transition
            # Check if the duty cycle value has reached the maximum or minimum
            if val >= 100
                incr = -incr # Reverse the increment value
            end
            if val <= 0
                incr = -incr # Reverse the increment value
            end
            val += incr # Increment the duty cycle value
            GPIO.changedutycycle(pwm, val) # Change the duty cycle
        end
    finally
        GPIO.stop(pwm) # Stop the PWM
        GPIO.cleanup() # Clean up the GPIO resources
    end
end

# Usage example
output_pin = 32
pwmbreath(output_pin)
