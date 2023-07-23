using Images, FileIO

function takesnapshot(name::String="nvcamtest"; return_image::Bool=false)
    run(`nvgstcapture-1.0 --automate --capture-auto --start-time=0 --file-name=$name`)
    if return_image
        if occursin("/", name)
            return load(name)
        else
            return load(joinpath(pwd(), name))
        end
    end
end

# Example usage
takesnapshot("/home/servicio1/Documentos/JuliaNano/prueba"; return_image=true)