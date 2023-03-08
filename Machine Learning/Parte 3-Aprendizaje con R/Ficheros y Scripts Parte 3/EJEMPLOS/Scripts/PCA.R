#PCA con datos iris

#Cargamos los datos y listamos para ver su estructura
data(iris)
head(iris)

#Explorando nuestros datos
#Gr?fico de dispersi?n de las variables
pairs(iris[,1:4])

#Gr?fico de dispersi?n incluyendo etiquetas de las especies
#Sustituyendo etiquetas
iris.Species<-c(rep("s",50),rep("c",50),rep("v",50))
#Diagramas de dispersi?n incluyendo etiquetas
pairs(iris[,1:4],panel=function(x,y,...) text(x,y,iris.Species))

# transformada log a las variables continuas
log.ir <- log(iris[, 1:4])
# ir.spacies contiene la variable especies
ir.species <- iris[, 5]


# applicando PCA - scale = TRUE por defecto est? a FALSE
ir.pca <- prcomp(log.ir, center = TRUE,scale = TRUE)

# Miramos a ver qu? atributos devuelve el an?lisis 
attributes(ir.pca)                

# m?todo print
print(ir.pca)

#?Cu?ntas componentes principales?

ir.pca$sdev

# summary 
summary(ir.pca)

#Ahora dibujamos las dos primeras componentes principales 
plot(ir.pca$x[,1:2])

#Dos primeras componentes principales con un color para cada especie
text(ir.pca$x[ir.species=="setosa",1:2],col=2,"s") 
text(ir.pca$x[ir.species=="versicolor",1:2],col=3,"v") 
text(ir.pca$x[ir.species=="virginica",1:2],col=4,"c")


