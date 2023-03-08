#Lectura del fichero de datos: importar fichero

Datos.personas.frecuencias <- read.delim("D:/DATOS/Datos personas-frecuencias.txt")
View(Datos.personas.frecuencias)
attach(Datos.personas.frecuencias)

#VARIABLE Raza: variable cualitativa
#Frecuencia absoluta de razas 
tabla_raza<-table(Datos.personas.frecuencias$Raza)
tabla_raza

#Frecuencia relativa de razas
frel<-prop.table(tabla_raza)

#Diagrama de barras de frecuencias absolutas de la variable cualitativa Raza
barplot(tabla_raza,ylab="Frecuencias absolutas",main="Diagrama de barras de Razas")

#Diagrama de barras de frecuencias relativa de la variable cualitativa Raza
barplot(frel,ylab="Frecuencias relativas",main="Diagrama de barras de Equipo")

#Poligono de frecuencias absolutas de la variable cualitativa Raza
plot(tabla_raza,type="l",main=c("Poligono de frecuencias absolutas de Raza"),ylab="Frecuencias absolutas")

#Pol?gono de frecuencias relativas de la variable cualitativa Raza
plot(frel,type="l",main=c("Poligono de frecuencias relativas de Razas"),ylab="Frecuencias relativas")


#Gr?fico de puntos de la variable cualitativa Raza
dotchart(frel,labels=c("Asiatica","Blanca","Negra"), main="Gr?fico de puntos por Raza")

#Gr?fico por sectores de la variable cualitativa Raza
pie(tabla_raza,col=rainbow(6),main=c("Grafico por sectores de Razas"))


#VARIABLE Hermanos: variable cuantitativa discreta
tabla_hermanos<-table(Hermanos)
frel<-prop.table(tabla_hermanos)
fabsacum<-as.table(cumsum(tabla_hermanos))
frelacum<-as.table(cumsum(frel))

#Diagrama de barras de frecuencias absolutas de la variable cuantitativa discreta Hermanos
barplot(tabla_hermanos,ylab="Frecuencias absolutas",main="Diagrama de barras de Hermanos")

#Diagrama de barras de frecuencias absolutas acumuladas de la variable cuantitativa discreta Hermanos
barplot(fabsacum,ylab="Frecuencias absolutas acumuladas",main="Diagrama de barras de Hermanos")

#Gr?fico por sectores de la variable cuantitativa discreta Hermanos
pie(tabla_hermanos,col=rainbow(6),main=c("Grafico por sectores de Hermanos"))


#Poligono de frecuencias absolutas de la variable cuantitativa discreta Hermanos
plot(tabla_hermanos,type="l",main="Poligono de frecuencias absolutas de Hermanos",ylab="Frecuencias absolutas")

#Poligono de frecuencias absolutas acumuladas de la variable cuantitativa discreta Hermanos
plot(fabsacum,type="l",main="Poligono de frecuencias absolutas acumuladas de Hermanos",ylab="Frecuencias absolutas acumuladas")

#Gr?fico de puntos de las frecuencias absolutas de la variable cuantitativa discreta Hermanos
dotchart(tabla_hermanos,main="Graficos de puntos de Hermanos")

#Gr?fico de puntos de las frecuencias absolutas acumuladas de la variable cuantitativa discreta Hermanos
dotchart(fabsacum,main="Graficos de puntos de Hermanos")

