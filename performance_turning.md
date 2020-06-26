## How You Can and Can't Control Performance
One way to make a query run faster is to reduce the number of calculations that need to be performed. Some of the high-level things that will affect the number of calculations a given query will make include:

+ Table size
+ Joins
+ Aggregations

Query runtime is also dependent on some things that you can’t really control related to the database itself:

+ Other users running queries concurrently on the database
+ Database software and optimization (e.g., Postgres is optimized differently than Redshift)