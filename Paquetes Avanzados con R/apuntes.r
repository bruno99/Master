#-----------------------------------------------------------
# INTRODUCCIÓN
#-----------------------------------------------------------
# data.table es uno de los paquetes más interesantes y populares del 
# ecosistema R. Creado y mantenido por Matt Dawle (forma parte de H2O.ai).

# Es una extensión (más potente) del concepto de data.frame.

# Cuando un data.frame se convierte en data.table la clase del objeto
# data.frame se extiende a una nueva como data.table.

# Esta extensión es muy útil y potente especialmente para grandes
# conjuntos de datos. Para data.frames muy extensos (tanto en número de
# filas como de columnas).

# Sobre un data.table puedo realizar operaciones equivalentes a consultas
# SQL: selecciones, agrupaciones, etc, sin necesidad de otros paquetes 
# adicionales.

# Al principio, cuando uno está acostumbrado a trabajar con un data.frame
# tiende a realizar operaciones que no tienen el mismo significado sobre
# un data.table

# De este paquete existe una "CheatSheet" (Guía Rápida) que es muy recomendable
# tener a mano durante los siguientes ejercicios.
# https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf

#-----------------------------------------------------------------
# La idea FUNDAMENTAL para trabajar con data.table es la siguiente
# DT[ i, j, by]
# Sobre un data.table podemos escoger ("i") filas, 
# calcular sobre ("j") columnas 
# y agrupar por ("by") los valores diferentes de una o varias columnas
#-----------------------------------------------------------------

#-----------------------------------------------------------
# COMENZAMOS .... 
#-----------------------------------------------------------

# Instalamos el paquete - La versión disponible es la 1.10.4
install.packages("data.table")
# Cargamos el paquete
library(data.table)

# Vamos a instalar también este paquete "ggplot2movies".
# Lo usaremos como ejemplo.
install.packages("ggplot2movies")
# Cargamos el paquete
library(ggplot2movies)

# Al cargar el paquete ggplot2movies automáticamente tendremos disponible
# el conjunto "movies".

# Vamos a ver un conjunto de características de movies

# Su estructura
str(movies)
# Tiene clase 'tbl_df', 'tbl' y 'data.frame'....
# Ya veremos lo que quiere decir eso de 'tbl_df' y 'tbl'.

# Su dimensión
dim(movies) 
# Es un conjunto grandecito...: 58788 filas y 24 columnas.

# Veamos sus primeras filas...
head(movies)

# El significado de las variables lo vemos en la ayuda del propio paqeute
help(movies)

# Título, año, longitud en minutos, presupuesto, rating, votos....
# Y codificado con ceros y unos aparece si es Acción, Comedia, Drama, etc....

#-----------------------------------------------------------
# OPERACIONES con filas y columnas 
#-----------------------------------------------------------

# Lo primero que vamos a hacer es convertir "movies" en un data.table
# El resultado de la conversión lo voy a llamar "movDT"
# La conversión la hacemos con as.data.table()

movDT <- as.data.table(movies)

# Comprobamos la clase
class(movDT)

# El resultado es "data.table" "data.frame"
# Tiene las dos clases, como data.frame y como data.table
# La conversión ha sido correcta.

# ¿Cómo seleccionar filas?
movDT[ 1:10 ]
# Esto con un data.frame no obtendríamos el mismo resultado...

# ¿Como seleccionar una columna en particular?
movDT[, year ]
# Fijaros en la "coma". Todas las filas, pero la columna "year"
# Podemos seleccionar varias a la vez
movDT[, .(year, length)]

# Aparece un primer concepto del operador .() de esta forma solo me devuelve
# como resultado las columnas "year" y "length".

# ¿Como selecciono un valor de una columna?
movDT[ year == "2005" ]

# ¿Cómo operar sobre una columna?
movDT[ , .(sum(budget)) ]
# El resultado es NA porque hay muchos NAs en las primeras filas.

# Podemos quitar los NAs
movDT[ , .(sum(as.numeric(budget), na.rm = TRUE)) ]

# Este resultado lo podemos asociar a una variable
movDT[ , .(SumePresu = sum(as.numeric(budget), na.rm = TRUE)) ]
# Pero esa variable no queda incluida dentro del data.table
names(movDT)

