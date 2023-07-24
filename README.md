# JuliaNano

This repository contains the code and documentation for interacting with the GPIO pins and camera of the Jetson Nano using Julia, along with usage examples. It uses the latest available version of Julia for Jetson Nano, which is version 1.6.0 as of July 2023.

> To use this package, superuser permissions are required as it overwrites files to send and receive signals from GPIO pins.

## PWM

To activate the PWM pins, run the following command:

`$ sudo /opt/nvidia/jetson-io/jetson-io.py`

The following [video](https://www.youtube.com/watch?v=eImDQ0PVu2Y) explains it well.

To run an example as a superuser, use a command like the following:

`$ sudo env "PATH=$PATH" julia Examples/blink.jl`

In the examples, the output pins used are 12 for digital output, 32 for "analog" output, and 15 for input, but you can use other pins according to the diagram in this [link](https://forums.developer.nvidia.com/t/jetson-nano-physical-pinout-vs-gpio-list/123460).

This package is a work in progress, but contributions are welcome.