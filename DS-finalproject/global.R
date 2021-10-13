
source('dependencies.R')

links <- read_csv("ml-latest-small/links.csv")
movies <- read_csv("ml-latest-small/movies.csv")
rating <- read_csv("ml-latest-small/ratings.csv")
dlresult <- read_csv("ml-latest-small/dlresult.csv")
dlresult <- dlresult %>% mutate(user = user+1)
genre <- c("Action","Adventure","Animation","Children","Comedy","IMAX",
           "Crime","Documentary","Drama","Fantasy","Film-Noir","Horror",
           "Musical","Mystery","Romance","Sci-Fi","Thriller","War","Western","(no genres listed)")


  