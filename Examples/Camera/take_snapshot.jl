"""
    gstreamer_pipeline(sensor_id::Int=0, capture_width::Int=1920, capture_height::Int=1080, display_width::Int=960, display_height::Int=540, framerate::Int=30, flip_method::Int=0):Cmd

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
)
    return `nvarguscamerasrc sensor-id=$sensor_id ! 'video/x-raw(memory:NVMM), width='$capture_width', height='$capture_height', framerate='$framerate'/1' ! nvvidconv flip-method=$flip_method ! video/x-raw, width=$display_width, height=$display_height ! nvvidconv ! nvegltransform ! nveglglessink -e`
end
function takesnapshot(name::String="nvcamtest")
    # pipeline = gstreamer_pipeline(flip_method=0)
    # println(`gst-launch-1.0 $pipeline`)
    # run(`gst-launch-1.0 $pipeline`)
    run(`nvgstcapture-1.0 --automate --capture-auto filename=$name`)
    print(pwd())
    # NOTE: Use “nvgstcapture-1.0 --help” to refer supported command line options 
end

# Example usage
takesnapshot("prueba")

# gst-launch-1.0 nvarguscamerasrc sensor_id=0 ! 'video/x-raw(memory:NVMM), width=1920, height=1080, framerate=30/1' !    nvvidconv flip-method=0 ! 'video/x-raw,width=960, height=540' ! nvvidconv ! nvegltransform ! nveglglessink -e