include("../src/gpio.jl")
using .GPIO

function simple_input(channel)
    prev_value = ""

    # Set the GPIO
	GPIO.setmode()
	# Set if the pin is an Output or Input pin
	GPIO.setup(channel, "IN")
    try
        while true
            value = GPIO.input(channel)
            if value != prev_value
                if value == GPIO.HIGH
                    value_str = "HIGH"
                else
                    value_str = "LOW"
                end
                prev_value = value
            end
                sleep(1)
            println(prev_value)
        end
    finally
        GPIO.cleanup()
    end
end

input_pin = 12
simple_input(input_pin)