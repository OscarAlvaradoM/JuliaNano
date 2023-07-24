### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 7e4a9db4-1178-4def-ae73-40d6470fab7d
# ╠═╡ show_logs = false
begin
	import Pkg
	Pkg.add("ImageIO")
	Pkg.add("Images")
	Pkg.add("PlutoUI")
	using Images, ImageIO, PlutoUI
end

# ╔═╡ 1d01f2ce-2f03-401e-8327-bbdf569de8d5
begin
	include("src/gpio.jl")
	include("src/camera.jl")
	using .GPIO
	using .Camera
end

# ╔═╡ 423c7f7f-6a52-4445-848f-ea656798d8ed
md"""
# 🔦 Interacting with reality: Julia and Jetson Nano 📷
"""

# ╔═╡ bf754b30-1883-11ee-34ff-294a667bd835
md"""
## 🔅 Simple Output
"""

# ╔═╡ 1a9eaf43-220d-49b1-b24b-ce1ad289dc94
begin
	function blink(channel::Int, speed::Number)
		GPIO.setmode() # Set the GPIO
		GPIO.setup(channel, "OUT", GPIO.HIGH) # Set the channel as an output pin
	
		try
			for _ in 1:(((1-speed)*(-50) + 55)/2)
				GPIO.output(channel, GPIO.HIGH) # Set the pin to HIGH state
				sleep(1 - speed) # Delay for ON state
				GPIO.output(channel, GPIO.LOW) # Set the pin to LOW state
				sleep(1 - speed) # Delay for OFF state
			end
		finally
			GPIO.output(channel, GPIO.LOW) # Ensure the pin is set to LOW state
			GPIO.cleanup() # Clean up the GPIO resources
		end
	end
	
	function input(channel::Int)
	    prev_value = "" # Store the previous input value for comparison
		GPIO.setmode() # Set the GPIO mode
		GPIO.setup(channel, "IN") # Set the input channel as an input pin
		dict = Dict("1\n" => "🌞", "0\n" => "🌑")
	    try
	        while true
	            value = GPIO.input(channel) # Read the value from the input channel
	            if value != prev_value # Check if the input value has changed
	                if value == GPIO.HIGH
	                    value_str = "HIGH"
	                else
	                    value_str = "LOW"
	                end
	                prev_value = value  # Update the previous value to the current value
	            end
	            sleep(1) # Delay for smooth operation
	            print("$(dict[prev_value]) \r") # Print the previous value
				flush(stdout)
	        end
	    finally
	        GPIO.cleanup() # Clean up the GPIO resources
	    end
	end

	function inout(in_channel::Int, out_channel::Int)
	    prev_value = "" # Store the previous input value for comparison
		GPIO.setmode() # Set the GPIO mode
		GPIO.setup(in_channel, "IN") # Set the input channel as an input pin
	    GPIO.setup(out_channel, "OUT") # Set the output channel as an output pin
	    try
	        while true
	            value = GPIO.input(in_channel) # Read the value from the input channel
	            if value != prev_value # Check if the input value has changed
	                GPIO.output(out_channel, value) # Set the output channel value
	                prev_value = value # Update the previous value to the current value
	            end
	            sleep(0.1) # Delay for smooth operation
	        end
	    finally
	        GPIO.cleanup() # Clean up the GPIO resources
	    end
	end
end

# ╔═╡ 753d64b8-c25f-41a7-91ea-279688744d43
@bind speed html"<input type=range min=0 max=0.9 step=0.1>"

# ╔═╡ b79fce00-f466-4eb3-8ba2-c4d7654a14d0
# ╠═╡ disabled = true
#=╠═╡
begin
	output_pin = 12
	blink(output_pin, speed);
end
  ╠═╡ =#

# ╔═╡ 36eb98c9-5090-4ba9-a53c-cab7e8afab75
md"""
## 🔘 Simple input
"""

# ╔═╡ d8dbfd4d-f788-4458-a758-54c650563c23
# ╠═╡ show_logs = false
# ╠═╡ disabled = true
#=╠═╡
begin
	input_pin = 15
	input(input_pin)
end
  ╠═╡ =#

# ╔═╡ a9471428-2922-4981-bf4a-361f95bfc51a
md"""
## 🔦 Input - Output
"""

