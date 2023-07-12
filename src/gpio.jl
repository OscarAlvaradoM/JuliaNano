module GPIO
    include("utils.jl")
    using .Utils

    HIGH = "1"
    LOW  = "0"

    main_path = "/sys/class/gpio/"

    function setmode()
        # Para ver si hay diferentes modelos de Jetson para usar acá. PENDIENTE

        # Cleanup all the ports
        for key in keys(Utils.JETSON_NANO_CHANNELS_DICT)
            try
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
            catch
                write(joinpath(main_path, "unexport"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
                write(joinpath(main_path, "export"), Utils.JETSON_NANO_CHANNELS_DICT[key]["file_number"])
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
        if mode == "IN" || mode == "INPUT"
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
        write(joinpath(main_path, "gpio$(Utils.JETSON_NANO_CHANNELS_DICT[channel]["file_number"])/value"))
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

end

