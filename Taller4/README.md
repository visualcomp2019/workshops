# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Implementar un modelo de iluminación que combine luz ambiental con varias fuentes puntuales de luz especular y difusa. Tener presente _factores de atenuación_ para las fuentes de iluminación puntuales.
3. (grupos de dos o más) Implementar el [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|            |             |

## Informe

(elabore en este sección un informe del ejercicio realizado)
## Bump Mapping

el Bump Mapping da, lo que parece una rugosidad de la superficie sobre un objeto. puede agregar detalles minuciosos a un objeto que, de lo contrario, requeriría una gran cantidad de polígonos, lo cual reduce el rendimiento de la GPU.
El Bump Mapping es una extensión de la técnica de sombreado de Phong. En Phong Shading, la normal de la superficie se interpolaba sobre el polígono, y ese vector se usó para calcular el brillo de ese píxel. Cuando agrega la asignación de relieve, está modificando ligeramente el vector normal, basándose en la información del mapa de relieve. El ajuste del vector normal provoca cambios en el brillo de los píxeles en el polígono.
Mediante el uso de normales por fragmento, podemos engañar a la iluminación para que crea que una superficie consiste en diminutos planos (perpendiculares a los vectores normales) que le dan a la superficie un enorme impulso de detalle. Esta técnica para usar las normales por fragmento en comparación con las normales por superficie se llama bump mapping

## Entrega

Fecha límite ~~Lunes 1/7/19~~ Domingo 7/7/19 a las 24h. Sustentaciones: 10/7/19 y 11/7/19.
