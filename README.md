# Manejo de Imagenes Raster con R

¡Claro! Aquí tienes un resumen de las herramientas de manipulación básica de datos raster que hemos estudiado con la librería **`raster`** de R:

### 1. **Recorte (Crop)**

Permite recortar un raster usando una extensión espacial o un objeto vectorial como un **shapefile**. Solo se mantienen las celdas dentro de la extensión o límite proporcionado. Es útil cuando quieres reducir el área de interés de un raster.

Ejemplo:
```r
recorte <- crop(raster_file, shp)
```


Algo a resaltar es que se puede utilizar un shapefile como extensión para recortar un raster con la función `crop()` de la librería `raster`. Cuando se usa un shapefile, se recorta el raster a la extensión espacial del shapefile, pero solo se considerará la extensión (el límite rectangular) del shapefile y no la geometría precisa. Para recortar un raster siguiendo exactamente la forma del shapefile, debes usar la función `mask()` después de `crop()`.

Aquí te muestro cómo hacerlo:

**Recortar usando un shapefile (solo extensión)**
Primero, carga el shapefile y úsalo directamente en `crop()`:

```r
library(raster)
library(rgdal)

# Cargar el raster y el shapefile
r <- raster("ruta/al/archivo_raster.tif")
shape <- shapefile("ruta/al/shapefile.shp")

# Recortar el raster usando la extensión del shapefile
r_crop <- crop(r, shape)

# Visualizar el raster recortado
plot(r_crop)
plot(shape, add=TRUE)
```

**Recortar y enmascarar (crop + mask) usando un shapefile**
Para recortar el raster siguiendo la geometría exacta del shapefile:

```r
# Recortar el raster a la extensión del shapefile
r_crop <- crop(r, shape)

# Enmascarar el raster para que siga exactamente la forma del shapefile
r_mask <- mask(r_crop, shape)

# Visualizar el resultado
plot(r_mask)
plot(shape, add=TRUE)
```

### Explicación
- **`crop()`**: Recorta el raster a la extensión espacial (rectángulo) del shapefile.
- **`mask()`**: Aplica el shapefile como una máscara, asignando `NA` a todas las celdas fuera de la geometría del shapefile.

Esto te permite trabajar con la porción del raster que se encuentra dentro de la forma exacta definida por el shapefile.



### 2. **Reclasificación (Reclassify)**

Permite reasignar valores dentro de un raster en rangos específicos, cambiando los valores de una forma más controlada. Esto se hace mediante una matriz que define los rangos y sus nuevos valores.

Ejemplo:
```r
rcl_matrix <- matrix(c(0, 50, 1, 50, 100, 2), ncol=3, byrow=TRUE)
reclass_raster <- reclassify(raster_file, rcl_matrix)
```

¡Claro! La función `matrix()` en R se usa para crear matrices, y en el contexto de la reclasificación con la función `reclassify()` de la librería `raster`, define cómo se transformarán los valores originales del raster.

### Descomposición del código:

```r
matrix(c(0, 50, 1, 50, 100, 2), ncol=3, byrow=TRUE)
```

- **`c(0, 50, 1, 50, 100, 2)`**: Este vector define los valores que se usarán para rellenar la matriz. En este caso, son seis números: `0`, `50`, `1`, `50`, `100`, y `2`.
  
- **`ncol=3`**: Indica que la matriz tendrá 3 columnas. Como se tienen 6 valores, esto resultará en una matriz de 2 filas y 3 columnas.

- **`byrow=TRUE`**: Significa que los valores se llenarán por filas (en lugar de por columnas). Es decir, los primeros tres números irán en la primera fila y los siguientes tres en la segunda.

### Resultado
El código anterior crea la siguiente matriz:

```
     [,1] [,2] [,3]
[1,]    0   50    1
[2,]   50  100    2
```

### Interpretación en la reclasificación

En la función `reclassify()`, esta matriz se usa para transformar los valores del raster de acuerdo con los rangos especificados:

- **Columna 1 (`[,1]`)**: Define el límite inferior de cada rango.
- **Columna 2 (`[,2]`)**: Define el límite superior de cada rango.
- **Columna 3 (`[,3]`)**: Define el nuevo valor que se asignará a todas las celdas del raster cuyos valores originales caen dentro de los rangos especificados en las primeras dos columnas.

#### En este ejemplo:
1. **Rango de 0 a 50**:
   - Todas las celdas del raster que tienen un valor entre 0 y 50 (incluyendo ambos) serán asignadas al valor `1`.
2. **Rango de 50 a 100**:
   - Todas las celdas con valores entre 50 y 100 (excluyendo 50) serán asignadas al valor `2`.

#### Ejemplo con un raster
Supongamos que tienes un raster con los siguientes valores:

```
  10  20  30
  55  70  85
  45  60  75
```

