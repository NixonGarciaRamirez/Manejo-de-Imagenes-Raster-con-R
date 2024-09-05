# Manejo de Imagenes Raster con R

¡Claro! Aquí tienes un resumen de las herramientas de manipulación básica de datos raster que hemos estudiado con la librería **`raster`** de R:

### 1. **Recorte (Crop)**

Permite recortar un raster usando una extensión espacial o un objeto vectorial como un **shapefile**. Solo se mantienen las celdas dentro de la extensión o límite proporcionado. Es útil cuando quieres reducir el área de interés de un raster.

Ejemplo:
```r
recorte <- crop(raster_file, shp)
```

### 2. **Reclasificación (Reclassify)**

Permite reasignar valores dentro de un raster en rangos específicos, cambiando los valores de una forma más controlada. Esto se hace mediante una matriz que define los rangos y sus nuevos valores.

Ejemplo:
```r
rcl_matrix <- matrix(c(0, 50, 1, 50, 100, 2), ncol=3, byrow=TRUE)
reclass_raster <- reclassify(raster_file, rcl_matrix)
```

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