# Podemos calcular varias cosas a la vez
movDT[, .(MaxYear = max(year), DurAve = mean(length)) ]
# El año máximo que hay en el conjunto y la media de duración


#------------------------------------
# Operaciones con "by" - Agrupaciones
#------------------------------------
# ¿Podemos calcular la longitud media de las películas por año?
movDT[ , .(AvLeYe = mean(length)), by = year ]
# Fijaros en:
# 1. Actuamos sobre todo el conjunto. No seleccionamos ninguna fila. Observad la coma primera
# 2. Calculamos la media de la longitud como hemos hecho antes
# 3. Agrupamos por año: "by = year"

# Vemos que el resultado sale desordenado...
# ¿Cómo lo podemos ordenar?
# Utilizamos otro concepto que es el de concatenar varias operaciones data.table
# Fijaros en el ejemplo
movDT[ , .(AvLeYe = mean(length)), by = year ][order(year, na.last = TRUE)]
# Primero calculo y sobre el resultado aplico una ordenación.
# Cuidado que este "order" es propio de data.table, es una ordenación super-eficiente

# Mirad esta ayuda
?setorder
# data.table incluye funciones muy eficientes para realizar operaciones que
# solemos también hacer sobre data.frames: cbind, rbind, order, etc..

# Otra forma de hacerlo hubiese sido: primero ordeno todo el conjunto por año
# y sobre el resultado hago la selección. Si hago esto, al ordenar el movDT
# queda ordenado de forma permanente (tampoco pasa nada)
movDT <- as.data.table(movies)
setorder(movDT, year)
# Así queda ordenado por año
# Lo vemos...
head(movDT)

# Y ahora calculamos la media por año
movDT[ , .(AvLeYe = mean(length)), by = year ]
# Que aparece ordenado...

# ¿Cuántas películas se han hecho por año?
movDT[ , .(NumPelis = .N), by = year]
# Aparece otro nuevo concepto, otra variable propia de data.table .N 
# .N es el número de filas. Si agrupo por año, será el número de películas por año

# ¿Podría pintar esta evolución?
movDT[ , .(NumPelis = .N), by = year] [ plot(NumPelis)]
# Volvemos a utilizar la posibilidad de concatenación y una vez que
# hemos calculado la variable NumPelis en la siguiente llamada a data.table
# hacemos un plot de esa variable [plot(NumPelis)]

# Con este ejemplo vemos la potencia de data.table


#-----------------------------------------------------
# Añadir nuevas columnas...y encadenado de operaciones
#------------------------------------------------------

# ¿Cuál será la relación entre la duración y el presupuesto?
# Esta operación la haremos sobre cada fila, cada película
# Vamos a crear una nueva variable budget/length que añadimos a movDT
# Tendremos que tener en cuenta los NAs en budget...
movDT[ , ratioBuLe := ifelse(is.na(budget), 0, budget/length) ]
# ¿Qué hemos hecho?
# 1. La nueva variable "ratioBuLe" la definimos con esta asignación ":=".
# 2. Para evitar el NA usamos la función ifelse() que actúa sobre cada fila 
#    de un data.frame. Si budget es "NA" (lo comprobamos con is.na) le 
#    asignamos un valor de 0, y si no lo es hacemos el cociente.
head(movDT)
# Vemos que nuestra columna ratioBuLe está dentro de movDT

# Ahora que tenemos la variable "ratioBuLe" dentro, podemos hacer unos boxplots para ver la 
# distribución de este ratio por año...
# Como hay muchos ceros, vamos a quitarlos en el cálculo y vamos a hacer el cálculo solo para 
# los años mayores o iguales del 2000
movDT[ratioBuLe > 0 & year > 2000, boxplot(ratioBuLe ~ year)]

# Hacer este conjunto de operaciones sobre un data.frame sería costoso...
# Tendríamos que crear varias variables/data.frames intermedio...
# Este último comando podríamos haberlo encadenado al anterior cuando definimos "ratioBuLe".

#-----------------------------------------------------
# Eliminar columnas....
#------------------------------------------------------
# Para eliminar columnas ¿qué hacemos?
# Vamos a eliminar "ratioBuLe" y así nos quedamos con el data.table original
movDT[ , ratioBuLe := NULL ]
# Observa cómo tenemos la coma inicial. Y asignando la columna a NULL la borramos. 

