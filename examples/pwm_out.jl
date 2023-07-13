include("../src/gpio.jl")
using .GPIO

function pwmbreath(channel)
	# Set the GPIO
	GPIO.setmode()
	# Set if the pin is an Output or Input pin
	GPIO.setup(channel, "OUT"; initial=GPIO.HIGH)
    pwm = GPIO.PWM(output_pin, 50)
    val = 25
    incr = 5
    pwm.start(val)

    try
        while True:
            sleep(0.25)
            if val >= 100:
                incr = -incr
            end
            if val <= 0:
                incr = -incr
            end
            val += incr
            pwm.ChangeDutyCycle(val)
        end
    finally:
        pwm.stop()
        GPIO.cleanup()
    end
end

output_pin = 33
blink(output_pin)