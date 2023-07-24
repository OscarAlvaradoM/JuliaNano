module GPIO
    include("utils.jl")
    using .Utils

    # Constants
    HIGH = "1"
    LOW  = "0"

    # Paths
    main_path = "/sys/class/gpio/"
    pwm_path  = "/sys/devices/7000a000.pwm/pwm/"

    """
        cleanup(channel::Int)

    Cleans up the GPIO resources associated with the specified channel.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    """
    function cleanup(channel::Int)
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
                println("Channel $channel already disabled")
            end
        end
    end

    """
        cleanup(file_number::String)

    Cleans up the GPIO resources associated with the specified file number.

    # Arguments
    - `file_number::String`: The GPIO file number.
    """
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
                println("File $file_number already disabled")
            end
        end
    end

    """
        cleanup()

    Cleans up all GPIO resources.
    """
    function cleanup()
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            try 
                cleanup(key)
            catch
                activeup(key)
                cleanup(key)
            end
        end
    end

    """
        activeup(channel::Int)

    Activates the specified channel for GPIO usage.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    """
    function activeup(channel::Int)
        pwm_id =  Utils.JETSON_NANO_CHANNELS_DICT[channel]["pwm_id"]
        if isdir(main_path)
            try
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])
            catch
                println("Channel $channel already enabled")
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

    """
        setmode()

    Sets the GPIO mode.
    """
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

    """
        setup(channel::Int, mode::String, initial::String)

    Sets up the GPIO channel with the specified mode and initial value.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    - `mode::String`: The mode of the GPIO channel (IN or OUT).
    - `initial::String`: The initial value of the GPIO channel.
    """
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

    """
        setup(channel::Int, mode::String)

    Sets up the GPIO channel with the specified mode.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    - `mode::String`: The mode of the GPIO channel (IN or OUT).
    """
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

    """
        output(channel::Int, value::Number)

    Sets the output value of the GPIO channel.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    - `value::Number`: The value to be set on the GPIO channel.
    """
    function output(channel::Int, value::String)
        pin_out = Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"]
        write(joinpath(main_path, "gpio$(pin_out)", "value"), value)
    end

    """
        input(channel::Int)

    Reads and returns the input value of the GPIO channel.

    # Arguments
    - `channel::Int`: The GPIO channel number or identifier.
    """
    function input(channel::Int)
        pin_in = Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"]
        open(io->read(io, String), joinpath(main_path, "gpio$(pin_in)", "value"))
    end

    mutable struct PWM
        channel::Int
        frequency_hz::Number
        period_ns::Int
    end

    """
        PWM(channel::Int, frequency_hz::Number; period_ns::Int = 0)::PWM

    Creates a new `PWM` object with the specified channel and frequency.

    # Arguments
    - `channel::Int`: The channel number of the PWM.
    - `frequency_hz::Number`: The frequency in hertz.
    - `period_ns::Int = 0`: The period in nanoseconds (default: 0).

    # Returns
    - `pwm::PWM`: The created `PWM` object.

    """
    function PWM(channel::Int, frequency_hz::Number; period_ns::Int = 0)::PWM
        PWM(channel, frequency_hz, period_ns)
    end

    """
        getpwmpath()::String

    Returns the path of the PWM chip.

    # Returns
    - `path::String`: The path of the PWM chip.

    """
    function getpwmpath()::String
        joinpath(pwm_path, "pwmchip0")
    end

    """
        getpwmexportpath()

    Returns the path to export the PWM.
    """
    function getpwmexportpath()::String
        joinpath(getpwmpath(), "export")
    end

    """
        getpwmunexportpath()

    Returns the path to unexport the PWM.
    """
    function getpwmunexportpath()::String
        joinpath(getpwmpath(), "unexport")
    end

    """
        getpwmperiodpath(pwm::PWM)::String

    Returns the path of the period file for the specified PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.

    # Returns
    - `path::String`: The path of the period file.

    """
    function getpwmperiodpath(pwm::PWM)::String
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm" * pwm_id, "period")
    end

    """
        getpwmenablepath(pwm::PWM)::String

    Returns the path of the enable file for the specified PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.

    # Returns
    - `path::String`: The path of the enable file.

    """
    function getpwmenablepath(pwm::PWM)::String
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm$(pwm_id)", "enable")
    end

    """
        getpwmdutycyclepath(pwm::PWM)::String

    Returns the path of the duty cycle file for the specified PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.

    # Returns
    - `path::String`: The path of the duty cycle file.

    """
    function getpwmdutycyclepath(pwm::PWM)::String
        pwm_id = getpwmid(pwm)
        joinpath(getpwmpath(), "pwm$(pwm_id)", "duty_cycle")
    end

    """
        exportpwm(pwm::PWM)

    Exports the specified PWM channel.
    """
    function exportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmexportpath(), pwm_id)
    end

    """
        unexportpwm(pwm::PWM)

    Unexports the specified PWM channel.
    """
    function unexportpwm(pwm::PWM)
        pwm_id = getpwmid(pwm)
        write(getpwmunexportpath(), pwm_id)
    end

    """
        disablepwm(pwm::PWM)

    Disables the specified PWM channel.
    """
    function disablepwm(pwm::PWM)
        write(getpwmenablepath(pwm), "0")
    end

    """
        enablepwm(pwm::PWM)

    Enables the specified PWM channel.
    """
    function enablepwm(pwm::PWM)
        write(getpwmenablepath(pwm), "1")
    end

    """
        start(pwm::PWM, duty_cycle_percent::Number)

    Starts the PWM with the specified duty cycle percentage.

    # Arguments
    - `pwm::PWM`: The PWM object.
    - `duty_cycle_percent::Number`: The duty cycle percentage.
    """
    function start(pwm::PWM, duty_cycle_percent::Number)
        # Anything that doesn't match new frequency
        pwm.frequency_hz = -pwm.frequency_hz
        reconfigure(pwm, -pwm.frequency_hz, 0.0)
        reconfigure(pwm, pwm.frequency_hz, duty_cycle_percent; start=true)
    end

    """
        stop(pwm::PWM)

    Stops the PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.
    """
    function stop(pwm::PWM)
        disablepwm(pwm)
    end

    """
        getpwmid(pwm::PWM)

    Returns the PWM ID associated with the PWM object.

    # Arguments
    - `pwm::PWM`: The PWM object.
    """
    function getpwmid(pwm::PWM)
        Utils.JETSON_NANO_CHANNELS_DICT[pwm.channel]["pwm_id"]
    end

    """
        setpwmdutycycle(pwm::PWM, duty_cycle_ns::Number)

    Sets the duty cycle of the PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.
    - `duty_cycle_ns::Number`: The duty cycle in nanoseconds.
    """
    function setpwmdutycycle(pwm::PWM, duty_cycle_ns::Number)
        try
            let f_duty_cycle = open(getpwmdutycyclepath(pwm), "r+")
                seek(f_duty_cycle, 0)
                write(f_duty_cycle, string(duty_cycle_ns))
                close(f_duty_cycle)
                #flush(f_duty_cycle)
            end
        finally
            let f_duty_cycle = open(getpwmdutycyclepath(pwm), "r+")
                seek(f_duty_cycle, 0)
                #close(f_duty_cycle)
                flush(f_duty_cycle)
            end
            let f_duty_cycle = open(getpwmdutycyclepath(pwm), "r+")
                seek(f_duty_cycle, 0)
                write(f_duty_cycle, string(duty_cycle_ns))
                close(f_duty_cycle)
                #flush(f_duty_cycle)
            end
        end
    end

    """
        setpwmperiod(pwm::PWM, period_ns::Int)

    Sets the period of the PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.
    - `period_ns::Int`: The period in nanoseconds.
    """
    function setpwmperiod(pwm::PWM, period_ns::Int)
        open(getpwmperiodpath(pwm), "w") do f_period
            seek(f_period, 0)
            write(f_period, string(period_ns))
            flush(f_period)
        end
    end
    
    """
        reconfigure(pwm::PWM, frequency_hz::Real, duty_cycle_percent::Number; start::Bool=false)

    Reconfigures the PWM channel with the specified frequency and duty cycle.

    # Arguments
    - `pwm::PWM`: The PWM object.
    - `frequency_hz::Real`: The frequency in Hz.
    - `duty_cycle_percent::Number`: The duty cycle percentage.
    - `start::Bool`: Whether to start the PWM (default: false).
    """
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

    """
        changedutycycle(pwm::PWM, duty_cycle_percent::Number)

    Changes the duty cycle of the PWM channel.

    # Arguments
    - `pwm::PWM`: The PWM object.
    - `duty_cycle_percent::Number`: The duty cycle percentage.
    """
    function changedutycycle(pwm::PWM, duty_cycle_percent::Number)
        reconfigure(pwm, pwm.frequency_hz, duty_cycle_percent)
    end
end