#-----------------------------------------------------
# Otras funciones interesantes que incorpora data.table
#------------------------------------------------------
# Además de su potencia, que hemos comprobado, data.table casi es más conocido por
# su función de lectura de ficheros equivalente a read.table().
# Efectivamente data.table incluye la función "fread()" que acelera la lectura de ficheros grandes
# de una manera espectacular comparado con lo que hace read.table()
# Su sintaxis es muy sencilla dataIn <- fread("mi_fichero.csv")
# fread automáticamente detecta el separador y el tipo de columna.

# Probad a leer un fichero grande con esta función...
# Podeis salvar movDT en un fichero csv y leerlo tanto con read.table como fread
# o mirar la ayuda de fread donde aparece un ejemplo donde se crea un fichero
# de 50Mb y compara los tiempos de lectura con diferentes funciones.
# Muy recomendable...

#----------------------------------------------------------------------
# Aunque quedan algunos conceptos más avanzados pendientes, con todo
# este conocimiento podéis enfrentaros a muchos problemas con solvencia
#----------------------------------------------------------------------

# Ejercicios (utilizando movies):
# Podéis contiuar con el análisis  de este conjunto usando data.table
# 1. Ver duraciones por tipo de pelicula  - Visualizándolo
# 2. Ver duraciones por tipo de película y año - Visualizándolo
# 3. Ver presupuestos por tipo de pelicula  - Visualizándolo
# 4. Ver presupuestos por tipo de película y año - Visualizándolo
# 5. Ver los ratings medios por tipo de película - Visualizándolo
# 6. Ver los ratings medios por tipo de película y año - Visualizándolo


# Ejercicios (utilizando nycflights13)
# Si instaláis el paquete "nycflights13" podéis trabajar sobre un conjunto
# más grande. Dentro de nycflights13 hay un dataset "flights" de 336776 filas y 19 cols.
# Este conjunto se puede enriquecer con el resto de datasets que incluye el paquete
# nombre de las aerolíneas, destinos, orígenes, etc...
# Con este conjunto, más grande, si vuestra máquina lo permite, podréis comprobar 
# mucho más claramente las potencia de data.table.
# 1. Estudiar qué aeropuertos de órigen son los que más retrasos acumulan.
# 2. Y las aerolíneas que más retrasos acumulan en cantidad y en valor medio del retraso.

# Nota: Estos ejercicios no son puntuables. Tienen el propósito de ayudar a adquirir
# un mayor conocimiento práctico.
#-----------------------------------------------------------
# INTRODUCCIÓN
#-----------------------------------------------------------
# dplyr es otro de los paquetes de mayor popularidad y potencia en el ecosistema R.
# Forma parte del llamado "Hadleyverse", otro paquete del prolífico y carismático
# Hadley Wickham autor de ggplot2, tidyr (que también revisaremos en este curso), 
# readr, purr, etc.

# dplyr permite realizar la mayor parte de las transformaciones, proceso de limpieza
# que uno precisa al enfrentarse a un análisis de datos. Su sintaxis se asemeja al
# lenguaje SQL

# Consta de un conjunto de verbos que ahora veremos cómo se utilizan.
# Cada verbo es una función, estos verbos se utilizan como una cadena de acciones 
# que pueden anidarse, pero el código queda poco legible.
# Pero de un tiempo a esta parte tras la aparición del paquete "magrittr", 
# estos verbos se utilizan como una cadena de acciones separados por "pipes";
# funcionalidad que proporciona "magrittr".

# El código como veremos, cuando es utilizado de esta forma, es muy legible.
# Cuando un código es muy legible, ayuda mucho a su mantenimiento y sin duda su
# comprensión.

# De este paquete tambié existe una "CheatSheet" (Guía Rápida) que es muy recomendable
# tener a mano durante los siguientes ejercicios:
# https://www.rstudio.com/wp-content/uploads/2015/03/data-wrangling-spanish.pdf


#-----------------------------------------------------------
# COMENZAMOS .... 
#-----------------------------------------------------------

# Instalamos el paquete 
install.packages("dplyr")
# Cargamos el paquete
library(dplyr)
# También cargamos el paquete "datasets" usaremos uno de sus conjuntos de datos
library(datasets)
# El paquete dataset viene incluido en la instalación por defecto de R.

