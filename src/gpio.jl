module GPIO
    include("utils.jl")
    using .Utils
    using Base

    HIGH = "1"
    LOW  = "0"

    main_path = "/sys/class/gpio/"
    pwm_path  = "/sys/devices/7000a000.pwm/pwm/"

    function setmode()
        # Para ver si hay diferentes modelos de Jetson para usar acá. PENDIENTE

        # Cleanup all the ports
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[key]["pwm_id"]
            try
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                if ~isnothing(pwm_id) && isdir(joinpath(pwm_path, "pwmchip" * pwm_id))
                    write(joinpath(pwm_path, "pwmchip0", "export"), pwm_id)
                    enable_path = joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable")
                    open(enable_path, "w") do file
                        write(file, "1")
                    end
                end
            catch
                write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                if ~isnothing(pwm_id) && isdir(joinpath(pwm_path, "pwmchip" * pwm_id))
                    write(joinpath(pwm_path, "pwmchip0", "unexport"), pwm_id)
                    write(joinpath(pwm_path, "pwmchip0", "export"), pwm_id)
                    enable_path = joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable")
                    open(enable_path, "w") do file
                        write(file, "1")
                    end
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

    function getpwmpath()
        joinpath(pwm_path, "pwmchip0")
    end

    function getpwmexportpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "export")
    end

    function getpwmunexportpath(pwm::PWM)
        joinpath(getpwmpath(), "unexport")
    end

    function getpwmperiodpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm" * pwm_id, "period")
    end

    function getpwmenablepath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm" * pwm_id, "enable")
    end

    function getpwmdutycyclepath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm" * pwm_id, "duty_cycle")
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
        pwm_id = getpwmid(pwm)
        write(getpwmenablepath(pwm), "0")
    end

    function enablepwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmenablepath(pwm), "1")
    end

    function start(pwm::PWM, duty_cycle_percent::Number)
        #exportpwm(pwm)
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

    function setpwmdutycycle(pwm::PWM, duty_cycle_ns::Number)
        println(duty_cycle_ns)
        write(getpwmdutycyclepath(pwm), string(duty_cycle_ns))
    end

    function setpwmperiod(pwm, period_ns)
        write(getpwmperiodpath(pwm), string(period_ns))
        
    end

    function changedutycycle(pwm::PWM, duty_cycle_percent::Number; start::Bool=false)
        if duty_cycle_percent < 0.0 || duty_cycle_percent > 100.0
            error("Percentage not valid, please try with 0 < values < 100")
        end

        frequency_hz = pwm.frequency_hz
        period_ns = trunc(Int, 1000000.0 / frequency_hz)
        setpwmperiod(pwm, period_ns)

        duty_cycle_ns = trunc(Int, period_ns * (duty_cycle_percent / 100.0))
        setpwmdutycycle(pwm, duty_cycle_ns)

        if start
            enablepwm(pwm)
        end
    end
end