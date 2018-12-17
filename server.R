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
shinyServer(function(input, output, session) {
  Dataset <- reactive({
    if (is.null(input$file)) { return(NULL) } 
    else{
      Data <- readLines(input$file$datapath)
      Data <- str_replace_all(Data,"<.*?>","")
      Data <- Data[Data!= ""]
      return(Data)
    }
  })
  english_model = reactive({
    english_model = udpipe_load_model("modfile.udpipe")
    return(english_model)
  })
  annot.obj = reactive({
    x <- udpipe_annotate(english_model(),x=Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  output$downloadData <- downloadHandler(
    filename = function(){
      "annotated_data.csv"
    },
    content = function(file){
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    }
  )
  output$anot = renderDataTable({
    if(is.null(input$file)){ return (NULL)}
    else {
      out = annot.obj()[,-4]
      return(out)
    }
  })
  output$plot1 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      all_nouns = annot.obj() %>% subset(., upos %in% "NOUN")
      top_nouns = txt_freq(all_nouns$lemma)
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3, colors = 1:10)
    }
  })
  output$plot2 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      all_verbs = annot.obj() %>% subset(., upos %in% "VERB")
      top_verbs = txt_freq(all_verbs$lemma)
      wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3, colors = 1:10)
    }
  })
  output$plot3 = renderPlot({
    if(is.null(input$file)){ return (NULL)}
    else {
      co_occ <- cooccurrence(
        x = subset(annot.obj(), upos %in% input$upos),
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

