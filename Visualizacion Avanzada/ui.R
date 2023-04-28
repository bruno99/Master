
library(shiny)
library(shinythemes)
library(ggplot2)
library(tidyverse)
library(tsibble)
library(feasts)


isciii <- read_csv("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv",
                   na = c(""))


fech_max <- max(isciii$fecha)

cond <- {isciii$grupo_edad != "NC" &
  isciii$sexo != "NC"} 

data_para_plot <- isciii[cond, ]

edades <- unique(data_para_plot$grupo_edad)


nums <- sapply(data_para_plot, is.numeric)
continuas <- names(data_para_plot)[nums]
cats <- sapply(data_para_plot, is.character)
categoricas <- names(data_para_plot)[cats]


shinyUI(
  navbarPage("Shiny Visualización COVID-19 en España",
             theme = shinytheme("united"),
                   tabPanel("Introducción",
                            mainPanel(
                              h1("Ejemplo Visualización con R-shiny", align = "center"),
                              h3("UNED, Visualización avanzada, Profesor: Pedro Concejero, 2023", align = "center"),
                              p(""),
                              h2("IMPORTANTE", align = "center"),
                              h2("Recomendable resolución superior a 1280x1024 para visualizar gráficos \n
                                 sin tener que hacer scroll lateral", 
                                 align = "center"),
                              p(""),
                              p("- Serie temporal de la variable elegida, en función de grupo de edad y fechas"),
                              p("- Barplot o gráfico de barras por grupo edad y sexo con el total de casos eligiendo la gravedad"),
                              p("- Dispersion"),
                              p("")
                              )),
             tabPanel("Olas COVID -series temporales",
                      sidebarPanel(
                        selectInput(inputId = 'y2', 
                                    'Elige variable para eje Y', 
                                    choices = c("total_contagiados",
                                                "total_hospitalizados",
                                                "total_uci",
                                                "total_fallecidos"), 
                                    selected = "total_contagiados"),
                        selectInput(inputId = 'edad', 
                                    'Elige grupo de edad', 
                                    edades,
                                    edades[[3]]),
                        dateRangeInput('dateRange',
                                       label = 'Pon tu rango de datos en formato: yyyy-mm-dd',
                                       start = "2020-02-01", 
                                       end = fech_max,
                                       min = "2020-01-01",
                                       max = fech_max
                        )
                      ),
                      mainPanel(
                        plotOutput(outputId = 'plot2',
                                   height = 1000,
                                   width = 1200
                        ))
                      
             ),
             
             tabPanel("Gráfico de barras",
                      sidebarPanel(
                        
                        selectInput(inputId = 'y', 
                                    'Elige lo que se representará en barplot', 
                                    choices = c("total_contagiados",
                                                "total_hospitalizados",
                                                "total_uci",
                                                "total_fallecidos"), 
                                    selected = "total_contagiados")),
                      
                      mainPanel(
                        plotOutput(outputId = 'plot',
                                   height = 1000,
                                   width = 1200)
                      )),
             
             tabPanel("Gráfico de dispersion",
                      
                      mainPanel(
                        plotOutput(outputId = 'plot3',
                                   height = 1000,
                                   width = 1200)
                      )),
             
  ))

