library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",
  title = "MoviesLib",
  
  # HEADER ------------------------------------------------------------------
  dashboardHeader(
    title = span("POPCORN Recommender"),
    titleWidth = 300,
    dropdownMenu(
      type = "notifications", 
      headerText = strong("HELP"), 
      icon = icon("question"), 
      badgeStatus = NULL,
      # change text and icon, help info for three modules 
      notificationItem(
        text = tags$div(tags$b("Data Exploration"),br(),style = "display: inline-block; vertical-align: top;",
                      "Select desired year range and genres, ",
                      br(),"to see the genres percentage,",br(),
                      "top 10 average rate movies and" ,br(),
                      "top 10 most rated movies."),
        icon = icon("database")
      ),
      notificationItem(
        text = tags$div(tags$b("Movie Search"),br(),style = "display: inline-block; vertical-align: top;",
                        "Correctly input the name of movie",
                        br(),"to see its year, genres and number of",br(),
                        "user rating the movie.",br(),
                        "A violin plot also helps to see its",br(),"rating distribution."),
        icon = icon("search")
      ),
      notificationItem(
        text = tags$div(tags$b("Movie Recommendation"),br(),style = "display: inline-block; vertical-align: top;",
                        "Input the MovieLens user ID and movie" ,br()," number to obtain the TOP N movie ",
                        br(),"recommendation list genrated by",br(),"Deep Learning model.",br(),
                        "History Rating of the input user will",br(),
                        "be also shown"),
        icon = icon("ello")
      )
    ),
    tags$li(
      #tag$a?
      a(
        strong("ABOUT MovieLens Dataset"),
        height = 40,
        href = "https://files.grouplens.org/datasets/movielens/ml-latest-small-README.html",
        title = "",
        target = "_blank"
      ),
      class = "dropdown"
    )
  ),
 
  
  # SIDEBAR -----------------------------------------------------------------
  
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      
      menuItem("Movie Recommendation",tabName = "movierecommend", icon = icon("ello"),
               numericInput(
                 inputId = "inputuserid",
                 label = "Please input the user ID:",
                 value = 1,
                 min = 1,
                 max = 610,
                 step = 1
               ),
               numericInput(
                 inputId = "topn",
                 label = "Please input the number of top recommended movies:",
                 value = 10,
                 min = 0,
                 max = 100,
                 step = 5
               )
      ),
      br(),
      br(),
      menuItem("Movie Search",tabName = "search", icon = icon("search"),
               textInput(
                 inputId = "moviename",
                 placeholder = "Movie Name",
                 label = "Please input the full movie name:",
                 value = "Toy Story"
               )
      ),
      br(),
      br(),
      menuItem("Data Exploration",tabName = "dataexploration", icon = icon("database"),
               sliderInput(
                 inputId = "yearInput",
                 label = "Movie Year",
                 value = c(1900,2019),#movie years range, value is the default range
                 min = 1900,
                 max = 2019,
                 step = 1L,
                 sep = ""
               ),
               selectizeInput(
                 inputId = "genreinput",
                 label = "Movie Genres",
                 choices = c("Action","Adventure","Animation","Children","Comedy","IMAX",
                             "Crime","Documentary","Drama","Fantasy","Film-Noir","Horror",
                             "Musical","Mystery","Romance","Sci-Fi","Thriller","War","Western","(no genres listed)"),
                 multiple = TRUE,
                 selected = "Action"
               )
      ),
      br(),#强制回车，可能不需要
      br()

      # menuItem("Movie Recommendation",tabName = "movierecommend", icon = icon("ello"),
      #          selectizeInput(
      #            inputId = "genreinputforreco",
      #            label = "Choose Your preferred genres (multiple choose):",
      #            choices = c("Action","Adventure","Animation","Children","Comedy","IMAX",
      #                        "Crime","Documentary","Drama","Fantasy","Film-Noir","Horror",
      #                        "Musical","Mystery","Romance","Sci-Fi","Thriller","War","Western","(no genres listed)"),
      #            multiple = TRUE
      #          ),
      #          selectizeInput(
      #            inputId = "movieinputforreco",
      #            label = "Choose Your preferred movies from the below list (multiple choose):",
      #            choices = c(),#c(levels(as.factor(admissions$sub_specialty))) movie
      #            multiple = TRUE
      #          )
      # ),

    )
  ),
  
  
  # MAINBODY -----------------------------------------------------------------
  
  dashboardBody(
    fluidRow(
      box(
        width = 12,
        title = "Movie Recommendation",
        uiOutput("moviereco"),
        height = 600
      ),
      box(
        width = 6,
        title = "Movie Search",
        uiOutput("moviesearch"),
        height = 550
      ),
      box(
        width = 6,
        title = "Data Exploration",
        uiOutput("pieplot"),
        height = 550
      )


    )
  )
  

)

