
require(RPostgreSQL) #https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf
require(ggplot2)

drv <- dbDriver("PostgreSQL")

# connect to the database
con <- dbConnect(drv, dbname = "musa620",
                 host = "localhost", port = 5432,
                 user = "postgres", password = '')


# SQL command to create a new table
sqlCommand <- paste0("CREATE TABLE cartable (carname character varying NOT NULL,",
  "mpg numeric(3,1),",
  "cyl numeric(1,0),",
  "disp numeric(4,1),",  
  "hp numeric(3,0),",
  "drat numeric(3,2),",
  "wt numeric(4,3),",
  "qsec numeric(4,2),",
  "vs numeric(1,0),",
  "am numeric(1,0),",
  "gear numeric(1,0),",
  "carb numeric(1,0),",
  "CONSTRAINT cartable_pkey PRIMARY KEY (carname)) WITH (OIDS=FALSE);")


# run the SQL command to create the table
dbGetQuery(con, sqlCommand)


# create some test data to load into the table
data(mtcars)
carData <- data.frame(carname = rownames(mtcars), 
                 mtcars, 
                 row.names = NULL)
carData$carname <- as.character(carData$carname)


# import the data into the table "cartable" in the "musa620" database  
dbWriteTable(con, "cartable", value = df, append = TRUE, row.names = FALSE)


# run a SQL query for all of the data in cartable
queryResult <- dbGetQuery(con, "SELECT * from cartable")
head(queryResult)


# plot the results
ggplot(queryResult, aes(x = hp, y = mpg)) + 
  geom_point(aes(size = wt, colour = as.factor(cyl), alpha=0.5)) +
  theme_bw()

