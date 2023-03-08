#Lectura del fichero de datos: importar fichero

Datos.personas.frecuencias <- read.delim("D:/DATOS/Datos personas-frecuencias.txt")
View(Datos.personas.frecuencias)
attach(Datos.personas.frecuencias)

#Histograna de la variable Peso
hist(Datos.personas.frecuencias$Peso,main="Distribuci?n de personas seg?n su peso")


#Creaci?n de histograma de la variable Peso eligiendo el n?mero de contenedores
#Definiendo n?mero de contenedores del histograma
n.clases=12
#elimino NA de la variable Peso
Peso<-na.omit(Peso)
puntos=min(Peso)+(0:n.clases)*(max(Peso)-min(Peso))/n.clases
hist(Peso, breaks=puntos,col="yellow",main="Distribuci?n de personas seg?n su peso")

#Por ejemplo, para 9 clases ser?ia:
#  > n.clases=9
#> puntos=min(IMC)+(0:n.clases)*(max(IMC)-min(IMC))/n.clases
#> hist(IMC, breaks=puntos)