# Usaremos el conjunto swiss
# Vemos una descripción del conjunto y las variables que lo forman
?swiss
# Y las primeras líneas.
head(swiss)  

#---------------------------------------------------------
# Vamos a explorar con un poco más de detalle el conjunto.

# Hacemos múltiple histogramas
# Salvamos los parámetros gráficos
oldpar <- par()     
# Creamos un layout de 2 filas x 3 columnas
par(mfrow = c(2, 3))  
# Guardamos el nombre de las variables
colnames <- dimnames(swiss)[[2]]  
# Hacemos un bucle sobre las columnas
for (i in 1:ncol(swiss)) {
  hist(swiss[, i],
  main = colnames[i])
}

# Devolvemos los parámetros gráficos originales
par <- oldpar       
# Hacemos un scatterplot
plot(swiss)         


#-----------------------------------------------------------
# OPERACIONES CON dplyr
#-----------------------------------------------------------

#-----------------------------------------------------------
# Los verbos de dplyr son los siguientes:
# filter() (y slice())
# arrange()
# select() (y rename())
# distinct()
# mutate() (y transmute())
# sample_n() y sample_frac()
# group_by()
# summarise() (o summarize())

#-----------------------------------------------------------
# 1. filter() - Filtrado 
# Seleccionamos (filtrar) las provincias en las que hay un porcentaje de Católicos superior al 60%
filter(swiss, Catholic > 60 )
filter(swiss, Catholic > 60 & Examination < 10)
# Es la misma operación que hacemos con un data.frame
# swiss[swiss$Catholic > 60, ]

# Con slice() puedo seleccinar un número determinado de filas.
slice(swiss, 1:3)

#-----------------------------------------------------------
# 2. arrange() - Ordenación
# Ordenamos el conjunto por orden descentente de porcentaje de Educación y 
# de mayor a menor en Catholic
arrange(swiss, desc(Education), Catholic)

#-----------------------------------------------------------
# 3. select() - Seleccionar variables/columnas
# Selección de columnas
select(swiss, Education, Examination, Agriculture)

# Podemos seleccionar columnas próximas como si fuesen números
# como hacemos con un data.frame
select(swiss, Agriculture:Education)

# También podemos seleccionar las columnas complementarias
select(swiss, -(Catholic:Infant.Mortality))

# Podéis ver en la "Guía Rápida" las posibilidades de selección que 
# también podéis usar del tipo como si fuesen expresiones regulares:
select(swiss, contains("."))
select(swiss, starts_with("E"))


#-----------------------------------------------------------
# 4. distinct() - Selección de filas no duplicadas 
distinct(select(swiss, Education))

#-----------------------------------------------------------
# 5. mutate() y transmute() - Cómo añadir y quedarse con algunas columnas
# Vamos a realizar operaciones sobre una copia del conjunto original swiss1
swiss1 <- swiss
# Añadimos dos columnas: rank_Catholic y majority_Catholic
swiss1 <- mutate(swiss1,
  rank_Catholic = rank(-Catholic),  
  majority_Catholic = ifelse(Catholic > 50, "True", "False")
)
head(swiss1)

# Con maggrittr y usando pipes seleccionamos varias columnas de swiss1 
# y ordenamos esa selección por la columna Catholic en forma descendente
myset <- swiss1 %>%
  select(Catholic, rank_Catholic, majority_Catholic) %>%
  arrange(desc(Catholic))
head(myset)

# Ahora usamos mutate() para quedarme solamente con las nuevas columnas
# Realizo estas operaciones sobre una nueva copia de swiss que guardo en swiss2
swiss2 <- swiss
swiss2 <- transmute(swiss2,
  rank_Catholic = rank(-Catholic),  
  majority_Catholic = ifelse(Catholic > 50, "True", "False")
)
head(swiss2)


#-----------------------------------------------------------
# 6. sample_n() y sample_frac() - Para muestrear un número de filas o una fracción
# Si uso replace = TRUE las selección es con o sin reemplazar.
sample_n(swiss, 10)
sample_frac(swiss, 0.20)

#-----------------------------------------------------------
# 7. group_by() - summarize() - Agrupo resultados y aplico cálculos sobre cada grupo
# Agrupo por nivel de Catholic (majority_Catholic)
by_majority <- group_by(swiss1, majority_Catholic)
# Y sobre cada grupo, cuento el número de provincias y calculo la media de "Agriculture"
summarize(by_majority,
  cuenta = n(),
  ag_mean = mean(Agriculture))

