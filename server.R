# Load packages
library(ggplot2)
library(ggmap)
library(lubridate)
library(reshape2)


# Load files (will be included in package)
load("fake_data.Rdata")
load("PEECmap.Rdata")

# Site coordinates
PEEC <- c(-74.914414, 41.171450) #lon, lat
A <- c(-74.5, 41.5)
B <- c(-75.5, 40.8)
site_coords <- data.frame(site=c("Alexander", "Buchanan", "PEEC"),
                          lat=c(41.5, 40.8, 41.17450),
                          lon=c(-74.5, -75.5, -74.914414))

# Bad curr data
full_data <- fake_data


shinyServer(function(input, output, session) {

  
  curr_data <- reactive({
    #n <- input$goButton # Don't use n
    site <- input$siteName
    #date <- ymd(input$date)
    date <- ymd("2015-06-15") #DEBUGGING
    chl <- input$chl
    abs <- input$abs400
    temp <- input$temp

    lat <- NA # THIS IS A CHEAP HACK, MUST FIX
    lon <- NA # THIS IS A CHEAP HACK, MUST FIX

    # The data that has just been added
    curr_data <- data.frame(site=site, date=date, chl=chl,abs=abs, temp=temp, lat=NA, lon=NA)
  })


  # Add entered data to the dataset
  add_data <- reactive({
    n <- input$goButton
    curr_df <- curr_data()
    curr_df$lat <- NA
    curr_df$lon <- NA
    fake_data <- rbind(fake_data, curr_data())
    fake_data
  })



#   clusters <- reactive({
#     kmeans(selectedData(), input$clusters)
#   })
  output$mapPlot <- renderPlot({
    # Old silly map method
#     ggmap(PEEC_map) +
#       geom_point(data=fake_data, aes(x=lon, y=lat), colour="white") +
#       geom_text(data=fake_data, aes(x=lon, y=lat, label=site),
#                 colour="white", hjust=0, vjust=0)
    ggmap(PEEC_map) + 
      geom_point(data=site_coords, aes(x=lon, y=lat), colour="white") + 
      geom_text(data=site_coords, aes(x=lon, y=lat, label=site), colour="white", hjust=0, vjust=0)
  })

  output$dataTable <- renderTable({
    n <- input$goButton
    curr_data <- curr_data()
    curr_data$date <- as.character(curr_data$date)
    curr_data[ ,1:5]
  })

  output$dataPlot <- renderPlot({
    
    # n <- input$goButton
    fake_data <- add_data()

    fake_data_m <- melt(fake_data, id.vars=c("site", "date", "lat", "lon"))

    ggplot(fake_data_m, aes(x=date, y=value, colour=site)) +
      geom_point() +
      geom_line() +
      facet_wrap(~variable, scales="free_y", nrow=3)
  })

})
