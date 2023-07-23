module Camera
    using Images, FileIO

    """
        takesnapshot(name::String="nvcamtest"; return_image::Bool=false)::Union{Nothing, AbstractMatrix{<:RGB{N0f8}}}

    # Arguments
    - `name::String`: The name of the image file to be captured. Default is set to "nvcamtest".
    - `return_image::Bool`: Optional parameter to indicate whether to return the captured image as a Julia matrix. Default is false.

    # Returns
    - If return_image is true, the function returns the captured image as a Julia AbstractMatrix of RGB{N0f8}.
    - If return_image is false, the function returns nothing.
    """
    function takesnapshot(name::String="nvcamtest"; return_image::Bool=false)
        run(`nvgstcapture-1.0 --automate --capture-auto --start-time=0 --file-name=$name`)
        if return_image
            path_img = getimagepath(name)
            return load(path_img)
        end
    end

    """
        getimagepath(name::String)::String

    Obtains the full path of the most recently modified file in the directory containing the specified image file.

    # Arguments
    - `name::String`: The name of the image file (including the path if necessary) for which to find the most recently modified file.

    # Returns
    - The full path of the most recently modified file in the directory containing the specified image file.

    """
    function getimagepath(name::String)::String
        semi_path_img = occursin("/", name) ? name : joinpath(pwd(), name)
        semi_path = join(split(semi_path_img, "/")[1:(end-1)], "/")
        files_in_dir = readdir(semi_path, join=true)
        path_img = files_in_dir[argmax(mtime.(files_in_dir))]
        
        return path_img
    end
end