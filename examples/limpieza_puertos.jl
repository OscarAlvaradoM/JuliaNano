include("../src/gpio.jl")
using .GPIO
using Base.Filesystem
import Base.Regex: match

GPIO.setmode()
path = "/sys/class/gpio/"
directories = filter(isdir, joinpath.(path, readdir(path)))
println(readdir(path))
println(directories)

for directory in directories
    print(directory)
    match = match(r"\d+", basename(directory))
    println(match.match)
    if match !== nothing
        pintln("Limpiamos puerto $(match.match)")
        GPIO.cleanup(parse(Int64, match.match))
    end
end