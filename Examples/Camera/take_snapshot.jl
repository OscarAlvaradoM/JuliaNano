using Images, FileIO

function takesnapshot(name::String="nvcamtest"; return_image::Bool=false)
    run(`nvgstcapture-1.0 --automate --capture-auto --file-name=$name`)
    if return_image
        if occursin("/", name)
            return load(name)
        else
            return load(joinpath(pwd(), name))
        end
    end
end

# Example usage
takesnapshot("prueba.jpg"; return_image=true)