# Que utilizando pipes queda más claro si cabe
miCalculo <- swiss1 %>% group_by(majority_Catholic) %>% 
                        summarize( cuenta = n(), ag_mean = mean(Agriculture) )
# Fijaros en como al utilizar pipes en las funciones ya no incluyo 
# el conjunto/data.frame al que me refiero

# Fijaros en la clase de miCalculo
class(miCalculo)
# Es del tipo "tbl_df" "tbl" "data.frame"
# Con dplyr se introduce un nuevo tipo de objeto que es un tipo de tabla
# también un data.frame pero que permite visualizarse mejor
# de forma más compacta que un data.frame normal.

#-----------------------------------
# ¿Es mejor dplyr o data.table
# Esta es una cuestión habitual...
# Podéis ver una discusión basada en medidas de rendimiento aquí:
# http://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly

# dplyr tiene una ventaja sobre data.table y es que dplyr está preparado para
# tratar directamente sobre bases de datos que las considera directamente como un data.frame
# Que unido a la facilidad de lectura que consigue con magrittr está siendo
# integrado en paquetes que permiten conectarse con bases de datos BigData: Hive, Impala.

# Ejercicios
# Podeís replicar los ejercicios asociados a data.table y comparar 
# tiempos de respuesta entre uno y otro.

# Nota: Estos ejercicios no son puntuables. Tienen el propósito de ayudar a adquirir
# un mayor conocimiento práctico.

#--------------------------
# Limpio workspace
rm(list = ls()) 
# Limpio consola
cat("\014")  # ctrl+L
#-----------------------------------------------------------
# INTRODUCCIÓN
#-----------------------------------------------------------
# tidyr es otro paquete de Hadley Wickham. Forma parte del paquete tidyverse
# donde se incluyen la mayor parte de los paquetes del mismo autor: ggplot2,
# dplyr, purr, tydir, stringr, lubridate, etc.

# El objetivo de tidyr es el de conseguir que en un conjunto de datos:
# 1. Cada variable tiene su propia columna
# 2. Cada observación tiene su propia fila 
# Normalmente en la mayoría de los datasets este tipo de estructura limpia no 
# se encuentra. tidyr ofrece un conjunto de funciones que nos ayudarán a conseguirlo.

# Además de este paquete, que realmente uniformiza el conjunto de acciones para 
# conseguir un conjunto "tidy", existen en R otros paquetes que realizan acciones
# equivalentes: reshape, reshape2, plyr, todos del mismo autor Hadley. 
# tidyr, viene a sustituir a todos ellos.

# Al igual que con dplyr, las funciones de este paquete se pueden utilizar 
# como cualquier otra función de R, de forma aislada o encadenadas con "pipes"
# utilizando el paquete "mgrittr". Así lo veremos aplicado en las siguientes
# explicaciones.

# Este paquete comparte la misma CheatSheet que dplyr.
# Es conveniente tenerla a mano durante los siguientes ejercicios:
# https://www.rstudio.com/wp-content/uploads/2015/03/data-wrangling-spanish.pdf



#-----------------------------------------------------------
# COMENZAMOS .... 
#-----------------------------------------------------------

# Instalamos el paquete 
install.packages("tidyr")
# Cargamos el paquete
library(tidyr)

# En este caso, para ilustrar un caso de un conjunto no-tidy crearemos
# un data.frame con datos simulados sobre los que aplicaremos las diferentes
# funciones tidyr.

# Generamos un data.frame (data0) con números aleatorios obtenidos de
# entre 0 y 100. 
n <- 10  
data0 <- data.frame(
  id = 1:n,                              
  t1_a = sample(0:100, n, replace = T),  
  t1_b = sample(0:100, n, replace = T),  
  t2_a = sample(0:100, n, replace = T),  
  t2_b = sample(0:100, n, replace = T)   
)
data0  


#-----------------------------------------------------------
# OPERACIONES CON tidyr
#-----------------------------------------------------------

#-----------------------------------------------------------
# tidyr incluye cuatro funciones para realizar este proceso
# de ordenación, que de alguna forma podemos considerar equivalentes:
# gather() / spread()
# unite() / separate()

