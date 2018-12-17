library("shiny")

shinyUI(
  fluidPage(
    
    titlePanel("UDPipe NLP workflow"),  # name the shiny app
    
    sidebarLayout(    # creates a sidebar layout to be filled in
      
      sidebarPanel(   # creates a panel struc in the sidebar layout
        
        # user reads input file into input box here:
        fileInput("file", 
                  "Upload data (csv file with header)"),
        
        
        
        #UDPipe use for other languages
        
        #textInput("text", label = h3("language Input"), value = "Enter language name in full for which UDPIPE has to be pulled"),
        
        #hr(),
        #fluidRow(column(3, verbatimTextOutput("value"))),
        
        #fileInput("udpipe", 
         #         "Upload udpipe"),
        
        
        #multiplecheckbox
        checkboxGroupInput("checkGroup", label=h3("XPOS Group"), choices= list(" Adjective(JJ)" = 1, 
                                                                               " Noun(NN)" = 2, 
                                                                               "ProperNoun(NNP)" = 3,
                                                                               " Adverb(RB)"= 4," 
                                                                               Verb(VB)"=5),
                                                                        selected = c(1,2,3))
        
      ),   # end of sidebar panel
      
      ## Main Panel area begins.
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
                    
                    tabPanel("Annotated ",
                             dataTableOutput('antd'),
                             br(),
                             br(),
                             downloadButton("downloadData","Final Annotated Data")),
                    tabPanel("Word Cloud Plots", 
                             h3("Adjective"),
                             plotOutput('plot1'),
                             h3("Noun"),
                             plotOutput('plot2'),
                             h3("ProperNoun"),
                             plotOutput('plot3')
                             ),  
                              
                    tabPanel("Co-ocuurrence graphs",
                             plotOutput('plot4')
                    ))# end of tabsetPanel
      ) # end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI