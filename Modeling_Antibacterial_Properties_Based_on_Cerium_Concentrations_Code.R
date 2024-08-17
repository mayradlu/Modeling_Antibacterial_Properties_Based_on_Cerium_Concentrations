
library(readxl)
library(ggplot2)
library(earth)  #para aplicar mars
library(plotmo) #para graficar mars
library(caret)  #para hacer combinaciones de paremetros y comparar
                # hacer cross validation
library(Metrics)


CeLa_ALLV2 <- read_excel("C:/Users/mayra/Downloads/CeLa_ALLV2(2).xlsx",sheet = "Cerio")
View(CeLa_ALLV2)
attach(CeLa_ALLV2)

modelo <- lm(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria +
     Lambda+Theta+a+c+d+D+v+R+n+V+APF+Positional+b+b1+b2+b3+alpha+beta+Zn+Ce+Optical_band)
summary(modelo)

#hay variables que NO VARIAN y no se pueden usar en el modelo o 
#o están altamente correlacionadas entre si

plot(Zn,Lambda)
cor(Zn, Lambda)
# por ejemplo las variabla ZN y Lambda, solo hay 5 parejas de valores
# diferentes y el índice de correlacion es de 0.9619


#Identificar cuales variables tienen alta correlacion
#se utiliza metodo Spearman y no de Pearson. No se tiene certeza
#que la variable de comporte como distr normal

correlacion <- cor(CeLa_ALLV2[,c(7:14,16:29)], method="spearman")
correlacion

#Identificar cuales variables tienen correlacion PERFECTA  = 1
#hay correlaciones perfectas entre las variable
#lambda, Theta, d  /estas tres no pueden estar al mismo tiempo
#se escoge lambda

correPerfecta1 <- cor(CeLa_ALLV2[,c(7,8,12)], method="spearman")
correPerfecta1

#pero tambien entre las variables 
#c,D, C/a_ratio,n,V,b1', alpha  /en Regresion estas 7 variables no pueden estar junta
#se escoge alpha

correPerfecta2 <- cor(CeLa_ALLV2[,c(10,11,13,17,18,22,25)], method="spearman")
correPerfecta2

#tambien entre las variables 
#v,b, Zn /en Regresion estas 3 variables no pueden estar juntas
#se escoge Zn

correPerfecta3 <- cor(CeLa_ALLV2[,c(14,21,27)], method="spearman")
correPerfecta3

#tambien entre las variables 
#R,APF, Positional, beta /en Regresion estas 4 variables no pueden estar juntas
#se escoge APF

correPerfecta4 <- cor(CeLa_ALLV2[,c(16,19,20,26)], method="spearman")
correPerfecta4

#tambien entre las variables 
#b2,b3, aunque no es correlacion perfecta, si es alta
#se escoge b2

correPerfecta5 <- cor(CeLa_ALLV2[,c(23,24)], method="spearman")
correPerfecta5

#lo mismo ocurre con Ce y Optimal_band
#aunque no es correlacion perfecta, si es alta
#se escoge Ce

correPerfecta6 <- cor(CeLa_ALLV2[,c(28,29)], method="spearman")
correPerfecta6

#se obtiene el modelo sin las variables altamente correlacioadas
# y un modelo sin intercepto, considerando que el tiempo minimo es cero


modelo2 <- lm(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria +
                Lambda+Zn+APF+b2+Ce -1)
summary(modelo2)

#se observa que aun hay variables correlacionas

otrasCorrelaciones<- cor(CeLa_ALLV2[,c(7,27,25,19,23,28)], method="spearman")
otrasCorrelaciones

#pero entre ellas no estan altamente correlacionadas, lo que significa
#que estan relacionadas con otra de las variables hasta el momento no 
#consideradas en el analisis de correlacion: contenido de cerio, time o 
#concentracion de material

modelo3 <- lm(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria +
                Lambda -1)
summary(modelo3)
plot(modelo3)
#se observa que el modelo no ajusta correctamente
#la relacion no es lineal, los residuos muestran un ajuste incorrecto
#la relacion es no lineal, quizas cuadratica

plot(Time, modelo3$residuals)
plot(Concentracion_material, modelo3$residuals)

modelo4 <- lm(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria +
                Lambda -1)
summary(modelo4)
plot(modelo4)

ggplot(data= CeLa_ALLV2, aes(x=Time, y=supervivencia, 
  colour= Concentracion_material))+ geom_point() +
  facet_wrap(~Bacteria)+geom_smooth(col ="red")+
  theme_light()+theme(legend.position="bottom")

ggplot(data= CeLa_ALLV2, aes(x=Time, y=supervivencia, 
  colour= Bacteria))+ geom_point() +
  facet_wrap(~Concentracion_material)+geom_smooth(col ="red")+
  theme_light()+theme(legend.position="bottom")

