module Utils
    JETSON_NANO_CHANNELS_DICT = Dict(
        7 => Dict("file_number" => "216", "name" => "GPIO9"),
        11 => Dict("file_number" => "50", "name" => "UART1_RTS"),
        12 => Dict("file_number" => "79", "name" => "I2S0_SCLK"),
        13 => Dict("file_number" => "14", "name" => "SPI1_SCK"),
        15 => Dict("file_number" => "194", "name" => "GPIO12"),
        16 => Dict("file_number" => "232", "name" => "SPI1_CS1"),
        18 => Dict("file_number" => "15", "name" => "SPI1_CS0"),
        19 => Dict("file_number" => "16", "name" => "SPI0_MOSI"),
        21 => Dict("file_number" => "17", "name" => "SPI0_MISO"),
        22 => Dict("file_number" => "13", "name" => "SPI1_MISO"),
        23 => Dict("file_number" => "18", "name" => "SPI0_SCK"),
        24 => Dict("file_number" => "19", "name" => "SPI0_CS0"),
        26 => Dict("file_number" => "20", "name" => "SPI0_CS1"),
        29 => Dict("file_number" => "149", "name" => "GPIO01"),
        31 => Dict("file_number" => "200", "name" => "GPIO11"),
        # Older versions of L4T have a DT bug which instantiates a bogus device which prevents this library from using this PWM channel.
        32 => Dict("file_number" => "168", "name" => "GPIO07"),
        # 33 => Dict("file_number" => "38", "name" => "GPIO13"),
        # 35 => Dict("file_number" => "76", "name" => "I2S0_FS"),
        # 36 => Dict("file_number" => "51", "name" => "UART1_CTS"),
        # 37 => Dict("file_number" => "12", "name" => "SPI1_MOSI"),
        # 38 => Dict("file_number" => "77", "name" => "I2S0_DIN"),
        # 40 => Dict("file_number" => "78", "name" => "I2S0_DOUT"),
                                )
end