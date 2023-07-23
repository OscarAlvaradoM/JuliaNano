using Images, FileIO

function takesnapshot(name::String="nvcamtest"; return_image::Bool=false)
    run(`nvgstcapture-1.0 --automate --capture-auto --file-name=$name`)
    if return_image
        if "/" in name
            return load(name)
        else
            return load(joinpath(pwd(), name))
        end
    end
end

# Example usage
takesnapshot("prueba"; return_image=true)