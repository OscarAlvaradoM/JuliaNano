### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 6dd46bd2-28f8-4bbb-8092-1b7ef596ecb9
using VideoIO

# ╔═╡ dd6fbe09-d2cb-42be-a2d2-10e0095240a8
using Images

# ╔═╡ 524d8b52-74e4-4150-8af7-9bcfed384ca1
function gstreamer_pipeline(
    sensor_id=0,
    capture_width=1920,
    capture_height=1080,
    display_width=960,
    display_height=540,
    framerate=30;
    flip_method=0
)
    return """
        nvarguscamerasr
        """
end

# ╔═╡ 400101b6-fe19-4e0c-8da2-ce1e8c16a3e6
function show_camera()
    window_title = "CSI Camera"
    flip_method = 0

    # To flip the image, modify the flip_method parameter (0 and 2 are the most common)
    println(gstreamer_pipeline(flip_method=flip_method))
    video_capture = VideoIO.open(gstreamer_pipeline(flip_method=flip_method))
    
    if VideoIO.isopen(video_capture)
        try
            while !VideoIO.eof(video_capture)
                frame = VideoIO.read(video_capture)
                
                # Display the frame
                display(frame, title=window_title)
                
                # Check for user input
                key = Images.getkey()
                
                # Stop the program on the ESC key or 'q'
                if key == 27 || key == 'q'
                    break
                end
            end
        finally
            VideoIO.close(video_capture)
        end
    else
        println("Error: Unable to open camera")
    end
end

# ╔═╡ 6ca29fa2-c5f0-4b92-9ba7-c741ddb578b1
show_camera()

# ╔═╡ Cell order:
# ╠═6dd46bd2-28f8-4bbb-8092-1b7ef596ecb9
# ╠═dd6fbe09-d2cb-42be-a2d2-10e0095240a8
# ╠═524d8b52-74e4-4150-8af7-9bcfed384ca1
# ╠═400101b6-fe19-4e0c-8da2-ce1e8c16a3e6
# ╠═6ca29fa2-c5f0-4b92-9ba7-c741ddb578b1
