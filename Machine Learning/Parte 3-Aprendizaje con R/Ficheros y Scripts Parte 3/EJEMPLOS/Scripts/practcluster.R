######################################################################
####### Script de los ejemplos de Clustering

######################################################################


##################EJEMPLO DE K-MEANS#####################################################
#Importamos los datos del fichero Libro1.txt
datoscluster <- read.delim("C:/DATOS/DATOS/Libro1.txt", header=FALSE)
#visualizando algunos datos de datoscluster
head(datoscluster)
attach(datoscluster) 

#pintamos los datos del fichero
plot(datoscluster)

#para saber los nombres de las variables del fichero
names(datoscluster)

library(cluster)
#semilla inicial

set.seed(20)

#kmeans para k=2
#20 ser?a n? m?ximo de iteraciones
k.means.fit <- kmeans(datoscluster, 2,20) #k=2

#k.means.fit contiene todos los elementos de la salida del algoritmo de cluster
attributes(k.means.fit)

#Centroides
k.means.fit$centers
#Clusters
k.means.fit$cluster
#Tama?o del cluster
k.means.fit$size
#Dibujo los clusters, cada uno de un color
plot(datoscluster,col=k.means.fit$cluster, xlab="V1",ylab="V2")
#Centroides de los clusters
points(k.means.fit$centers, col = 1:2, pch = 8, cex=2)  

# la instrucci?n points() a?ade puntos a una gr?fica existente, admite dos formas de especificar las coordenadas
# de los puntos que queremos dibujar: o bien especificando un vector x y otro y que contiene las abcisas y las ordenadas de los puntos respectivamente. O bien especificando una matriz con dos columnas, la primera contiene las abcisas mientras que la segunda las ordenadas. (?ste es el formato escogido para nuestra instrucci?n)

# ahora a?adimos a cada punto una etiqueta con el n?mero del cluster al que ha sido asignado
text(datoscluster$V1,datoscluster$V2,labels=k.means.fit$cluster,pos=4)

# Calculo de la suma de cuadrados dentro de los clusters asociada a la partici?n final en 2 grupos:
k.means.fit$withinss
scdg2=sum(k.means.fit$withinss)


#Elbow criterion

wss <- (nrow(datoscluster)-1)*sum(apply(datoscluster,2,var))
for (i in 2:10) wss[i] <- sum(kmeans(datoscluster,centers=i)$withinss)  #10 n? m?ximo de clusters a analizar 
plot(1:10, wss, type="b", xlab="N?mero de Clusters",ylab="Suma de cuadrados dentro de los clusters",main="C?lculo del n?mero ?ptimo de clusters con el criterio del codo")

     

##################EJEMPLO DE JER?RQUICO AGLOMERATIVO#####################################################
#Introducci?n de datos
x=c(0.3,0.35,0.7,0.8)
y=c(0.6,0.4,0.8,0.5)
# Formamos un vector de nombres
nombres=c("A","B","C","D")
# Juntamos las dos columnas en un data frame
xy.dat=data.frame(x,y,row.names=nombres)
#Empecemos por representar los cuatro puntos gr?ficamente: 
plot(xy.dat)
#a?ado las etiquetas de nombres:
text(xy.dat,labels=nombres,pos=4)

#Los algoritmos de clasificaci?n jer?rquica se basan en una matriz de distancia entre los puntos. Podemos calcular esta matriz en R con
# la instrucci?n dist.
dist(xy.dat)
# la instrucci?n dist admite el argumento method, que permite especificar qu? tipo de distancia entre los puntos queremos calcular

# El comando hclust utiliza una matriz de distancias proporcionada por el usuario
# para ir juntando en cada etapa los dos clusters m?s pr?ximos.
xy.hcl=hclust(dist(xy.dat))
# hclust admite como argumento method que puede tomar uno de los siguientes valores:
# "ward": m?todo de Ward, basado en una medida de la suma de cuadrados entre grupos
# "single"  single linkage (vecino m?s pr?ximo)
# "complete" complete linkage (vecino m?s lejano) (?ste es el m?todo por defecto)
# "centroid" mide la distancia entre dos grupos c?mo la distancia entre sus dos centroides,  
# "medians" etc....
# ?Qu? componentes est?n incluidos en el objeto resultante xy.hcl?
# Historial de agrupamientos con
xy.hcl$merge

# Dibujamos el dendograma:
plot(xy.hcl)
# Identificamos dos grupos:
rect.hclust(xy.hcl,k=2)
print(rect.hclust(xy.hcl,k=2)) 
#Particionar en 3 grupos:
cutree(xy.hcl,k=3) 
#Particionar en 2 y 3 grupos:
cutree(xy.hcl,k=2:3)

# A?adir al conjunto xy.dat tres columnas que contengan las asignaciones de los individuos de una partici?n en 2, 3 y 4 grupos respectivamente 
xy.dat=data.frame(xy.dat,cutree(xy.hcl,k=2:4))

#Dibujo los clusters, cada uno de un color
#para k=2
plot(xy.dat$x,xy.dat$x,col=xy.dat[1:4,3])
text(xy.dat,labels=nombres,pos=4)
#para k=3
plot(xy.dat$x,xy.dat$y,col=xy.dat[1:4,4])
text(xy.dat,labels=nombres,pos=4)
#para k=4
plot(xy.dat$x,xy.dat$y,col=xy.dat[1:4,5])
text(xy.dat,labels=nombres,pos=4)

