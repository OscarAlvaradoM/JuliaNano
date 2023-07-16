include("../src/gpio.jl")
using .GPIO
using Base.Filesystem

GPIO.setmode()
path = "/sys/class/gpio/"
directories = filter(isdir, readdir(path))

numbers = Int64[]

for directory in directories
    print(directory)
    match = match(r"\d+", directory)
    println(match.match)
    if match !== nothing
        pintln("Limpiamos puerto $(match.match)")
        GPIO.cleanup(parse(Int64, match.match))
    end
end