module GPIO
    include("utils.jl")
    using .Utils
    using Base

    HIGH = "1"
    LOW  = "0"

    main_path = "/sys/class/gpio/"
    pwm_path  = "/sys/devices/7000a000.pwm/pwm/"

    function cleanup(channel::Int)
        # Cleanup port
        pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[channel]["pwm_id"]
        if ~isnothing(pwm_id)
            if isdir(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"))
                write(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"), "0")
            end
            if isdir(joinpath(pwm_path, "pwmchip0"))
                write(joinpath(pwm_path, "pwmchip0", "unexport"), pwm_id)
            end
        end
        if isdir(main_path)
            try
                write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])
            catch
                println("Ya está desactivado")
            end
        end
    end

    function cleanup(file_number::String)
        # Cleanup port
        pwm_id = nothing
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            if file_number == Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"]
                pwm_id = Utils.JETSON_NANO_CHANNELS_DICT[key]["pwm_id"]
            end
        end
        
        if ~isnothing(pwm_id)
            if isdir(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"))
                write(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"), "0")
            end
            if isdir(joinpath(pwm_path, "pwmchip0"))
                write(joinpath(pwm_path, "pwmchip0", "unexport"), pwm_id)
            end
        end
        if isdir(main_path)
            try
                write(joinpath(main_path, "unexport"), file_number)
            catch
                println("Ya está desactivado")
            end
        end
    end

    function activeup(channel::Int)
        pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[channel]["pwm_id"]
        if isdir(main_path)
            try
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])
            catch
                println("Ya está activado")
            end
        end
        if ~isnothing(pwm_id) 
            if isdir(joinpath(pwm_path, "pwmchip0"))
                write(joinpath(pwm_path, "pwmchip0", "export"), pwm_id)
            end
            if isdir(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"))
                write(joinpath(pwm_path, "pwmchip0", "pwm" * pwm_id, "enable"), "1")
            end
        end
    end

    function setmode()
        # Para ver si hay diferentes modelos de Jetson para usar acá. PENDIENTE

        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            try 
                activeup(key)
            catch
                cleanup(key)
                activeup(key)
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

    mutable struct PWM
        channel::Int
        frequency_hz::Number
        period_ns::Int64
    end

    function PWM(channel::Int, frequency_hz::Number; period_ns::Int64 = 0)
        return PWM(channel, frequency_hz, period_ns)
    end

    function getpwmpath()
        joinpath(pwm_path, "pwmchip0")
    end

    function getpwmexportpath()
        joinpath(getpwmpath(), "export")
    end

    function getpwmunexportpath()
        joinpath(getpwmpath(), "unexport")
    end

    function getpwmperiodpath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm" * pwm_id, "period")
    end

    function getpwmenablepath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm$(pwm_id)", "enable")
    end

    function getpwmdutycyclepath(pwm::PWM)
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm$(pwm_id)", "duty_cycle")
    end

    function exportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmexportpath(), pwm_id)
    end

    function unexportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmunexportpath(), pwm_id)
    end

    function disablepwm(pwm::PWM)
        write(getpwmenablepath(pwm), "0")
    end

    function enablepwm(pwm::PWM)
        write(getpwmenablepath(pwm), "1")
    end

    function start(pwm::PWM, duty_cycle_percent::Number)
        # Anything that doesn't match new frequency
        pwm.frequency_hz = -pwm.frequency_hz
        reconfigure(pwm, -pwm.frequency_hz, 0.0)
        reconfigure(pwm, pwm.frequency_hz, duty_cycle_percent; start=true)
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
        open(getpwmdutycyclepath(pwm), "r+") do f_duty_cycle
            seek(f_duty_cycle, 0)
            write(f_duty_cycle, string(duty_cycle_ns))
            flush(f_duty_cycle)
        end
    end

    function setpwmperiod(pwm::PWM, period_ns::Int64)
        open(getpwmperiodpath(pwm), "w") do f_period
            seek(f_period, 0)
            write(f_period, string(period_ns))
            flush(f_period)
        end
    end
    
    function reconfigure(pwm::PWM, frequency_hz::Real, duty_cycle_percent::Number; start::Bool=false)
        if duty_cycle_percent < 0.0 || duty_cycle_percent > 100.0
            error("Percentage not valid, please try with 0 < values < 100")
        end

        freq_change = start || frequency_hz != pwm.frequency_hz
        if freq_change
            pwm.frequency_hz = frequency_hz
            pwm.period_ns = trunc(Int, 1000000000.0 / frequency_hz)
            setpwmdutycycle(pwm, 0)
            setpwmperiod(pwm, pwm.period_ns)
        end
        

        duty_cycle_ns = trunc(Int, pwm.period_ns * (duty_cycle_percent / 100.0))
        setpwmdutycycle(pwm, duty_cycle_ns)

        if start
            enablepwm(pwm)
        end
    end

    function changedutycycle(pwm::PWM, duty_cycle_percent::Number)
        reconfigure(pwm, pwm.frequency_hz, duty_cycle_percent)
    end
end