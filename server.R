#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
options(shiny.maxRequestSize=30*1024^2)

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  Dataset <- reactive({
    
    if (is.null(input$file)) { return(NULL) } else
      {
        Data <- readLines(input$file$datapath)
        Data <- str_replace_all(Data,"<.*?>","")
        Data <- Data[Data!= ""]
        return(Data)
    }  # else stmt ends
    
  })  # reactive stmt ends
  
  #udpipe upload
  #model <- reactive({
   # lang <- renderText(input$text)
    #lang<- str(lang)
    #mod <- udpipe_download_model(language = lang)
    #model = udpipe_load_model(mod)
    #return(model)
  #})
  
  
  #output$mod<- renderPrint({str(input$udpipe)})
    model = reactive({
    model = udpipe_load_model("modfile.udpipe")
    return(model)
  })
  
  #Annotation etc
  annot.obj = reactive({
    x <- udpipe_annotate(model(),x=Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){
      "finalAnnotated.csv"
    },
    content = function(file){
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    }
  )
  output$antd = renderDataTable({
    if(is.null(input$file)){ return (NULL)}
    else {
      out = annot.obj()[,-4]
      return(out)
    }
  })
  
  #" Adjective(JJ)" = 1, " Noun(NN)" = 2, "ProperNoun(NNP)" = 3," Adverb(RB)"= 4," Verb(VB)"=5

  
  output$plot1 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      all_adjectives = annot.obj() %>% subset(., checkGroup %in% 1)
      top_adjectives = txt_freq(all_adjectives$lemma)
      wordcloud(top_adjectives$key,top_adjectives$freq, min.freq = 3, colors = 1:10)
    }
  })
  
  output$plot2 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      all_nouns = annot.obj() %>% subset(., checkGroup %in% 2)
      top_nouns = txt_freq(all_nouns$lemma)
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3, colors = 1:10)
    }
  })
  output$plot3 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      PPNs = annot.obj() %>% subset(., checkGroup %in% 3)
      top_PPNs = txt_freq(PPNs$lemma)
      wordcloud(top_PPNs$key,top_PPNs$freq, min.freq = 3, colors = 1:10)
    }
  })
  output$plot4 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      co_occ <- cooccurrence(
        x = subset(annot.obj(), checkGroup %in% input$checkGroup),
        term = 'lemma',
        group = c("doc_id","paragraph_id","sentence_id"))
      wordnet <- head(co_occ, 50)
      wordnet <- igraph::graph_from_data_frame(wordnet)
      ggraph(wordnet, layout = 'fr')+
        geom_edge_link(aes(width = cooc,edge_alpha = cooc), edge_colour = "orange")+
        geom_node_text(aes(label = name),col = "darkgreen",size = 4)+
        theme_graph(base_family = "Arial Narrow")+
        theme(legend.position = "none")+
        labs(title = " Cooccurrences Plot", subtitle = "  Co-occurence graph of selected" )
    }
  })
})

