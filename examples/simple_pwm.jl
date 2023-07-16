include("../src/gpio.jl")
using .GPIO

function pwmbreath(channel)
	# Set the GPIO
	GPIO.setmode()
	# Set if the pin is an Output or Input pin
	#GPIO.setup(channel, "OUT", GPIO.HIGH)
    pwm = GPIO.PWM(channel, 50)
    val = 25
    incr = 5
    GPIO.start(pwm, val)
    sleep(10)
    # try
    while true
        sleep(1)
        if val >= 100
            incr = -incr
        end
        if val <= 0
            incr = -incr
        end
        val += incr
        println(val)
        GPIO.changedutycycle(pwm, val)
    end
    # finally
    #     GPIO.stop(pwm)
    #     GPIO.cleanup(channel)
    # end
end

output_pin = 32
pwmbreath(output_pin)