#-----------------------------------------------------------
# 1. gather() - Permite convertir un dataset de ancho a largo

data1 <- data0 %>%
  gather(time_cond, score, -id)
head(data1, 15)
# En este ejemplo, estamos conseguiendo el agrupar en una sola columna
# todas las medidas "ti_*" (la variable la llamamos "time_cond") y los
# valores de cada uno de estas "ti_*" los agrupamos bajo la columna "score".
# y la parte más importante: indicamos la variable con la que "unificamos"
# en este caso "id" pero ordenada de menos a más "-id".

#-----------------------------------------------------------
# 2. separate() - Permite separar una columna en múltiples columnas
# utilizando un caracter.

# Podemos pensar que en nuestro conjunto "ti_*" realmente está representando
# dos variables: a) "ti" que sería un tiempo y b) "_*" que sería una condición
# de tratamiento.
# Un conjunto tidy requiere que cada variable tenga su columna y eso es lo
# que podemos hacer con separate() en este caso. Separar por un lado las "ti"
# y por otro las condiciones "_*".

data2 <- data1 %>%
  separate(time_cond, into = c("time", "cond"), sep = "_") 
head(data2)
# En separate() hemos de indicar la variable que queremos separar: time_cond
# El nombre de las variables que obtendremos de la variable a dividir, en 
# este caso, "time" y "cond".
# Y el separador nos permitirá hacer la separación, en este caso "_".


#-----------------------------------------------------------
# 3. unite() -  Permite pegar/unificar varias columnas en una.
# 4. spread() - Extiende filas en múltiples columnas.

# unite() y separate() son funciones antagónicas:  Junto / Separo.
# gather() y spread()  son igualmente antagónicas: Ancho-> Largo / Largo -> Ancho

# Con estas nuevas funciones, vamos a deshacer los cambios anteriores
# para conseguir el conjunto del que partimos.
data3 <- data2 %>%
  unite(time_cond, time, cond) %>% head() %>%
  spread(time_cond, score) %>%
  head()  

# En unite, he de indicar la variable en la que unifico (time_cond) las 
# variables que voy a juntar "time" y "cond"
# Y con con spread() indico la variable de la que tengo que se obtendrán
# cada una de las diferentes columnas (time_cond) y la columna que incluye
# los valores para cada uno de esos diferentes niveles (score)


#--------------------------
# Limpio workspace
rm(list = ls()) 
# Limpio consola
cat("\014")  # ctrl+L
#-----------------------------------------------------------
# INTRODUCCIÓN
#-----------------------------------------------------------
# RStudio incluye una funcionalidad muy interesante y potente que nos 
# permite crear informes, documentos en los que incluir texto, gráficos
# y código "R". 

# Este tipo de funcionalidad, además de evitar utilizar como ocurría hasta
# ahora diferentes programas (Word, R, etc) para generar este tipo de informes,
# permite avanzar en un concepto que está atrayendo mucho interés entre 
# la comunidad científica y es el de "Reproducible Research". 

# La queja constante, de poder reproducir los resultados de un estudio, los 
# análisis, etc, que ha ocasionado serios fiascos en el mundo científico y
# académico se puede evitar con este tipo de solución: si tengo un informe en 
# el que doy detalles de la estructura de mis datos, de los procesos de 
# manipulación para transformarles, las funciones, algoritmos que utilizo para
# modelizar y las visualizaciones que genero, todo incluido en el mismo documento.
# El problema se minimiza notablemente.

# Este es el concepto que permite conseguir rmarkdown/knitr

# Para generar un documento de este tipo, tenemos que abrir un fichero con 
# una estructura especial. Para ello, seguiremos en RStudio, en el menú superior: 
# "File" -> "New File" -> "R Markdown"

# Al seguir estos comandos veremos que nos aparece una ventana en la que nos 
# piden: a) el nombre del documento, b) el autor y c) El formato de salida.
# Completemos estos campos y elijamos por ahora que la salida es HTML.

# Aparecerá un fichero con extensión "Rmd" con este contenido:

#--------------------------------------------------------

---
title: "Prueba"
author: "Carlos Ortega"
date: "1/1/2017"
output: html_document
---
  
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:
  
```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:
  
```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

#--------------------------------------------------------

# Veamos el significado de cada sección:
#--------------------------------------
# 1. CABECERA

