include("../src/gpio.jl")
using .GPIO
using Base.Filesystem

GPIO.setmode()
path = "/sys/class/gpio/"
directories = filter(isdir, joinpath.(path, readdir(path)))

for directory in directories
    if ocursin("gpio", basename(directory))
       GPIO.cleanup(parse(Int64, directory[5:end]))
    end
end