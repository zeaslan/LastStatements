#   Last Statements

## Overview

The finalized report [here](./Last_Statements.md) uses data that is scraped from [Texas Department of Criminal Justice](https://www.tdcj.texas.gov/death_row/dr_executed_offenders.html) to analyze the last statements of death row inmates. In order to reproduce the scraped `death_row.csv` data, you should, first of all, run the script [here](./Data_Scraping.R). 

The report includes the following text analyses techniques: 

- Topic Modeling 
- Predictive Modeling (i.e., predicting an outcome of interest from text features)
- Sentiment Analyses

### Required Packages 

You should have following packages installed:

```
library(tidyverse)
library(tidytext)
library(textrecipes)
library(topicmodels)
library(here)
library(ggwordcloud)
library(textdata)
library(tidymodels)
library(themis)
library(ranger)
library(kableExtra)
library(rvest)
library(glue)
```