#EDAD-PESO-GRASAS: ESTE ES EL QUE TODO FUNCIONA. PUESTO COMO EJEMPLO DE REGRESI?N
#importamos el fichero
EdadPesoGrasas <- read.csv("C:/DATOS/DATOS/EdadPesoGrasas.txt", sep="")

#para saber los nombres de las variables del fichero
names(EdadPesoGrasas)
#Diagramas de dispersi?n
pairs(EdadPesoGrasas)
#Matriz de coeficientes de correlaci?n
cor(EdadPesoGrasas)
#C?lculo de la recta
regresion <- lm(grasas ~ edad, data = EdadPesoGrasas)
summary(regresion)
#Dibujando los datos y recta
plot(EdadPesoGrasas$edad, EdadPesoGrasas$grasas, xlab = "Edad", ylab = "Grasas")
abline(regresion,col="blue")
#C?lculo de predicciones
nuevas.edades <- data.frame(edad = seq(30, 50))
predict(regresion, nuevas.edades)

#intervalos de confianza. Por defecto level=0.95
confint(regresion)
#intervalos de confianza cambiando el nivel de confianza
confint(regresion, level = 0.9)



#Intervalos de confianza para la respuesta media y los intervalos de predicci?n
# para la respuesta. Calculamos los tipos de intervalos para el rango de edades que va de 20 a 60 a?os
#(los de predicci?n en rojo)

nuevas.edades <- data.frame(edad = seq(20, 60))
# Grafico de dispersion y recta
plot(EdadPesoGrasas$edad, EdadPesoGrasas$grasas, xlab = "Edad", ylab = "Grasas")
abline(regresion)

# Intervalos de confianza de la respuesta media: ic es una matriz con tres
# columnas: la primera es la prediccion, las otras dos son los extremos
# del intervalo
ic <- predict(regresion, nuevas.edades, interval = "confidence")
lines(nuevas.edades$edad, ic[, 2], lty = 2)
lines(nuevas.edades$edad, ic[, 3], lty = 2)

# Intervalos de prediccion
ic <- predict(regresion, nuevas.edades, interval = "prediction")
lines(nuevas.edades$edad, ic[, 2], lty = 2, col = "red")
lines(nuevas.edades$edad, ic[, 3], lty = 2, col = "red")

# Tabla de an?lisis de la varianza de los errores
anova(regresion)

#Diagn?stico del modelo: residuos estandarizados frente a los valores ajustados
residuos <- rstandard(regresion)
valores.ajustados <- fitted(regresion)
plot(valores.ajustados, residuos)

# Hip?tesis de normalidad 
qqnorm(residuos)
qqline(residuos)


