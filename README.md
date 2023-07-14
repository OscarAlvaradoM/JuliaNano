# JuliaNano
En este repositorio se encuentra el código y la documentación para la interacción de Julia con los pines GPIO de la Jetson Nano, así como ejemplos de uso

Trabajaremos desde `Pluto` para hacerlo màs interactivo, por lo que habrá que instalarlo de la siguiente manera en la Jetson Nano:

Desde el REPL de Julia ejecutemos el siguiente comando para la instalación:

`] add Pluto`

posteriormente importamos la paquetería:

`import Pluto`

## PWM

Hay que ejecutar el siguiente comando para poder activar los pines PWM:

`$ sudo /opt/nvidia/jetson-io/jetson-io.py`

El siguiente [video](#https://www.youtube.com/watch?v=eImDQ0PVu2Y) lo explica muy bien.