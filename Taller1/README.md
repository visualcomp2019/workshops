# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Lizzy Tengana Hurtado | lizzyt10h |
| Laura Morales Ariza | lgmoralesa |
| Sergio Sanchez | serbatero |

## Discusión

En este taller se parte de una imagen original sobre la cual se aplicaron una serie de transformaciones explicadas a continaución.

* En primer lugar se realizó una transformación de la imagen original a escala de grises. El procedimiento utilizado consistió en recorrer la imagen pixel a pixel, cambiando el color por el valor obtendio al calcular el promedio de los valores RGB de cada pixel.

* La siguiente imagen corresponde a una segmentación a blanco y negro. Para ello se usó el histograma de la imagen en escala de grises, esto debido a que en este histograma se aprecia mejor los cambios abruptos de color. Se usó un valor de límite y con respecto a él se referencio la diferencia de color con cada pixel para ser pintado de blanco o negro.

* Se implementaron dos mascaras de convolución: 1. Corresponde a un kernel denominado Sharpen que genera una imagen que resalta los bordes de la imagen original. 2. Corresponde a la aplicación de la mascara de BoxBlur en el que cada píxel en la imagen resultante tiene un valor igual al valor promedio de sus píxeles vecinos en la imagen original y el resultado es una con desenfoque.

* Finalmente, se muestran dos histogramas, uno correspondiente a la imagen original y el segundo corresponde a la imagen con la trasformación de escala de grises, cada uno debajo de su imagen respectiva. Para ello, se recorrió la imagen pixel a pixel y se usó el metodo brightness() para dibujar el histograma obteniendo el valor de color de cada uno.


## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 28/4/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
