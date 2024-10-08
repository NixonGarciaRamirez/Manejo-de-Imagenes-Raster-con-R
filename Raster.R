library(raster)


#### Creacion de un raster ###

#Puedes crear un objeto raster vacío con dimensiones definidas:

r1 <- raster(nrows=100, ncols=100, xmn=0, xmx=10)
r1

# Asignar valores aleatorios al raster vacio creado 
# anterior mente
values(r1) <- runif(ncell(r1), min=0, max=100)
# Visualizar el raster
plot(r1)

#### Cargar un archivo raster ####


#En la práctica, trabajarás con archivos raster como 
# .tif, .asc, etc. Para cargar uno de estos archivos, 
# usa la función raster():

prueba <- system.file("external/test.grd", package="raster")
url <- 'D:/NIXON/MI MUNDO PROPIO/08 SIG/R CON GEE/MODULO 6/Modulo 06/nieve.tif'
raster_file <- raster(url)
# Mostrar información del archivo cargado
print(raster_file)
# Visualizarlo
plot(raster_file)


#### Manipulacion de datos Raster ####

# Algunas operaciones comunes incluyen la 
# reclassificación, el recorte y la agregación.

# Reclassificación: Puedes reclasificar valores de un raster, 
# por ejemplo, para agrupar rangos de valores:

# Reclasificación de valores
rcl <- matrix(c(0, 50, 1, 50, 100, 2), ncol=3, byrow=TRUE)
r_reclas <- reclassify(raster_file, rcl)
plot(r_reclas)

# Recorte (Crop): Para recortar un raster a un área específica:

# Definir una extensión de recorte
ext <- extent(1, 5, 1, 5)
r_crop <- crop(r1, ext) # Esta vez lo haremos con el raster vacio creado al inicio
plot(r_crop)


# Agregación: Para cambiar la resolución del raster, puedes 
# agregar celdas usando una función estadística 
# (promedio, suma, etc.):

# Agregar celdas para reducir resolución
r_agg <- aggregate(raster_file, fact=2, fun=mean)
plot(r_agg)



# Desagregación (Disaggregate)
#Divide las celdas de un raster para aumentar su resolución.


r_disagg <- disaggregate(raster_file, fact=2)
plot(r_disagg)

#Focal : Aplica una función a una vecindad de celdas alrededor de cada celda en un raster.
w <- matrix(1, nrow=3, ncol=3)
r_focal <- focal(raster_file, w, fun=mean)
plot(r_focal)


# Máscara (Mask)
# Aplica una máscara a un raster para establecer valores como NA 
# (o un valor específico) en función de otro raster o shapefile.

library(sf)
shp_path <- "D:/NIXON/MI MUNDO PROPIO/08 SIG/R CON GEE/libreria Raster/Mask.shp"
shp <- st_read(shp_path)
plot(shp)


r_mask <- mask(raster_file, shp) #Algo a resaltar es que al principio generaba error el codigo cuando yo ponia el parametro maskvalue = NA, lo mejor es dejarlo vasio ya que el parametro NA esta por defecto
plot(r_mask)



# Recortar (Crop)

# A menudo, los datos raster se recortan y enmascaran en un solo paso para eliminar áreas no deseadas.

r_crop <- crop(raster_file, shp)
plot(r_crop) #Es algo util ya que lo recortara en un cudrado perfecto, independientemente si el shp tiene forma irregular



#  Reamostrar (Resample)
# Reamuestra un raster para que tenga la misma resolución y alineación que otro raster.
#Obviamente cuando se habla de resolucion , no se refiere a calidad en pixeles de la imagen
#se refiere a que cambia la escala con la que se esta vizualizando
#Por ejemplo, en esta linea de codigo, lo que se hara es que el recorte previamente realizado,
#se pondra a la misma distancia que del archivo raster original
r_resample <- resample( r_crop, raster_file, method='bilinear')
plot(r_resample)

# Mosaico (Mosaic): Combina varios raster en uno solo

r_mosaic <- mosaic(r1, r2, fun=mean)
plot(r_mosaic)



# Calculadora raster (Overlay): Aplica una función personalizada a los valores de varios raster.

#Lo primero a resaltar es que las capas si o si deben estar superpuestas y deben tener exactamente la misma extencion
#por ende si tu otro raster es ams grande lo ideal es que lo recortes primero
r_overlay <- overlay(r1,r1, fun=function(x, y) {x/y})
plot(r_overlay)




#### Exportacion de datos raster ####
# Guardar el raster en un nuevo archivo
writeRaster(r_agg, "D:/NIXON/MI MUNDO PROPIO/08 SIG/R CON GEE/libreria Raster/imagen_practica.tif", format="GTiff", overwrite=TRUE)