ggplot(data= CeLa_ALLV2, aes(x=Time, y=supervivencia, 
  colour= Concentracion_material))+ geom_point() +
  facet_wrap(~Contenio_Cerio)+geom_smooth(col ="red")+
  theme_light()+theme(legend.position="bottom")

ggplot(data= CeLa_ALLV2, aes(x=Time, y=supervivencia, 
    colour= Concentracion_material))+ geom_point() +
  facet_wrap(~Contenio_Cerio+Concentracion_material)+geom_smooth(col ="red")

#QUIZAS UTILIZAR Multivariate Adaptive Regression Splines (MARS)o
# o regresion CART

# se utiliza el paquete earth para aplicar MARS
#Este método funciona de la siguiente manera:
# 1. Divida un conjunto de datos en k piezas.
# 2. Ajuste un modelo de regresión a cada pieza.
#ejemplo de interpretación de resultados se encuentra en
# https://rignatius.wordpress.com/2015/05/21/breve-introduccion-conceptual-a-mars/

#Como MARS genera segmentos de líneas mediante “bisagras” (hinges), 
#los coeficientes se usan de igual forma que en una regresión lineal 
#(multiplicando los datos) mientras que los segmentos quedan definidos 
#por la función “hinge”, que puede tener alguna de las dos formas:
  
#h1(x)<−max(0,x−c)
#o
# h2(x)<−max(0,c−x)


###################################################
#  Aprendizaje sin supervision
###################################################

mars <- earth(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
      data=CeLa_ALLV2)
summary(mars)
plot(mars)

# de segundo orden
mars2 <- earth(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
              data=CeLa_ALLV2, degree=2)
summary(mars2)
plot(mars2)

#experimento, para encontrar el mejor modelo, modificando el 
#parametro de degree (interacciones) y el parametro de nprune (numero max 
# de terminos en el modelo, además de usar validacion cruzada (10 modelos))
# cross validation (cv)

combinaciones <- floor(expand.grid(degree=1:4, nprune=seq(6,15,1)))

cv.mars.combinaciones <- train(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
                              data=CeLa_ALLV2, method="earth", metric="RMSE",
                              trControl=trainControl(method="cv",number=10),
                              tuneGrid=combinaciones)
ggplot(cv.mars.combinaciones)
cv.mars.combinaciones$results

#el "mejor modelo es degree 3  y nprune = 9
mars3 <- earth(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
               data=CeLa_ALLV2, degree=3, nprune=9,)

summary(mars3)
plot(mars3)
plotmo(mars3)
varimp3 <- evimp(mars3)
plot(varimp3)
varimp3  #importancia de las variables

###################################################
#  Aprendizaje con supervision
###################################################
combinaciones <- floor(expand.grid(degree=1:4, nprune=seq(6,15,1)))
CeLa_ALLV3=CeLa_ALLV2[, c(2:7)]  #solo las variables no correlacionadas
indices= sample(1:nrow(CeLa_ALLV3),size=floor(0.85*nrow(CeLa_ALLV3)), replace=F)  
valoresEntrenar <- CeLa_ALLV3[indices,]
valoresPrueba <- CeLa_ALLV3[-indices,]

cv.mars.cerio_Entrenamiento<- train(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
                       data=valoresEntrenar, method="earth", metric="RMSE",
                       trControl=trainControl(method="cv",number=10),
                       tuneGrid=combinaciones)

ggplot(cv.mars.cerio_Entrenamiento)

# el mejor modelo es degree 3 con nprume = 10

mars_entrenamiento <- earth(supervivencia~ Contenio_Cerio+Time+Concentracion_material+Bacteria+Lambda, 
               data=valoresEntrenar, degree=3, nprune=10)
summary(mars_entrenamiento)
plot(mars_entrenamiento)

varimp_entrenamiento <- evimp(mars_entrenamiento )
plot(varimp_entrenamiento )
varimp_entrenamiento   #importancia de las variables

# prueba del modelo (que tan bien aprendio)

mars_prueba <- predict(object =mars_entrenamiento,newdata=valoresPrueba)
mars_prueba
valoresPrueba$supervivencia

mars_prueba_rmse <- rmse(valoresPrueba$supervivencia,mars_prueba)
mars_prueba_rmse

mars_prueba_mae <- mae(valoresPrueba$supervivencia,mars_prueba)
mars_prueba_mae #error absoluto promedio

par(mfrow=c(1,1))

residuos <- valoresPrueba$supervivencia-mars_prueba
plot(residuos, pch=20, col="black")
shapiro.test(residuos)

modeloComparación=lm(valoresPrueba$supervivencia~mars_prueba)
summary(modeloComparación)

resultados_finales <- data.frame(valoresPrueba$supervivencia,mars_prueba,valoresPrueba$Bacteria)
colnames(resultados_finales) <- c("observados","predichos","Bacteria")

ggplot( data= resultados_finales, aes(x=observados, y=predichos, 
 colour=Bacteria)) + geom_point() + theme_light()

