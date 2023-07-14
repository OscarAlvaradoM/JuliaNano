module Utils
    JETSON_NANO_CHANNELS_DICT = Dict(
        7  => Dict("file_number" => "216", "name" => "GPIO9",       "pwm_id" => nothing),
        11 => Dict("file_number" => "50",  "name" => "UART1_RTS",   "pwm_id" => nothing),
        12 => Dict("file_number" => "79",  "name" => "I2S0_SCLK",   "pwm_id" => nothing),
        13 => Dict("file_number" => "14",  "name" => "SPI1_SCK",    "pwm_id" => nothing),
        15 => Dict("file_number" => "194", "name" => "GPIO12",      "pwm_id" => nothing),
        16 => Dict("file_number" => "232", "name" => "SPI1_CS1",    "pwm_id" => nothing),
        18 => Dict("file_number" => "15",  "name" => "SPI1_CS0",    "pwm_id" => nothing),
        19 => Dict("file_number" => "16",  "name" => "SPI0_MOSI",   "pwm_id" => nothing),
        21 => Dict("file_number" => "17",  "name" => "SPI0_MISO",   "pwm_id" => nothing),
        22 => Dict("file_number" => "13",  "name" => "SPI1_MISO",   "pwm_id" => nothing),
        23 => Dict("file_number" => "18",  "name" => "SPI0_SCK",    "pwm_id" => nothing),
        24 => Dict("file_number" => "19",  "name" => "SPI0_CS0",    "pwm_id" => nothing),
        26 => Dict("file_number" => "20",  "name" => "SPI0_CS1",    "pwm_id" => nothing),
        29 => Dict("file_number" => "149", "name" => "GPIO01",      "pwm_id" => nothing),
        31 => Dict("file_number" => "200", "name" => "GPIO11",      "pwm_id" => nothing),
        # Older versions of L4T have a DT bug which instantiates a bogus device which prevents this library from using this PWM channel.
        32 => Dict("file_number" => "168", "name" => "GPIO07",      "pwm_id" => 0),
        33 => Dict("file_number" => "38",  "name" => "GPIO13",      "pwm_id" => 2),
        35 => Dict("file_number" => "76",  "name" => "I2S0_FS",     "pwm_id" => nothing),
        36 => Dict("file_number" => "51",  "name" => "UART1_CTS",   "pwm_id" => nothing),
        37 => Dict("file_number" => "12",  "name" => "SPI1_MOSI",   "pwm_id" => nothing),
        38 => Dict("file_number" => "77",  "name" => "I2S0_DIN",    "pwm_id" => nothing),
        40 => Dict("file_number" => "78",  "name" => "I2S0_DOUT",   "pwm_id" => nothing),
                                )
end