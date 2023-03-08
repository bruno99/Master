#Dibujando con plot
x<-(0:65)/10
y<-sin(x)
plot(x)
plot(x,y)
plot(x,y,main="Funci?n Seno")
z<-cos(x)
plot(x,z,main="Funci?n coseno")

#Algunas opciones de plot
plot(x,y,main="Seno",type='l')
plot(x,z,main="Coseno",lty=2, col="red", type='l')
plot(x,z,main="Coseno",lty=3, col="blue", type='l',xlim=c(0,2),ylab="cos(x)")

#Algunos procedimientos de bajo nivel
plot(x,y,main="Funciones seno y coseno",type="l")
points(x,y)
lines(x,z,col="blue",lty=2)
text(x=c(0.5,0.5),y=c(0,1),labels=c("sin(x)","cos(x)"),col=c("black","blue"))


#Funciones gr?ficas interactivas
plot(x,y,main="Funciones seno y coseno",type="l")
lines(x,z,col=2,lty=2)
legend(locator(1),legend=c("sin(x)","cos(x)"),lty=c(1,2),col=c(1,2))
x<-1:10; y<-sample(1:10)
nombres<-paste("punto", x,",", y, sep="")
#nombres<-paste("punto",x)
plot(x,y);identify(x,y,labels=nombres)