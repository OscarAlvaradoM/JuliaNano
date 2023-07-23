using Images, FileIO

function takesnapshot(name::String="nvcamtest"; return_image::Bool=false)
    run(`nvgstcapture-1.0 --automate --capture-auto --start-time=0 --file-name=$name`)
    if return_image
        path_img = getimagepath(name)
        return load(path_img)
    end
end

function getimagepath(name::String)::String
    semi_path_img = occursin("/", name) ? name : joinpath(pwd(), name)
    semi_path = join(split(semi_path_img, "/")[1:(end-1)], "/")
    files_in_dir = readdir(semi_path, join=true)
    path_img = files_in_dir[argmax(mtime.(files_in_dir))]
    
    return path_img
end

# Example usage
takesnapshot(; return_image=true)