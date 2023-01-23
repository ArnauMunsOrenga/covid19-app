shinyServer(function(input, output,session) {
  
  output$mapa_covid_total <- renderLeaflet({
    leaflet(covid_data_comarques_total) %>%
      setView(1.647020, 41.690635, zoom = 8) %>% 
      addTiles() %>%
      addCircles(lng = ~longitud, lat = ~latitud, weight = 1,
                 radius = ~sqrt(num_casos) * 30, popup = ~paste(comarca_descripcio, "<br/>"," # Casos: ", num_casos)
      )
  })
  
  output$mapa_covid_total_density <- renderLeaflet({
    leaflet(covid_data_comarques_densitat) %>%
      setView(1.647020, 41.690635, zoom = 8) %>% 
      addTiles() %>%
      addCircles(lng = ~longitud, lat = ~latitud, weight = 1,
                 radius = ~ sqrt(densitat_covid) * 3000, popup = ~paste(comarca_descripcio, "<br/>"," # Casos per habitant: ", densitat_covid)
      )
  })
  
  output$mapa_covid_total_municipis <- renderLeaflet({
    leaflet(covid_data_municipis_total) %>%
      setView(1.647020, 41.690635, zoom = 8) %>% 
      addTiles() %>%
      addCircles(lng = ~longitud, lat = ~latitud, weight = 1,
                 radius = ~sqrt(num_casos) * 30, popup = ~paste(municipi_descripcio, "<br/>"," # Casos: ", num_casos)
      )
  })
  
  output$mapa_covid_barcelona <- renderLeaflet({
    leaflet(covid_barcelona) %>%
      setView(2.162149, 41.397814, zoom = 13) %>% 
      addTiles() %>%
      addCircles(lng = ~longitud, lat = ~latitud, weight = 1,
                 radius = ~sqrt(total_casos)*3, popup = ~paste(districte_descripcio, "<br/>"," # Casos: ", total_casos)
    )
  })
  
  #line charts
  
  output$evol_temp <- renderPlotly(
   plot_ly(evolucio_total, x = ~any_mes, y = ~total_mes, type = 'scatter', mode = 'lines')
  )
  
  output$evol_temp_acc <- renderPlotly(
    plot_ly(evolucio_total_acumulada, x = ~any_mes, y = ~total_acumulat, type = 'scatter', mode = 'lines')
  )
  
  output$evol_temp_tipus <- renderPlotly(
    plot_ly(evolucio_total_per_tipus %>% ungroup(), x = ~any_mes, y = ~total_mes, color = ~tipus_cas_descripcio, type = 'scatter', mode = 'lines')
  )
  
  output$evol_temp_tipus_acc <- renderPlotly(
    plot_ly(evolucio_total_per_tipus_acumulada %>% ungroup(), x = ~any_mes, y = ~total_acumulat, color = ~tipus_cas_descripcio, type = 'scatter', mode = 'lines')
  )
  
  #pie chart
  output$casos_sexe <- renderPlotly(
    plot_ly(casos_x_sexe, labels = ~sexe_descripcio, values = ~total_mes, type = 'pie',
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            text = ~paste(total_mes, ' casos'),
            marker = list(colors = colors,
                          line = list(color = '#FFFFFF', width = 1)),
            #The 'pull' attribute can also be used to create space between the sectors
            showlegend = FALSE)
  )
  
  output$densitat_municipis <- renderPlotly(
    plot_ly(
      data = covid_data_municipis_densitat,
      x = ~municipi_descripcio,
      y = ~densitat_covid,
      type = "bar"
    )%>% 
      layout(xaxis = list(categoryorder = "total descending"))
  )
  output$densitat_comarques <- renderPlotly(
    plot_ly(
      data = covid_data_comarques_densitat,
      x = ~comarca_descripcio,
      y = ~densitat_covid,
      type = "bar"
    )%>% 
      layout(xaxis = list(categoryorder = "total descending"))
  )
  
  output$mitjana_mes_comarca <- renderPlotly(
    plot_ly(
      data = mitjana_casos_comarca_mes,
      x = ~comarca_descripcio,
      y = ~mitjana_casos_mes,
      type = "bar"
    )%>% 
      layout(xaxis = list(categoryorder = "total descending"))
  )
  
})
