#!/bin/bash

# File paths
MOVIE_FILE="tmdb-movies.csv"
SORTED_MOVIE_FILE="1-sorted_movies.csv"
HIGH_RATED_MOVIE_FILE="2-high_rated_movies.csv"
HIGHEST_REVENUE_FILE="3-highest-revenue.txt"
LOWEST_REVENUE_FILE="3-lowest-revenue.txt"
TOTAL_REVENUE_FILE="4-total_revenue.txt"
TOP_PROFITABLE_FILE="5-top_profitable.csv"
DIRECTOR_STATS_FILE="6-director_stats.txt"
ACTOR_STATS_FILE="7-actor_stats.txt"
GENRE_STATS_FILE="7-genre_stats.txt"
YEAR_STATS_FILE="8-year_stats.txt"
# 1. Sort the movies by release date in descending order and then save to a new file
csvsort -c release_date -r $MOVIE_FILE > $SORTED_MOVIE_FILE

# 2. Filter out movies with an average rating above 7.5 and save to a new file
awk -F',' '$18 > 7.5' $MOVIE_FILE > $HIGH_RATED_MOVIE_FILE

# 3. Find out which movies have the highest and lowest revenues
csvsort -c revenue -r tmdb-movies.csv | head -n 2 >$HIGHEST_REVENUE_FILE
csvsort -c revenue tmdb-movies.csv | head -n 2 >$LOWEST_REVENUE_FILE

# 4. Calculate the total revenue of all movies
awk -F',' 'NR > 1 {sum += $5} END {print "Total revenue:", sum}' $MOVIE_FILE > $TOTAL_REVENUE_FILE

# 5. Top 10 most profitable movies
csvsort -c revenue -r $MOVIE_FILE | head -n 11 > $TOP_PROFITABLE_FILE

# 6. Which director has the most films and which actor has acted in the most films?
awk -F',' 'NR > 1 {print $9}' $MOVIE_FILE | sort | uniq -c | sort -nr | head -n 2 > $DIRECTOR_STATS_FILE
awk -F',' 'NR > 1 {print $7}' $MOVIE_FILE | tr '|' '\n' | sort | uniq -c | sort -nr | head -n 2 > $ACTOR_STATS_FILE

# 7. Statistics on the number of movies by genre
awk -F',' 'NR > 1 {split($6,genres,"|");for(i in genres) print genres[i]}' tmdb-movies.csv |sort | uniq -c |sort -n -r   > $GENRE_STATS_FILE

# 8. Year most movie released
awk -F',' 'NR > 1 {print $19}' $MOVIE_FILE | sort | uniq -c | sort -n -r > $YEAR_STATS_FILE

echo "Data processing complete. Check the generated files for results."