---
  title: "Prueba"
author: "Carlos Ortega"
date: "1/1/2017"
output: html_document
---
# Esta seccion incluye los datos del autor, el nombre del documento y el tipo 
# de salida que queremos.
# Esta sección se puede enriquecer, incluyendo (si la salida es HTML) el formato
# de salida, colores, tipo de letra para cada sección que ahora veremos, etc.

#--------------------------------------
# 2. CHUNK - Código R.

```{r cars}
summary(cars)
```
# Esto es un chunk.
# Es el código de "R" que queremos ejecutar.
# Viene separado por las comillas ```
# Por un lado: ```{r cars} indica que abro el chunk
# y al completarlo: ```  lo cierra.

# Dentro de las llaves {r cars} puedo indicar diferentes condiciones, 
# si quiero que el código aparezca en el informe además del resultado,
# a la hora de incluir un gráfico, las dimensiones de la figura, etc.

# Las versiones recientes de RStudio ya permiten incluir en estos chunks
# código de R, Python, bash, C++

# Y ahora también puedo ejecutarlas de forma independiente. En versiones
# anteriores, solamente podías saber si lo que habías incluido en un chunk
# era correcto en el momento en el que generabas el documento final.

#--------------------------------------
# 3. TEXTO y SECCIONES 

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.
When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:
  
# Además del codigo R, figuras, resultado de la ejecución, queremos incluir 
# en nuestro documento texto, secciones, etc. Para todo esto, se ofrecen
# un cojunto de utilidades que sin ser tan potentes como un procesador 
# de texto, sí que puedo hacer lo básico: crear secciones de diferentes niveles,
# marcar algunas palabras en negrita, otras en itálica, incluir hiper-enlaces,
# etc.

# Para estas funcionalidades se utiliza Markdown que es un lenguaje de edición
# muy sencillo para dar formato a páginas web. De ahí viene el nombre de 
# rmarkdown.

# Las secciones las marco con "##", dependiendo del número de "#" indico si 
# es una sección principal o secundaria "##" o de tercer nivel "###"...
  
# Las negritas las marco con un "**" al principio y al final de la palabra que
# queremos resaltar: **Knit**, o en itálicas *Knit*

# Las diferentes posibilidades de edición las podemos ver en la siguiente
# CheatSheet:
# https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf

# En la última página de esta CheatSheet, podemos ver las diferentes opciones 
# que podemos considerar dependiendo de si queremos un documento en pdf, html
# o Word.

# Una vez tenemos nuestro documento definido (recordar que la extensión es 
# .Rmd), lo generamos pulsando el icono Knit. A su lado aparece un
# ovillo con unas agujas (en azul).

# Veremos una vez pulsado este icono, como aparece la "compilación" del 
# documento en la consola baja una nueva pestaña "R Markdown". 
# Esta conversión la realiza el paquete "knitr" que se instala con rmarkdown y 
# otro programa "pandoc"  que permite realizar la conversión a diferentes formatos.

# Si queremos que la salida sea en formato pdf es muy probable que tengamos
# que instalar un ejecutable adicional. Probad a generar una salida en formato 
# pdf y si obtenéis un error, mirad el mensaje de error, porque indicará
# el programa a instalar.

# Esta solución rmarkdown, además de ayudarnos a generar informes con diferentes
# tipos de salida como hemos visto también lo podremos usar para generar presentaciones

# Otra funcionalidad muy interesante si generamos un documento con este formato
# es que lo podemos publicar en RPubs que es un servicio que ofrece RStudio.
# Si no tenemos problemas con la confidencialidad de nuestro documento, podemos
# subirlo a este servicio (hay que darse de alta) y será de acceso libre.
# O podemos utilizar un servicio de pago y hacer accesible nuestro informe
# solamente a las personas que designemos.

# Ejercicios 
# Como ejercicio podeís transformar todos estos ficheros .R del curso en ficheros .Rmd. 
# Incluyendo el código R de los ejemplos, y los comentarios de los resultados y las 
# explicaciones como el texto que lo acompaña.
# Y el resultado lo podéis generar en diferentes formatos de salida, para probar las
# varias configuraciones de salida.

# Nota: Estos ejercicios no son puntuables. Tienen el propósito de ayudar a adquirir
# un mayor conocimiento práctico.

