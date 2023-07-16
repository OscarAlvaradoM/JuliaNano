using VideoIO
using OpenCV

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
    return """\
        nvarguscamerasrc sensor-id=$sensor_id ! \
        video/x-raw(memory:NVMM), width=(int)$capture_width, height=(int)$capture_height, framerate=(fraction)$framerate/1 ! \
        nvvidconv flip-method=$flip_method ! \
        video/x-raw, width=(int)$display_width, height=(int)$display_height, format=(string)BGRx ! \
        videoconvert ! \
        video/x-raw, format=(string)BGR ! appsink\
    """
end

function show_camera()
    window_title = "CSI Camera"
    
    # To flip the image, modify the flip_method parameter (0 and 2 are the most common)
    println(gstreamer_pipeline(flip_method=0))
    video_capture = VideoCapture(gstreamer_pipeline(flip_method=0), :GSTREAMER)
    if isopen(video_capture)
        try
            cv2.namedWindow(window_title, cv2.WINDOW_AUTOSIZE)
            while true
                _, frame = read(video_capture)
                # Check to see if the user closed the window
                # Under GTK+ (Jetson Default), WND_PROP_VISIBLE does not work correctly. Under Qt it does
                # GTK - Substitute WND_PROP_AUTOSIZE to detect if window has been closed by user
                if cv2.getWindowProperty(window_title, cv2.WND_PROP_AUTOSIZE) >= 0
                    cv2.imshow(window_title, frame)
                else
                    break
                keyCode = cv2.waitKey(10) & 0xFF
                # Stop the program on the ESC key or 'q'
                if keyCode == 27 || keyCode == UInt8('q')
                    break
                end
            end
        finally
            release!(video_capture)
            cv2.destroyAllWindows()
        end
    else
        println("Error: Unable to open camera")
    end
end

# Example usage
pipeline = gstreamer_pipeline()
println(pipeline)
