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




#### Exportacion de datos raster ####
# Guardar el raster en un nuevo archivo
writeRaster(r_agg, "D:/NIXON/MI MUNDO PROPIO/08 SIG/R CON GEE/libreria Raster/imagen_practica.tif", format="GTiff", overwrite=TRUE)