Después de aplicar la reclasificación usando la matriz anterior, los valores del raster se transformarían en:

```
  1  1  1
  2  2  2
  1  2  2
```

Esto significa que los valores originales de `10`, `20`, y `30` se transformaron en `1` porque estaban en el rango de `0-50`, y los valores de `55`, `70`, y `85` se transformaron en `2` porque estaban en el rango de `50-100`.

### Resumen
La matriz usada en la función `reclassify()` especifica cómo deben transformarse los valores del raster, basándose en los rangos de valores. Cada fila de la matriz define un rango de valores originales y el nuevo valor que se asignará a ese rango en el raster resultante.


### 3. **Resampleo (Resample)**

Se utiliza cuando dos capas raster tienen diferentes resoluciones o alineaciones. Permite ajustar un raster para que coincida con otro en términos de extensión, tamaño de celda y resolución.

Ejemplo:
```r
resampled_raster <- resample(raster_file, target_raster, method="bilinear")
```

### 4. **Máscara (Mask)**

Esta herramienta aplica una máscara sobre un raster utilizando un shapefile o un segundo raster. Las celdas fuera de la región delimitada por la máscara son asignadas a `NA`. Es útil para eliminar áreas no deseadas de análisis.

Ejemplo:
```r
masked_raster <- mask(raster_file, shp)
```

### Ejemplo:::
### Imagina lo siguiente:

Tienes un **raster** que representa una imagen satelital de un área geográfica amplia, y quieres analizar solo la parte del raster que corresponde a un parque natural. Para ello, tienes un **shapefile** que delimita el área del parque.

### ¿Qué problema resuelve `mask()`?

Si solo quieres trabajar con la parte del raster que está dentro del parque (por ejemplo, calcular la vegetación o analizar la topografía solo dentro del parque), necesitas "enmascarar" las partes del raster que están fuera de los límites del parque. Aquí es donde entra `mask()`.

### Explicación con un ejemplo:

1. **Raster original (imaginario):**

   Supongamos que tienes un raster que muestra elevaciones de un terreno en una cuadrícula 5x5:

   ```
   100  110  120  130  140
   90   100  110  120  130
   80   90   100  110  120
   70   80   90   100  110
   60   70   80   90   100
   ```

2. **Shapefile del parque (imaginario):**

   Ahora, imagina que tu parque natural cubre solo las celdas centrales del raster, delimitadas por este rectángulo:

   ```
   90   100  110  120  130
   80   90  (100)(110)(120)
   70   80  (90) (100)(110)
   60   70   80   90   100
   ```

   Las celdas marcadas con paréntesis `( )` están dentro del parque.

3. **Uso de `mask()`:**

   Cuando aplicas `mask()` con el shapefile del parque, el raster resultante será:

   ```
   NA   NA   NA   NA   NA
   NA   NA  100  110  120
   NA   NA   90  100  110
   NA   NA   NA   NA   NA
   NA   NA   NA   NA   NA
   ```

   - **`NA`**: Indica celdas fuera de los límites del parque (enmascaradas).
   - **Valores originales**: Solo permanecen las celdas dentro del parque.

### ¿Para qué sirve `mask()`?

1. **Focalizar análisis**: Si solo te interesa analizar o visualizar una parte específica del raster (en este caso, el área dentro del parque), `mask()` te permite aislar esa parte y trabajar únicamente con ella.

2. **Eliminar datos irrelevantes**: Puedes eliminar datos de áreas que no te interesan o que podrían interferir en tu análisis.

3. **Preparación de datos**: Es una herramienta crucial para preparar tus datos raster antes de realizar cálculos, modelados o visualizaciones centradas en áreas específicas.

### Resumen
La función `mask()` te ayuda a extraer solo la porción del raster que está dentro de una "máscara" definida (como un shapefile o un segundo raster), enmascarando todo lo demás (es decir, asignándole `NA` o valores específicos). Esto es útil cuando quieres centrarte en una región específica o eliminar datos irrelevantes de tu análisis.




### 5. **Calculadora Raster (Overlay)**

La herramienta **Calculadora raster** en la librería `raster` de R, conocida como **Overlay**, es extremadamente útil para realizar operaciones matemáticas entre dos o más capas raster. Este proceso se utiliza para combinar datos de varias capas raster aplicando funciones específicas, como suma, resta, multiplicación, división o cualquier operación matemática que desees.

Ejemplo de resta entre dos capas:
```r
water_balance <- overlay(precipitation_raster, evapotranspiration_raster, fun=function(p, e) { p - e })
```

### ¿Qué es exactamente "Overlay" o la Calculadora Raster?

"Overlay" significa superponer dos o más capas raster para realizar cálculos celda por celda. Cada celda de una capa se alinea con las celdas correspondientes de las otras capas, y luego se ejecuta una operación matemática entre los valores de las celdas alineadas. 

