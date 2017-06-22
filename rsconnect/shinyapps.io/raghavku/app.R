# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(base)
library(shiny)
library(digitize)
source("Graph2Data.R")
# To upload a file on the app

server <- shinyServer(function(input, output) {
  output$files <- renderTable(input$files)
  
  files <- reactive({
    files <- input$files
    files$datapath <- gsub("\\\\", "/", files$datapath)
    files
  })
  
  output$myImage <- renderImage({
    list(src = "graph.gif", 
         contentType = 'image/gif',
         width = 400,
         height = 200
    )
  }, deleteFile=FALSE)
  
  output$images <- renderUI({
    if(is.null(input$files)) return(NULL)
    
    image_output_list <- 
      lapply(1:nrow(files()),
             function(i)
             {
               imagename = paste0("image", i)
               imageOutput(imagename)
             })
  do.call(tagList, image_output_list)
  })
  
  mode <- reactive({
    mode <- input$mode
    ReadAndCal(files)
  })
  
  observe({
    if(is.null(input$files)) return(NULL)
    for (i in 1:nrow(files()))
    {
      print(i)
      local({
        my_i <- i
        imagename = paste0("image", my_i)
        print(imagename)
        output[[imagename]] <- 
          renderImage({
            list(src = files()$datapath[my_i],
                 alt = "Image failed to render")
          }, deleteFile = FALSE)
      })
    }
  })
})

ui <- shinyUI(fluidPage(
  titlePanel('Graph2Data'),
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = 'files', 
                label = 'Select an Image',
                multiple = TRUE,
                accept=c('image/png', 'image/jpeg')),
      
      
      #insert the button to download the file on main panel:
      
      selectInput("mode", "Choose Mode:", 
                  choices = c("Manual", "Automated")),
      radioButtons("filetype", "File type:",
                   choices = c("csv")),
      downloadButton('downloadData', 'Download Dataset')
      
    ),
    mainPanel(
      tableOutput('files'),
      uiOutput('images')
    )
  )
))

#To Download a file 

function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "iris" = iris,
           "cars" = mtcars)
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  # it should write out data to that filename.
  
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    
    filename = function() {
      paste(input$mode, input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",")
      
      # Write to a file specified by the 'file' argument
      
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
}


#Run the application

shinyApp(ui=ui,server=server)
