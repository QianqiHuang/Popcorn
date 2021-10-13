server <- function(input, output, session){

# ---------------------Data Exploration ----------------------------  
  output$pieplot <- renderUI({
    div(
      style = "position: relative; backgroundColor: #ecf0f5",
      tabBox(
        id = "box_pat",
        width = NULL,
        height = 300,
        tabPanel(
          title = "Genre Pie Plot",
          plotlyOutput("plot_pie", height = 400)
        ),
        tabPanel(
          title = "Top 10 Average Rate",
          plotlyOutput("averagerateplot", height = 400)
        )
        ,
        tabPanel(
          title = "Rate Frequency",
          plotlyOutput("frequencyplot", height = 400)
        )
      )
    )
  })
  
  output$plot_pie <- renderPlotly({
    
    newmovieid <-
      movies %>%
      filter( year < input$yearInput[2] & year > input$yearInput[1]) %>%
      mutate(t = select(., input$genreinput) %>% rowSums(na.rm=TRUE)) %>%
      filter(t != 0)
    
    
    movies %>%
      filter(movieId %in% newmovieid$movieId ) %>%
      select(input$genreinput) %>%
      colSums() %>% data.frame() %>% rownames_to_column() %>%
      plot_ly( labels = ~rowname, values = ~.,type = 'pie',
               textposition = 'inside',
               textinfo = 'label+percent',
               insidetextfont = list(color = '#FFFFFF'),
               hoverinfo = 'text',
               text = ~paste('movies number:', .),
               marker = list(line = list(color = '#FFFFFF', width = 1)),
               showlegend = FALSE
               )
  })

  output$averagerateplot <- renderPlotly({

    newmovieid <-
      movies %>%
      filter( year < input$yearInput[2] & year > input$yearInput[1]) %>%
      mutate(t = select(., input$genreinput) %>% rowSums(na.rm=TRUE)) %>%
      filter(t != 0)

    ratinglist <-
      rating %>%
      filter( movieId %in% newmovieid$movieId ) %>%
      group_by(movieId) %>%
      summarise(mean = mean(rating), n=n()) %>% data.frame() %>%
      filter(n>100) %>%
      mutate(rank = dense_rank(desc(mean))) %>%
      filter(rank<11) %>%
      arrange(rank) %>%
      left_join(newmovieid) %>%
      select(title,mean,rank)

    ratinglist$title <- factor(ratinglist$title, levels = ratinglist[["title"]])

    ratinglist %>%
      plot_ly(y=~reorder(title,mean),x=~mean,type="bar",text=~paste('movie rating rank: ',rank),orientation='h') %>%
      layout(yaxis = list(title = ""), xaxis = list(title = 'Average Rating',range=c(0,5),dtick=1),margin = list(l = 220,r=50))
  })


  output$frequencyplot <- renderPlotly({
    
    newmovieid <-
      movies %>%
      filter( year < input$yearInput[2] & year > input$yearInput[1]) %>%
      mutate(t = select(., input$genreinput) %>% rowSums(na.rm=TRUE)) %>%
      filter(t != 0)
    
    frelist <-
      rating %>%
      filter( movieId %in% newmovieid$movieId ) %>%
      group_by(movieId) %>%
      summarise(percent=n()*100/610) %>% data.frame() %>%
      mutate(rank = dense_rank(desc(percent))) %>%
      filter(rank<11) %>%
      arrange(rank) %>%
      left_join(newmovieid) %>%
      select(title,percent,rank)
    
    frelist$title <- factor(frelist$title, levels = frelist[["title"]])
    
    frelist %>%
      plot_ly(y=~reorder(title,percent),x=~percent,type="bar",text=~paste(percent, '% users rate this movie'),orientation='h') %>%
      layout(xaxis = list(title = '% / Percentage of users',range=c(0,60)),
             yaxis = list(title = ''),margin = list(l = 250,r=50))
  })

  
  
  
  
  # ---------------------Movie Search ----------------------------  
  
  
  output$moviesearch <- renderUI({
    div(
      style = "position: relative; backgroundColor: #ecf0f5",
      tabBox(
        id = "m_search",
        width = NULL,
        height = 300,
        tabPanel(
          title = "Movie Information",
          tags$head(tags$style(HTML(".small-box {height: 100px}"))),
          valueBoxOutput("IMDBlink",width=6),
          valueBoxOutput("selectmovieyear",width=6),
          valueBoxOutput("selectgenrename",width=12),
          valueBoxOutput("numofrate",width=12)
        ),
        tabPanel(
          title = "Rate Violin Plot",
          plotlyOutput("plot_violin", height = 400)
        )
      )
    )
  })
  
  output$selectgenrename <- renderValueBox({

    newmoviedf <-
      movies %>% filter(title == input$moviename) %>% filter( year == max(year)) %>% select(!(movieId:year))
    
    listgenre <-
      names(which(colSums(newmoviedf) > 0))
    
    if (length(listgenre) > 3) {
      oneline <- paste(listgenre[1:3],collapse ='|')
      twoline <- paste(listgenre[4:length(listgenre)],collapse='|')
    } else {
      oneline <- paste(listgenre[1:length(listgenre)],collapse ='|')
      twoline <- ""
    }
    
    valueBox(
      
      value = tags$p(oneline,tags$br(),twoline,style = "font-size: 60%;"),
      subtitle = "Genres",
      icon = icon("archive"),
      color = "light-blue")
  })
  
  output$selectmovieyear <- renderValueBox({

    inputmovieyear <-
      movies %>% filter(title == input$moviename) %>% filter( year == max(year)) %>% select(year) %>% as.numeric()

    valueBox(
      inputmovieyear,
      "Year",
      icon = icon("calendar-alt"),
      color = "aqua")
  })
  
  output$IMDBlink <- renderValueBox({
    
    movieid <-
      movies %>% filter(title == input$moviename) %>% filter( year == max(year)) %>% select(movieId) %>% as.numeric()

    linkid <-
      links %>% filter(movieId == movieid) %>% select(imdbId) %>% as.character()
    
    wholelink <- paste( "http://www.imdb.com/title/tt", linkid,"/", sep = "")

    valueBox(
      value = tags$p(input$moviename,style = "font-size: 60%;"),
      "Click Above to enter IMDb",
      icon = icon("link"),
      color = "teal",
      href = wholelink)
  })
  
  output$numofrate <- renderValueBox({
    
    movieid <-
      movies %>% filter(title == input$moviename) %>% filter( year == max(year)) %>% select(movieId) %>% as.numeric()
    
    usernum <-
      rating %>% filter(movieId == movieid) %>% summarise(n=n()) %>% as.numeric()
    
    valueBox(
      value = usernum,
      tags$p("users rate this movie",style = "font-size: 120%;"),
      icon = icon("thumbs-up"),
      color = "blue")
  })
  
  output$plot_violin <- renderPlotly({
    
    movieinfo <-
      movies %>% filter(title == input$moviename) %>% filter( year == max(year)) %>% select(movieId,title)
    
    rating %>% filter(movieId == movieinfo$movieId) %>% 
      select(movieId,rating) %>% 
      left_join(movieinfo) %>%
      plot_ly(x=~title,y=~rating, type = 'violin',    
              meanline = list(visible = T)) 
  })
  
  
  # ---------------------Movie Recommendation ----------------------------  
  
  
  output$moviereco <- renderUI({
    div(
      style = "position: relative; backgroundColor: #ecf0f5",
      tabBox(
        id = "m_reco",
        width = NULL,
        height = 300,
        tabPanel(
          title = "Movie Recommendation",
          DT::dataTableOutput("table_reco", height = 300),
        ),
        tabPanel(
          title = "User Rating",
          DT::dataTableOutput("table_ori", height = 300),
        )
      )
    )
  })
  
  
  table_re <- reactive({

    titlelink <-
      movies %>% select(movieId,title,genres,year)
    
    set_table <-
      dlresult %>% filter(user == input$inputuserid) %>%
      select(item,rank,user,score)  %>%
      rename(movieId = item) %>%
      left_join(titlelink) %>%
      drop_na() %>%
      head(input$topn) %>%
      mutate(rank=1:input$topn)
    
    datatable(
      set_table, 
      rownames = FALSE, 
      extensions = "Buttons",
      options = list(
        dom = 'Bfrtp',
        style = "bootstrap",
        lengthMenu = c(seq(10, 150, 5))
      )
    )
  })
  
  output$table_reco <- DT::renderDataTable({
    table_re()
  }, server = FALSE)
  
  table_ori <- reactive({
    
    titlelink <-
      movies %>% select(movieId,title,genres,year)
    
    set_table_ori <-
      rating %>% filter(userId == input$inputuserid) %>%
      select(userId,movieId,rating) %>%
      arrange(desc(rating)) %>%
      left_join(titlelink) %>%
      drop_na()
    
    datatable(
      set_table_ori, 
      rownames = FALSE, 
      extensions = "Buttons",
      options = list(
        dom = 'Bfrtp',
        style = "bootstrap",
        lengthMenu = c(seq(10, 150, 5))
      )
    )
  })
  
  output$table_ori <- DT::renderDataTable({
    table_ori()
  }, server = FALSE)
  
  
}