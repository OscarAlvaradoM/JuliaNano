module GPIO
    include("utils.jl")
    using .Utils

    HIGH = "1"
    LOW  = "0"

    main_path = "/sys/class/gpio/"
    pwm_path  = "/sys/devices/7000a000.pwm/pwm/"

    function setmode()
        # Para ver si hay diferentes modelos de Jetson para usar acá. PENDIENTE

        # Cleanup all the ports
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            try
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                if key in [32, 33]
                    pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[key]["pwm_id"]
                    write(joinpath(pwm_path, "pwmchip" + pwm_id, "export"), pwm_id)
                end
            catch
                write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                if key in [32, 33]
                    pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[key]["pwm_id"]
                    write(joinpath(pwm_path, "pwmchip" + pwm_id, "unexport"), pwm_id)
                    write(joinpath(pwm_path, "pwmchip" + pwm_id, "export"), pwm_id)
                end
            end
        end
    end

    function setup(channel::Int, mode::String, initial::String)
        if mode == "OUT" || mode == "OUTPUT"
            mode = "out"
        else
            print("The selected mode is not valid, try again with IN or OUT")
            return 
        end

        try
            write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/direction"), mode)
        catch
            write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])
            write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/direction"), mode)
        end
        write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/value"), initial)
    end

    function setup(channel::Int, mode::String)
        if mode == "OUT" || mode == "OUTPUT"
            mode = "out"
        elseif mode == "IN" || mode == "INPUT"
            mode = "in"
        else
            print("The selected mode is not valid, try again with IN or OUT")
            return 
        end

        try
            write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/direction"), mode)
        catch
            write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])
            write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/direction"), mode)
        end
    end

    function output(channel, value)
        pin_out = Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"]
        write(joinpath(main_path, "gpio$(pin_out)", "value"), value)
    end

    function input(channel)
        pin_in = Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"]
        open(io->read(io, String), joinpath(main_path, "gpio$(pin_in)", "value"))
    end

    function cleanup()
        # Cleanup all the ports
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
        end
    end

    struct PWM
        channel::Int
        frequency_hz::Number
    end

    function getpwmexportpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(pwm_path, "pwmchip" + pwm_id, "export")
    end

    function getpwmunexportpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(pwm_path, "pwmchip" + pwm_id, "unexport")
    end

    function exportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmexportpath(pwm), pwm_id)
    end

    function unexportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmunexportpath(pwm), pwm_id)
    end

    function disablepwm(pwm::PWM)
        write(joinpath(getpwmpath(pwm), "enable"), "0")
    end

    function start(pwm::PWM, duty_cycle_percent::Number)
        exportpwm(pwm)
        changedutycycle(pwm, duty_cycle_percent; start=true)
    end

    function stop(pwm::PWM)
        disablepwm(pwm)
    end

    function getpwmchannel(pwm::PWM)
        Utils.JETSON_NANO_CHANNELS_DICT[pwm.channel]["pwm_id"]
    end

    function getpwmid(pwm::PWM)
        Utils.JETSON_NANO_CHANNELS_DICT[pwm.channel]["pwm_id"]
    end

    function getpwmpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(pwm_path, "pwmchip" + pwm_id)
    end

    function setpwmdutycycle(channel, duty_cycle_ns)
        write(joinpath(pwm_path, "duty_cycle"), duty_cycle_ns)
    end

    function enablepwm(pwm::PWM)
        write(joinpath(getpwmpath(pwm), "enable"), "1")
    end

    function changedutycycle(pwm::PWM, duty_cycle_percent::Number; start::Bool)
        if duty_cycle_percent < 0.0 || duty_cycle_percent > 100.0:
            error("Percentage not valid, please try with 0 < values < 100")
        end

        frequency_hz = pwm.frequency_hz
        period_ns = int(1000000000.0 / frequency_hz)

        channel = pwm.channel
        duty_cycle_ns = int(period_ns * (duty_cycle_percent / 100.0))
        setpwmdutycycle(channel, _duty_cycle_ns)

        if start
            enablepwm(pwm)
        end
    end
end

