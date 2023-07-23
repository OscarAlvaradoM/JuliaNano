include("../../src/camera.jl")
using .Camera

img = Camera.takesnapshot(; return_image=true)