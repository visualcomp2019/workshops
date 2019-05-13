# Taller ilusiones visuales

## Propósito

Comprender algunos aspectos fundamentales de la [inferencia inconsciente](https://github.com/VisualComputing/Cognitive) de la percepción visual humana.

## Tareas

Implementar al menos 6 ilusiones de tres tipos distintos (paradójicas, geométricas, ambiguas, etc.), al menos dos con movimiento y dos con interactividad.

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Lizzy Tengana Hurtado | lizzyt10h |
| Laura Morales Ariza | lgmoralesa |
| Sergio Sanchez Plazas | serbatero |

## Discusión

1. Complete la tabla

| Ilusión | Categoria | Referencia | Tipo de interactividad (si aplica) | URL código base (si aplica) |
|---------|-----------|------------|------------------------------------|-----------------------------|
|     Moire    |     Movimiento      |     https://wewanttolearn.wordpress.com/2015/10/07/moire-patterns/       |                                   |               https://www.openprocessing.org/sketch/348969              |
|    Stepping feet     |      Motion & Time     |      https://michaelbach.de/ot/mot-feetLin/index.html      |   mousePressed                                 |                             |
| Rotating stars | Afterimage | http://illusionoftheyear.com/2008/05/filling-in-the-afterimage-after-the-image/ | | https://processing.org/examples/regularpolygon.html https://processing.org/examples/star.html |
| Rolling texture | Cognitiva | https://i.ytimg.com/vi/whv6kFqkIVo/maxresdefault.jpg | | |
| Hering       |   Geométrica        |    https://michaelbach.de/ot/ang-hering/index.html        |    mousePressed                                |                             |
|  Munker       |    Fisiológica       |   https://michaelbach.de/ot/col-Munker/index.html         |       mousePressed: remueve las lineas intercaladas del fondo. Mover el mouse de arriba a abajo mueve las lineas del fondo en la dirección respectiva       |                             |

2. Describa brevememente las referencias estudiadas y los posibles temas en los que le gustaría profundizar

El patrón de interferencia de los círculos y las líneas forma un efecto conocido como efecto de Moiré, que produce la visualización de diferentes formas y deformaciones, en nuestro caso quisimos realizar un patrón de moiré generado por la superposición de dos patrones idénticos de círculos concéntricos.

Si bien, principalmente un efecto visual, es la capacidad de traducir espacialmente lo que le da al efecto moiré el potencial para ser aplicado en un contexto de diseño, particularmente debido a su naturaleza interactiva y la dependencia de la participación de los participantes para revelar su verdadera belleza.

La ilusión óptica basada en “stepping feet” observamos en un fondo de círculos blanco y negro, el movimiento de dos óvalos tanto vertical como horizontalmente notamos visualmente que al acercase al centro toman una ligera curva, sin embargo al quitar el fondo nos damos cuenta que los óvalos hacen su trayecto en línea recta.

El efecto "afterimage" es muy interesante ya que después de una extendida exposición a los colores de una imagen, el cerebro induce otra imagen que no está realmente presente usando los colores complementarios de la primera imagen y engañando a los receptores de la retina.

En uso de luces en Processing con funciones como directionalLight(), spotlight() o ambienLight() tiene un grado de complejidad superior, ya que entender su funcionamiento y distinguir cada efecto resulta algo confuso para principiantes, sin embargo, su utilidad es innegable porque influye considerablemente en la percepción de movimiento y es un buen tema para profundizar.

La ilusión Hering está basada en la ilusión estándar de Hering (1861) que tiene como principio la superposición de figuras que dan la percepción de que las lineas rectas se curvan. En este caso, las líneas se encuentran sobre un fondo de varios circulos que son los que generan la ilusión de curvatura. Al dar clic sobre la imagen, se revela el hecho de que las líneas rojas están completamente rectas todo el tiempo.

En la ilusión Murker se expone el efecto de los contraste de color que generan la ilusión de que los dos bloques centrales son de distintos colores (gris claro y gris oscuro) aunque realmente no sea así. Sólo hay 3 colores diferentes, el blanco y negro intercalos como lineas horizontales en el fondo y un único gris que compone los dos segmentos idénticos. 

## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 12/5/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
