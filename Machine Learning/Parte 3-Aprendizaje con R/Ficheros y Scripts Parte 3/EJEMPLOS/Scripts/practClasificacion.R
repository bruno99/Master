#########################
# EJERCICIO KNN
###########################

#1) Cargar datos de UC Irvine Machine Learning Repository

iris <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"), header = FALSE)

#Si queremos a?adir cabecera a los datos basta con ejecutar:
names(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")

#2) Inspeccionando los datos: Una vez cargados los datos en RStudio
iris
head(iris)
str(iris)
# Un vistazo al atributo Species nos muestra la divisi?n de las especies de flores en 50-50-50:
table(iris$Species)
#Divisi?n de flores porcentualmente. 
round(prop.table(table(iris$Species)) * 100, digits = 1)

# Diagramas de dispersi?n (scatter plots)

# Setosa (negro),Virginica (verde) y Versicolor (rojo)
plot(iris$Sepal.Length,iris$Sepal.Width,col=factor(iris$Species))
plot(iris$Petal.Length,iris$Petal.Width,col=factor(iris$Species))

#funci?n summary(). 
summary(iris)

#Refinar el resultado de summary con atributos espec?ficos
summary(iris[c("Petal.Width", "Sepal.Width")])

#3) Hacia donde dirigirnos. ya hemos estudiado como son los datos. ?qu? cosas podr?amos hacer con ellos? KNN en este ejemplo

#4) Instalar los paquetes adecuados. 
#Para ilustrar el algoritmo KNN este ejemplo trabaja con el paquete class.

library(class)

#Si no tenemos el paquete instalado habr? que instalarlo previamente:
#install.packages('class')

#5) Preparar los datos: Normalizaci?n

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }
iris_norm <- as.data.frame(lapply(iris[1:4], normalize))
summary(iris_norm)

#Conjuntos de Training y test 

set.seed(1234)
ind <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67, 0.33))
iris.training <- iris[ind==1, 1:4]
iris.test <- iris[ind==2, 1:4]
iris.trainLabels <- iris[ind==1, 5]
iris.testLabels <- iris[ind==2, 5]

#6)Clasificador: Modelo KNN
iris_pred <- knn(train = iris.training, test = iris.test, cl = iris.trainLabels, k=3)
iris_pred
#podemos compararlas con las test:
iris.testLabels

#Otra forma de compararlas: cbind(iris_pred,iris.testLabels)

#7) Evaluaci?n del modelo
#Instalar gmodels si no lo tenemos instalado
#install.packages("gmodels")

library(gmodels)
CrossTable(x = iris.testLabels, y = iris_pred, prop.chisq=FALSE)

