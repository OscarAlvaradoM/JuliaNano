include("../src/gpio.jl")
using .GPIO

function inout(in_channel, out_channel)
    prev_value = ""

    # Set the GPIO
	GPIO.setmode()
	# Set if the pin is an Output or Input pin
	GPIO.setup(in_channel, "IN")
    GPIO.setup(out_channel, "OUT")
    try
        while true
            value = GPIO.input(in_channel)
            if value != prev_value
                GPIO.output(out_channel, value_str)
                prev_value = value
            end
            sleep(0.1)
        end
    finally
        GPIO.cleanup()
    end
end

input_pin = 15
output_pin = 12
inout(input_pin, output_pin)