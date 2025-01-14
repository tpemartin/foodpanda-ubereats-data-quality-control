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