include("../src/gpio.jl")
using .GPIO
using Base.Filesystem

GPIO.setmode()
path = "/sys/class/gpio/"
directories = filter(isdir, joinpath.(path, readdir(path)))
println(readdir(path))
println(directories)

for directory in directories
    print(basename(directory))
    
    #GPIO.cleanup(parse(Int64, match.match))
end