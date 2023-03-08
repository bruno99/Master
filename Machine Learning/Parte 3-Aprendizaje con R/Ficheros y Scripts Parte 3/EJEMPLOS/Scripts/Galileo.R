#### Regresi?n lineal m?ltiple
#Y=beta1*x1+beta2*x2+...+betak*xk;

galileo.dat <-read.table(file="C:/DATOS/DATOS/galileo.txt",header=F,col.names=c("d", "h"));galileo.dat#no hay linea de cabecera
attach(galileo.dat)
plot(h,d, xlab = "Distancia (d)",ylab = "Altura (h)")
#En caso de no haber hecho el attach
#plot(galileo.dat$d,galileo.dat$h,xlab = "Distancia (d)",ylab = "Altura (h)")#ojito con el orden de las X y las Y
#vemos que con una recta no vamos a conseguir un buen ajuste
abline(lm(h~d))

# Buscamos un ajuste entre d, h y h^2 de la forma: d=ao+a1*h+a2*h^2;
h2=h^2
galileo.lm=lm(d~h+h2)#expresa que d sera un modelo en funci?n de h y h2 
#otra forma de hacerlo sin definir previamente h2:
galileo.lm=lm(d~h+I(h^2))#I()indica que es una formula... que no lo calcule ahora
summary(galileo.lm)
#nuestro modelo seria:
#d=202.8+0.6983*h-3.62*10^(-4)*h^2
#la r^2 es buenisima 0.9913

#para realizar una gr?fica con puntos conectados por l?neas:
plot(h,d,type="l")
# o incluso: ("b" es both)
plot(h,d,type="b")
lines(h,galileo.lm$fitted,col="red")
#este es nuestro modelo te?rico: galileo.lm$fitted (vienen proporcionados por la ecuacion calculada)


################
#modelo de orden 3
h2=h^2
h3=h^3
galileo.lm=lm(d~h+h2+h3)#expresa que d sera un modelo en fuci?n de h y h2 
lines(h,galileo.lm$fitted,col="blue") # con eso a?adimos a la gr?fica los valores del modelo ajustado de grado 3.

################
#modelo de orden 4
h2=h^2
h3=h^3
h4=h^4
galileo.lm=lm(d~h+h2+h3+h4)#expresa que d sera un modelo en fuci?n de h y h2 
lines(h,galileo.lm$fitted,col="green")
summary(galileo.lm)
#h4          -4.681e-10  2.155e-10  -2.172  0.16196 ESTE ESTAR?A APUNTO DE QUITARSE.
#el ajuste cada vez va mejorando , el R squared va aumentado cada vez
