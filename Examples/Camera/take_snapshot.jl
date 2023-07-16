"""
    gstreamer_pipeline([sensor_id::Int=0[, capture_width::Int=1920[, capture_height::Int=1080[, display_width::Int=960[, display_height::Int=540[, framerate::Int=30[, flip_method::Int=0]]]]]]])

Constructs a GStreamer pipeline string for camera capture using the nvarguscamerasrc plugin.

# Arguments
- `sensor_id::Int`: ID of the camera sensor to use (default: 0).
- `capture_width::Int`: Width of the captured video frame (default: 1920).
- `capture_height::Int`: Height of the captured video frame (default: 1080).
- `display_width::Int`: Width of the displayed video frame (default: 960).
- `display_height::Int`: Height of the displayed video frame (default: 540).
- `framerate::Int`: Framerate of the captured video (default: 30).
- `flip_method::Int`: Flip method for the video frame (default: 0).

# Returns
- `pipeline::String`: GStreamer pipeline string for camera capture.

"""
function gstreamer_pipeline(
    sensor_id::Int=0,
    capture_width::Int=1920,
    capture_height::Int=1080,
    display_width::Int=960,
    display_height::Int=540,
    framerate::Int=30;
    flip_method::Int=0
)::String
    return """
    nvarguscamerasrc sensor-id=$sensor_id ! video/x-raw(memory:NVMM)
    """
end
#, width=(int)$capture_width, height=(int)$capture_height, framerate=(fraction)$framerate/1 ! nvvidconv flip-method=$flip_method ! video/x-raw, width=(int)$display_width, height=(int)$display_height, format=(string)BGRx ! videoconvert ! video/x-raw, format=(string)BGR ! appsink
function show_camera()
    pipeline = gstreamer_pipeline(flip_method=0)
    run(`gst-launch-1.0 $pipeline`)
end

# function show_camera()
#     window_title = "CSI Camera"
    
#     # To flip the image, modify the flip_method parameter (0 and 2 are the most common)
#     video_capture = VideoIO.open(gstreamer_pipeline(flip_method=0))
#     #ret, img = OpenCV.read(video_capture)
#     if !isnothing(video_capture)
#         try
#             while !eof(video_capture)
#                 frame = read(video_capture)
                
#                 if isnothing(window) || !isopen(window)
#                     window = Images.imshow(frame, name=window_title)
#                 else
#                     Images.imshow(window, frame)
#                 end
                
#                 keyCode = waitkey(10) & 0xFF
#                 # Stop the program on the ESC key or 'q'
#                 if keyCode == 27 || keyCode == 'q'
#                     break
#                 end
#             end
#         finally
#             close(video_capture)
#             if !isnothing(window)
#                 destroy!(window)
#             end
#         end
#     else
#         println("Error: Unable to open camera")
#     end
# end

# Example usage
show_camera()