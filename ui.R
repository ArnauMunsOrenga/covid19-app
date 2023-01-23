
  dashboardPage(
    skin = "green",
    dashboardHeader(title = "COVID-19 APP",
                    titleWidth = 230,
                      dropdownMenu(
                        type = "notifications", #messages
                        headerText = strong("Com fer servir la app?"), 
                        icon = icon("question"), 
                        badgeStatus = NULL,
                        notificationItem(
                          text = "Navega per les diferents seccions del menú de l'esquerra",
                          icon = icon("hand-pointer")
                        ),
                        notificationItem(
                          text = "Analitza els resultats i obté les conclusions",
                          icon = icon("hand-pointer")
                        ),
                        notificationItem(
                          text = "Comparteix les visualitzacións fent una captura de pantalla",
                          icon = icon("hand-pointer")
                        )
                      )#end of dropdown menu
                    ),#end of dashboard header
    dashboardSidebar(
      
      screenshotButton(label = "",
                       filename = "covid_screenshot",
                       class = "snapshot_butt",
                       timer = 0.5 
      ),
      
      br(),
      sidebarMenu(id="sidebarmenu",
                  #this makes de sidebar menu to follow the website scrolldown
                  #style = "position: fixed; overflow: visible;",  
                 
                  menuItem("Presentació", 
                           tabName = "intro", 
                           icon = icon("plane-arrival",lib="font-awesome")   
                  ),
                  menuItem("Mapa del COVID-19", 
                           tabName = "mapa_cat", 
                           icon = icon("map",lib="font-awesome")   
                  ),
                  menuItem("Dashboard", 
                           tabName = "dashboard", 
                           icon = icon("eye",lib="font-awesome")
                  )
      )#End of sidebarMenu
    ),#end of Sidebar
    dashboardBody(
      #This line freezes the sidebar and the dashboard header so you can't scroll down and they will be fixed
      tags$script(HTML("$('body').addClass('fixed');")),
      gotop::use_gotop(
        src = "fas fa-chevron-circle-up", # css class from Font Awesome
        color = "#006400", # color
        opacity = 0.8, # transparency
        width = 40, # size
        appear = 80 # number of pixels before appearance
      ),
      br(),
      tabItems(
        tabItem(tabName = "intro",
                column(12,
                       div(class = "jumbotron",
                           h1(HTML("<center>El COVID-19 a Catalunya</center>")),
                           br(),
                           h2(HTML("<center>Impacte d'una pandèmia mundial al nostre país</center>")),
                           h2(HTML("<center> Març 2020 - Juliol 2022</center>")),
                           br(),
                           
                           br(),
                           #LEARN MORE BUTTON
                           fluidRow(column(2,
                                           offset = 5,
                                           p(style="padding-left: 20px",
                                             a(class = "btn btn-primary btn-rounded btn-lg",
                                               id = "tabBut",
                                               icon("graduation-cap"),
                                               "Aprèn més"
                                             ))
                           )
                           ),
                           hr(),
                           div(a(img(src="corona.jpg"), href = "http://www.infermeriaigualada.udl.cat/ca/"), style="text-align: center;")
                       ),#end of jumbotron landing page
                       
                       tags$hr(style="border-color: grey;"),
                       #### LEARN MORE SECTION ####
                       tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),
                       
                       bsModal("modalExample", "Pots aprendre més sobre el COVID-19 i la pandèmia a Espanya:", "tabBut", size = "large" ,
                               #h4("In the next video it is explain what time series forecasting is and it is a great introduction to the topic:"),
                               iframe(width = "560", height = "315", url_link = "https://www.youtube.com/embed/biOnV5-LDhE"),
                               br(),
                               #h4("The following video will introduce to you some of the most modern techniques in the field of forecasting time series with R. Video by Rob Hyndman."),
                               iframe(width = "560", height = "315", url_link = "https://www.youtube.com/embed/jIDrZbor5B0"),
                               br(),
                               #h4("The following video will introduce to you some of the most modern techniques in the field of forecasting time series with R. Video by Rob Hyndman."),
                               iframe(width = "560", height = "315", url_link = "https://www.youtube.com/embed/uAT8EEKBySM")
                               
                       )
                )#end of column
        ),
        # mapa_cat----
        tabItem(tabName = "mapa_cat",
                tags$head(includeCSS(path = "www/custom.css")),
                  tabsetPanel(type = "tabs",
                              selected = "Per comarques",
                              tabPanel("Per comarques",
                                       br(),
                                       tabsetPanel(type = "tabs",
                                                   selected = "Valors absoluts",
                                                   tabPanel("Valors absoluts",
                                                            
                                                            br(),
                                                            fluidRow(
                                                              column(12,
                                                                     #offset = 1,
                                                                     
                                                                     box(height=1200, 
                                                                         width = 12,
                                                                         solidHeader = TRUE,
                                                                         collapsible = FALSE,
                                                                         title = "Mapa de casos totals de COVID-19 a Catalunya detectats entre Març del 2020 i Juliol del 2022 per comarques:",
                                                                         
                                                                         leafletOutput("mapa_covid_total", height=750)
                                                                         
                                                                     )# End of big box per forecast selection
                                                              )#end of column
                                                            )#end of fluid row
                                                            ),
                                                   tabPanel("Densitat",
                                                            br(),
                                                            fluidRow(
                                                              column(12,
                                                                     #offset = 1,
                                                                     
                                                                     box(height=1200, 
                                                                         width = 12,
                                                                         solidHeader = TRUE,
                                                                         collapsible = FALSE,
                                                                         title = "Mapa de casos totals per habitant de COVID-19 a Catalunya per comarques:",
                                                                         
                                                                         leafletOutput("mapa_covid_total_density", height=750)
                                                                         
                                                                     )# End of big box per forecast selection
                                                              )#end of column
                                                            )#end of fluid row
                                                            
                                                            )
                                                   
                                       )
                                       
                                       
                              ),#end of tabpanel functionalities
                              tabPanel("Per municipis", 
                                       br(),
                                       fluidRow(
                                         column(12,
                                                #offset = 1,
                                                
                                                box(height=1200, 
                                                    width = 12,
                                                    solidHeader = TRUE,
                                                    collapsible = FALSE,
                                                    title = "Mapa de casos totals de COVID-19 a Catalunya detectats entre Març del 2020 i Juliol del 2022 per municipis:",
                                                    
                                                    leafletOutput("mapa_covid_total_municipis", height=750)
                                                    
                                                )# End of big box per forecast selection
                                         )#end of column
                                       )#end of fluid row
                              ),
                              tabPanel("Barcelona", 
                                       br(),
                                       fluidRow(
                                         column(12,
                                                #offset = 1,
                                                
                                                box(height=1200, 
                                                    width = 12,
                                                    solidHeader = TRUE,
                                                    collapsible = FALSE,
                                                    title = "Mapa de casos totals de COVID-19 a Barcelona:",
                                                    
                                                    leafletOutput("mapa_covid_barcelona", height=750)
                                                    
                                                )# End of big box per forecast selection
                                         )#end of column
                                       )#end of fluid row
                              )
                              
                  )
                
        ), #End JIRA menu content  
        
        tabItem(tabName = "dashboard",
                tabsetPanel(type = "tabs",
                            selected = "Anàlisi temporal",
                            tabPanel("Anàlisi temporal",
                                     br(),
                                     fluidRow(
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Evolució temporal dels casos de COVID-19 registrats"),
                                                  plotlyOutput('evol_temp', height = 'auto', width = 'auto')
                                              )
                                       ),
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Evolució temporal acumulada dels casos de COVID-19 registrats"),
                                                  plotlyOutput('evol_temp_acc', height = 'auto', width = 'auto')
                                                  
                                              )
                                       )
                                     ),
                                     fluidRow(
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Evolució temporal dels casos de COVID-19 registrats per tipus"),
                                                  plotlyOutput('evol_temp_tipus', height = 'auto', width = 'auto')
                                              )
                                       ),
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Evolució temporal dels casos de COVID-19 acumulats registrats per tipus"),
                                                  plotlyOutput('evol_temp_tipus_acc', height = 'auto', width = 'auto')
                                              )
                                       )
                                     )
                            ),
                            tabPanel("Altres anàlisis",
                                     br(),
                                     fluidRow(
                                       
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Densitat del covid respecte a la població total per comarques"),
                                                  plotlyOutput('densitat_comarques', height = 'auto', width = 'auto')
                                                  
                                              )
                                       ),
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Densitat del covid respecte a la població total per municpis"),
                                                  plotlyOutput('densitat_municipis', height = 'auto', width = 'auto')
                                              )
                                       )
                                     ),
                                     fluidRow(
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Casos totals per sexe"),
                                                  plotlyOutput('casos_sexe', height = 'auto', width = 'auto')
                                                  
                                              )
                                       ),
                                       column(6,
                                              box(height=500, 
                                                  width = 12,
                                                  solidHeader = TRUE,
                                                  collapsible = FALSE,
                                                  title = HTML("Mitjana de casos detectats per mes i comarca"),
                                                  plotlyOutput('mitjana_mes_comarca', height = 'auto', width = 'auto')
                                                  
                                              )
                                       )
                                     )
                            )
                )
                
                
        ),
        
        tabItem(tabName = "bib",
                shinyjs::useShinyjs(),
                column(12,
                       box(height=1400, 
                           width = 12,
                           solidHeader = TRUE,
                           collapsible = FALSE,
                           title = h2(HTML("A continuación se presentan las referencias bibliográficas utilizadas en el diseño y elaboración de la lógica del cálculo del riesgo de salud de esta aplicación:"))
                       )
                      )
                )
        
      ),#End of tabItems
      tags$footer(tags$hr(style="border-color: grey;"),
                  p(
                    #p("ShinyApp to be used internally by", strong("Statistical Forecasting Team"),align="center",width=4),
                    p(em("Creat per Arnau Muns Orenga"),align="center",width=4),
                    p(strong("Màster en Ciència de Dades - UOC - Visualització de dades"),align="center",width=4),
                    p(HTML(paste0(a('Contacte', href='mailto:arnau.muns12@gmail.com; ?subject="Shiny App COVID-19 a Catalunya"',
                                    target="_top"), 
                                  " per qualsevol dubte, pregunta o suggerència.")
                    ),align="center",width=4),
                    p(tags$img(src='uoc.png'),align="center")
                    
                  )
      )
    )#End of Body
  )#End of dashboardPage