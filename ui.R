shinyUI(pageWithSidebar(
  headerPanel('Example data viewer for PEEC/UT brownification project'),
  sidebarPanel(
    #selectInput('xcol', 'X Variable', names(iris)),
    #selectInput('ycol', 'Y Variable', names(iris),
    #            selected=names(iris)[[2]]),
    selectInput('siteName', label="Site name",
                choices=c("Adams High"="Adams",
                          "Buchanan Middle"="Buchanan",
                          "PEEC"="PEEC")),
    dateInput(inputId="dt", label="Date collected",
              value=NULL, min="2015-06-23", max="2018-12-31"),
    numericInput('abs400', 'Color (abs400), AU',
                 value=NA, min=0, max = NA),
    numericInput('chl', 'Chlorophyll, ug/L',
                 value=NA, min = 0, max = NA),
    numericInput('temp', "temperature, C",
                 value=NA, min=NA, max=NA),
    actionButton("goButton", "Add to dataset")
  ),
  mainPanel(
    plotOutput('mapPlot'),
    tableOutput('dataTable'),
    plotOutput('dataPlot')
  )
))
