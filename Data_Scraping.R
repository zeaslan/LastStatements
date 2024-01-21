# This R script scrapes last statements by Texas death row inmates from https://www.tdcj.texas.gov/death_row/dr_executed_offenders.html

# Load required packages
library(rvest)
library(tidyverse)
library(glue)
library(here)

# LAST STATEMENTS

# Create a function that scrapes last statements
statement_importer <- function(url){
  
  # Get the HTML page
  url_contents <- read_html(x = glue("https://www.tdcj.texas.gov/death_row/", url))
  
  # Get the inmate ID number
  ID <- html_elements(url_contents, css = "p:nth-child(9)") %>%
    html_text2() %>%
    str_extract_all(pattern = "[[:digit:]]") %>%
    unlist() %>%
    str_flatten() %>%
    as.numeric()
  
  # Get the statement 
  statement <- html_elements(url_contents, css = "p:nth-child(11)") %>%
    html_text2()
  
  # For some profiles last statement is coded differently
  if(is_empty(statement) == TRUE) {
    statement <- html_elements(url_contents, css = "p:nth-child(7)") %>%
    html_text2()
  } else {
    statement <- statement
  }
  
  # Create a data frame 
  statement_df <- tibble(
    ID = ID,
    Statement = statement
  )
  
  return(statement_df)
}

# Collect the URLs for each inmate 
paths_url <- read_html(x = "https://www.tdcj.texas.gov/death_row/dr_executed_offenders.html")

inmate_links <- html_elements(paths_url, css = "td:nth-child(3) a") %>%
  html_attr('href') %>%
  str_remove_all("/death_row/")

# Iterate over each inmate's URL to create a final data frame
statement_df <- map_df(inmate_links, statement_importer)

# Not all last statements are coded with inmate's ID number 
# Will use the row number as the identifier instead

statement_df <- statement_df %>%
  mutate(Execution = c(573:1))


# INMATE INFORMATION

# Get the HTML page
url_contents <- read_html(x = "https://www.tdcj.texas.gov/death_row/dr_executed_offenders.html")
  
# Get the info table
info_df <- html_elements(url_contents, css = ".indent , td, th") %>%
  nth(1) %>%
  html_table(header = TRUE) %>%
  select(-Link) 
  


# FINAL COMBINED DATA

# Merge the two data frames
death_row <- left_join(info_df, statement_df, by = "Execution")


# Check if the ID columns match and then remove the redundant ID column 
death_row <- death_row %>%
  select(-ID)

# Save the data frame as a csv file
write_csv(death_row, file = here("death_row.csv"))  