# ╔═╡ 81dc1981-9359-4ba8-83d2-32083c6f5778
# ╠═╡ disabled = true
#=╠═╡
begin
	input_pin = 15
	output_pin = 12
	inout(input_pin, output_pin)
end
  ╠═╡ =#

# ╔═╡ 66578cfe-5060-4cdf-adac-de51959ae608
md"""
## 🌔 PWM ("Analog") Output
"""

# ╔═╡ 209945a3-eb62-4c99-9b9f-7c30d3326fc9
begin
	brightness = @bind x html"<input type=range min=0 max=55 step=5>"
	md"""
	### Brightness of the light
		
	 🌔 : $(brightness)
	"""
end

# ╔═╡ a0b6c294-4612-404f-8000-fe4d238e82d7
# ╠═╡ show_logs = false
begin
	channel = 32
	GPIO.setmode() # Set the GPIO mode
	pwm = GPIO.PWM(channel, 50) # Create a PWM object with the specified channel and frequency
	GPIO.start(pwm, 5)
end

# ╔═╡ 6dfefa97-8073-4f0f-a7b9-6f14514cdfb1
# ╠═╡ disabled = true
#=╠═╡
GPIO.changedutycycle(pwm, x) # Change the duty cycle
  ╠═╡ =#

# ╔═╡ 891fe1bf-b5a5-4576-aa87-575ec0c90f6f
md"""
## 📷 Camera
"""

# ╔═╡ 29bcfa0f-1c9c-41b4-9933-0805fed7986e
@bind go Button("Take picture!")

# ╔═╡ e5e07b93-3049-40b4-b5c0-f24a28a14d67
# ╠═╡ show_logs = false
# ╠═╡ disabled = true
#=╠═╡
begin
	go
	img = Camera.takesnapshot(; return_image=true);
	julia_logo = load("julia.png")
	new_size = 70
	julia_logo = imresize(julia_logo, (new_size, new_size))
	img[end-(new_size-1):end, end-(new_size-1):end] = julia_logo
	img
end
  ╠═╡ =#

# ╔═╡ e6a1fb16-37a2-4fec-a25d-4eb6a7034540
md"""
### 🔄 Rotate image
"""

# ╔═╡ 268b2660-bad9-425b-b894-4fc8c5cc3f70
# ╠═╡ disabled = true
#=╠═╡
@bind rotation Select([0, 90, 180, 270])
  ╠═╡ =#

# ╔═╡ fcccbe9c-a267-4799-9c9a-2acb9351dcdf
#=╠═╡
imrotate(img, π*rotation/180)
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─423c7f7f-6a52-4445-848f-ea656798d8ed
# ╟─7e4a9db4-1178-4def-ae73-40d6470fab7d
# ╟─1d01f2ce-2f03-401e-8327-bbdf569de8d5
# ╟─bf754b30-1883-11ee-34ff-294a667bd835
# ╟─1a9eaf43-220d-49b1-b24b-ce1ad289dc94
# ╠═753d64b8-c25f-41a7-91ea-279688744d43
# ╠═b79fce00-f466-4eb3-8ba2-c4d7654a14d0
# ╟─36eb98c9-5090-4ba9-a53c-cab7e8afab75
# ╟─d8dbfd4d-f788-4458-a758-54c650563c23
# ╟─a9471428-2922-4981-bf4a-361f95bfc51a
# ╠═81dc1981-9359-4ba8-83d2-32083c6f5778
# ╟─66578cfe-5060-4cdf-adac-de51959ae608
# ╟─209945a3-eb62-4c99-9b9f-7c30d3326fc9
# ╟─a0b6c294-4612-404f-8000-fe4d238e82d7
# ╠═6dfefa97-8073-4f0f-a7b9-6f14514cdfb1
# ╟─891fe1bf-b5a5-4576-aa87-575ec0c90f6f
# ╟─29bcfa0f-1c9c-41b4-9933-0805fed7986e
# ╠═e5e07b93-3049-40b4-b5c0-f24a28a14d67
# ╟─e6a1fb16-37a2-4fec-a25d-4eb6a7034540
# ╟─268b2660-bad9-425b-b894-4fc8c5cc3f70
# ╠═fcccbe9c-a267-4799-9c9a-2acb9351dcdf
