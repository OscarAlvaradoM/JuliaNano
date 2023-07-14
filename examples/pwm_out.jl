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
    GPIO.start(pwm, val)

    try
        while True:
            sleep(0.25)
            if val >= 100
                incr = -incr
            end
            if val <= 0
                incr = -incr
            end
            val += incr
            GPIO.changedutycycle(pwm, val)
        end
    finally
        GPIO.stop(pwm)
        GPIO.cleanup()
    end
end

output_pin = 32
pwmbreath(output_pin)