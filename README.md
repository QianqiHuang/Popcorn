## capstone-project-QianqiHuang
capstone-project-QianqiHuang created by GitHub Classroom

# POPCORN: A Movie Recommender System
Have you ever wanted to watch a new movie but didn't know which one to get?  

Use this app and find movies with your taste!  

ShinyAPP Link here: https://qianqi-huang.shinyapps.io/DS-finalproject/
  
Presentation video Link here: https://livejohnshopkins-my.sharepoint.com/:v:/g/personal/qhuang35_jh_edu/EcHzsekbJeRHs61V9JHe-DEB4ewRd2y64ob-BhnoBn65mw?e=VmSkG4

## Data Source:
https://grouplens.org/datasets/movielens/1m/  

MovieLens 1M Dataset describes 5-star rating and free-text tagging activity from MovieLens, a movie recommendation service. It contains 100836 ratings and 3683 tag applications across 9742 movies created by 610 users between March 29, 1996 and September 24, 2018.  

All users had rated at least 20 movies. Each user is represented by an ID, and no other information is provided. The data are contained in the files links.csv, movies.csv, ratings.csv and tags.csv. More details can be found in the `Data Exploration` section.

## Prerequisites for using POPCORN:
POPCORN Recommender System was built with R and Python. 
The recommendation algorithm is implemented with Python and the results are saved in the csv file to feed into R programming.  

We used Shinyapps.io to host our website. The required R packages are listed in `dependencies.R`. All required codes are avaiable in this repo. 

After downloading the `DS-finalproject` and dataset, using `runApp()` would directly enable the POPCORN Recommender. 


## How the app works:
### Data Exploration: 
Select desired year range and genres to see the genres percentage, top 10 average rate movies and top 10 most rated movies.
### Movie Search: 
Search the specific movie name you are interested in, 
you can check the detailed information of the movie, such as genres, year. 
You can also access the IMDb page of this movie through our app.
### Movie Recommendation: 
Input your user ID and the number of how many movies you want Popcorn to recommend, you can then have a list of movies with your taste! 
Also, other users’ rating information is available.

![Fig1](/figs/popcorn1.png)

## Recommendation Algorithm:
Neural Collaborative filtering (NCF) is based on the user/item historical interactions. 
Users are represented by their interactions with items, which in our recommender system is the user rating in MovieLens dataset. 
As the below Figure shows, NCF used the multi-layer perceptron to learn the user–item implicit feedback interaction function and output prediction scores. 
We would use these predicted scores to rank the movies and make the recommendation list.  

<img src="https://github.com/ds4ph-bme/capstone-project-QianqiHuang/blob/main/figs/ncfworkflow.png" width=400>


## Contribution:
Qianqi Huang: Shiny App & Recommendation algorithm implementation. 

Zixuan Wang: Recommendation algorithm implementation & Data visualization. 

Ruijing Zhang: Shiny App Revision & Data collection





