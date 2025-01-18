# BigQuery

You are using Google BigQuery studio working on a project (project id: food-delivery-432217). 

Under data set "ubereats_shoplist", write the SQL query to list all tables with names starting with "2024-9". Stack all the tables vertically and saved it under data set "ubereats_shoplist_stack" with the table name "2024-9".

##

Given 

```sql
DECLARE yyyymm STRING DEFAULT '2024-9';
```

Create a string `destiation_table` that has the value "`food-delivery-432217.ubereats_shoplist_stacked.2024-9`".

## 

Modify the following SQL so that it creates a table at the destination specified in  `destiation_table`:
```sql
EXECUTE IMMEDIATE 'CREATE TABLE {{detination_table}} AS ' || sql_query;
```

EXECUTE IMMEDIATE 'CREATE TABLE `food-delivery-432217.ubereats_shoplist_stacked.2024-9` AS ' || sql_query;

# bdplyr

You are using R to working datasets in BigQuery. You use `tidyverse` and `bigrquery` packages. 

You connect to the project through the following code:

```r
library(dplyr)
library(bigrquery)
library(DBI)
project_id = "food-delivery-432217"


# create a connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = project_id,
  dataset = dataset_id
)

# Get all the table names
tables <- dbListTables(con)
```

Objects that are not defined above are treated as existing in the global environment.

You will be asked for some tasks to working on the project. If you understand, say "yes".

## Workflow

Create a work flow that will Upload all csv files in a google drive folder to BigQuery