Es como tomar dos hojas de papel con números y, al superponerlas, sumar o aplicar otra operación entre los números en las mismas posiciones de ambas hojas.

### ¿Cómo funciona?

La función `overlay()` permite realizar estas operaciones con una sintaxis simple en R. Puedes utilizar funciones matemáticas básicas o incluso definir tus propias funciones personalizadas para aplicar sobre los valores de las celdas de múltiples capas raster.

### Ejemplo básico

Supongamos que tienes dos capas raster, una que representa la **precipitación** y otra que representa la **evapotranspiración** en una región. Si quieres calcular el **balance hídrico** (precipitación menos evapotranspiración) en cada celda, usarías `overlay()`.

```r
# Cargar las capas raster
precipitation <- raster("ruta/a/precipitation.tif")
evapotranspiration <- raster("ruta/a/evapotranspiration.tif")

# Aplicar la operación celda por celda (balance hídrico)
water_balance <- overlay(precipitation, evapotranspiration, fun = function(precip, evap) { precip - evap })

# Visualizar el resultado
plot(water_balance)
```

### ¿Qué hace este código?

1. **`raster()`**: Carga dos capas raster desde archivos TIFF.
2. **`overlay()`**: Toma las dos capas raster y aplica la función matemática definida (en este caso, resta de precipitación menos evapotranspiración).
3. **`plot()`**: Muestra el resultado en un gráfico.

### Parámetros de la función `overlay()`

- **`x, y, z,...`**: Los objetos raster que deseas superponer. Puedes usar dos, tres o más capas raster.
- **`fun`**: Es la función que defines para aplicar a los valores de las celdas. Puede ser una operación matemática básica o una función personalizada.
- **`...`**: Otros argumentos opcionales.

### Ejemplo con una operación más compleja

Imagina que quieres calcular el **índice de vegetación NDVI** utilizando las bandas espectrales de un satélite. El NDVI se calcula de la siguiente manera:

\[
NDVI = \frac{(NIR - RED)}{(NIR + RED)}
\]

Si tienes dos capas raster, una para la banda infrarroja cercana (NIR) y otra para la banda roja (RED), el código sería:

```r
# Cargar las bandas del satélite
nir <- raster("ruta/a/nir_band.tif")
red <- raster("ruta/a/red_band.tif")

# Calcular el NDVI usando la función overlay
ndvi <- overlay(nir, red, fun = function(nir_val, red_val) { (nir_val - red_val) / (nir_val + red_val) })

# Visualizar el resultado
plot(ndvi)
```

### Operaciones más avanzadas con varias capas

Puedes combinar más de dos capas raster en la misma operación. Por ejemplo, si tienes tres capas de temperatura tomadas en diferentes momentos del día y deseas calcular el **promedio diario**:

```r
# Cargar las tres capas de temperatura
temp_morning <- raster("ruta/a/temperature_morning.tif")
temp_afternoon <- raster("ruta/a/temperature_afternoon.tif")
temp_evening <- raster("ruta/a/temperature_evening.tif")

# Calcular el promedio diario usando overlay
average_temp <- overlay(temp_morning, temp_afternoon, temp_evening, fun = function(morn, aft, eve) {
  (morn + aft + eve) / 3
})

# Visualizar el resultado
plot(average_temp)
```

### Ventajas del uso de `overlay()`

1. **Procesamiento celda por celda**: Permite realizar cálculos en cada celda con precisión y con múltiples capas a la vez.
2. **Flexibilidad**: Puedes aplicar cualquier tipo de operación, desde las más simples como suma o resta, hasta operaciones matemáticas personalizadas.
3. **Manejo eficiente de grandes datos**: `overlay()` está optimizado para manejar datos raster grandes, lo que te permite trabajar con grandes volúmenes de datos geoespaciales.

### Resumen de calculadora raster

La **Calculadora raster (Overlay)** es una herramienta poderosa para realizar operaciones matemáticas entre dos o más capas raster. Te permite combinar datos de diversas fuentes, aplicar funciones personalizadas y analizar los resultados celda por celda, lo que es esencial para tareas de análisis geoespacial complejas.



### Resumen Final:

- **Crop**: Recorta el raster a una región específica.
- **Reclassify**: Cambia los valores de un raster dentro de rangos definidos.
- **Resample**: Ajusta un raster para que coincida en resolución y extensión con otro.
- **Mask**: Aplica una máscara (usando un shapefile o raster) para eliminar áreas no deseadas.
- **Overlay**: Realiza operaciones matemáticas celda por celda entre varias capas raster.

Estas herramientas son fundamentales para el análisis espacial en R, permitiéndote procesar y analizar datos raster de manera eficiente y flexible.
