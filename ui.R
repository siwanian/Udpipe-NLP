library("shiny")

shinyUI(
  fluidPage(
    
    titlePanel("UDPipe NLP workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file",label = "Upload text file"),
        
        checkboxGroupInput("upos", 
                           label = h3("Select UPS for Co-occurrences Filtering"),
                           choices = list("adjective" = "ADJ",
                                          "noun" = "NOUN",
                                          "proper noun" = "PROPN",
                                          "adverb"= "ADV",
                                          "verb" = "VERB"),
                           selected = c("NOUN","VERB")
        )
      ),# end of sidebar panel
      
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             br(),
                             p("This app is to demonstrate the UDPipe NLP Workflow "),
                             br(),
                             h4('How to use this App'),
                             p("Please upload a text file from the left side panel by clicking on browse button"),
                             h4('Hint'),
                             p(span(strong(" 1) We suggest make use of smaller size text files"))),
                             p(span(strong(" 2) This app takes time to load the respective tab content. So Kindly wait for sometime so that the content is displayed on respective tab.",align="justify")))
                    ),
                    
                    tabPanel("annotated documents",
                             dataTableOutput('anot'),
                             br(),
                             br(),
                             downloadButton("downloadData","Download Annotated Data")),
                    tabPanel("Word Cloud Plots", 
                             h3("Nouns"),
                             plotOutput('plot1'),
                             h3("Verbs"),
                             plotOutput('plot2')),         
                    tabPanel("Co-ocuurrence graphs",
                             plotOutput('plot3')
                    )
        )# end of tabsetPanel
      ) # end of main panel
    )# end of sidebarLayout
  ) # end if fluidPage
) # end of UI