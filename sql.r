
# **** DPLYR VS SQL ****

# WE WILL REPLICATE ALL OF THE DPLYR FUNCTIONS USING SQL QUERIES OF THIS FORM
# SELECT column(s)
# FROM table
# WHERE conditions
# ORDER BY column(s)


require(sqldf)
require(dplyr)
require(tidyr)


# NYC TAXI HOURLY PICKUP DATA
rawdata <- read.csv("d:/taxiPickupsByHour.csv")

# head(rawdata)
#
# lat     lon     hour   num_pickups
# 40.748 -73.979   18       14527
# 40.769 -73.983   18       16856
# 40.743 -73.990   16        2267
# 40.764 -73.998   19        2467
# 40.747 -73.994   15       28033
# 40.728 -74.005    7        3221



# **** SQL NOTES ****
# 1) The convention is to use ALL CAPS FOR SQL KEYWORDS and lowercase for everything else.
# 2) The names of databases, tables, and columns should use lowercase letters, numbers,
#    and underscores only. **Do not use uppercase letters or dashes**
# 3) Double quotes are used to denote column names and table names. Single quotes are used
#    to denote strings.
# 4) It is proper syntax to end all SQL queries with a semicolon (;). Though, most of the
#    time, we will omit the them.



# REMOVE PICKUPS THAT HAPPENED OUTSIDE NYC (NYC'S BOUNDING BOX)
reduced <- filter(rawdata, lon > -74.26, lon < -73.69, lat > 40.47, lat < 40.92)
reducedSQL <- sqldf('SELECT * FROM rawdata WHERE lon > -74.26 AND lon < -73.69 AND lat > 40.47 AND lat < 40.92')

identical(reduced, reducedSQL)



# SORT BY num_pickups (JUST SO WE CAN SEE THE HIGHEST VALUES -- NOT NECESSARY FOR ANYTHING BELOW)  
sorted <- arrange(reduced, desc(num_pickups))
sortedSQL <- sqldf('SELECT * FROM reduced ORDER BY num_pickups DESC')

identical(sorted, sortedSQL)



# ADD A NEW COLUMN FOR THE HOUR VALUES
withHourLabel <- mutate(sorted, hour_label = paste("hour_",hour,sep = ""))

# For illustration purposes - we will not be using the || operator
withHourLabelSQL <- sqldf("SELECT *, 'hour_'||hour AS hour_label FROM sorted")

identical(withHourLabel, withHourLabelSQL)



# WE NO LONGER NEED THE "hour" COLUMN, SO REMOVE IT
hourValueRemoved <- select(withHourLabel,lat,lon,num_pickups,hour_label)
hourValueRemovedSQL <- sqldf("SELECT lat,lon,num_pickups,hour_label FROM withHourLabel")

identical(hourValueRemoved, hourValueRemovedSQL)



# CONVERT THE hour_label VALUES INTO COLUMNS
wideFormat <- spread(hourValueRemoved, key=hour_label, value=num_pickups)
# THIS IS POSSIBLE TO DO WITH SQL, BUT NOT FOR TODAY



# REPLACE NA VALUES WITH 0's 
NAsTo0s <- replace(wideFormat, is.na(wideFormat), 0)

# For illustration purposes - we will not be using COALESCE
longquery <- paste0("SELECT lat,lon,",
  "COALESCE(hour_0, 0 ) AS hour_0,COALESCE(hour_1, 0 ) AS hour_1,COALESCE(hour_10, 0 ) AS hour_10,COALESCE(hour_11, 0 ) AS hour_11,COALESCE(hour_12, 0 ) AS hour_12,COALESCE(hour_13, 0 ) AS hour_13,",
  "COALESCE(hour_14, 0 ) AS hour_14,COALESCE(hour_15, 0 ) AS hour_15,COALESCE(hour_16, 0 ) AS hour_16,COALESCE(hour_17, 0 ) AS hour_17,COALESCE(hour_18, 0 ) AS hour_18,COALESCE(hour_19, 0 ) AS hour_19,",
  "COALESCE(hour_2, 0 ) AS hour_2,COALESCE(hour_20, 0 ) AS hour_20,COALESCE(hour_21, 0 ) AS hour_21,COALESCE(hour_22, 0 ) AS hour_22,COALESCE(hour_23, 0 ) AS hour_23,COALESCE(hour_3, 0 ) AS hour_3,",
  "COALESCE(hour_4, 0 ) AS hour_4,COALESCE(hour_5, 0 ) AS hour_5,COALESCE(hour_6, 0 ) AS hour_6,COALESCE(hour_7, 0 ) AS hour_7,COALESCE(hour_8, 0 ) AS hour_8,COALESCE(hour_9, 0 ) AS hour_9 ",
  "FROM wideFormat")
NAsTo0sSQL <- sqldf(longquery);

identical(NAsTo0s, NAsTo0sSQL) # Not quite identical. The difference is the datatype of the hour_x columns.
typeof(NAsTo0s[1,]$hour_0)     #double
typeof(NAsTo0sSQL[1,]$hour_0)  #integer



# TRIM THE DATASET DOWN BY REMOVING ROWS WITH 0 PICKUPS IN HOUR 7 (ARBITRARY)
trimmed <- filter(NAsTo0s, hour_7 > 0)
trimmedSQL <- sqldf("SELECT * FROM NAsTo0s WHERE hour_7 > 0")

identical(trimmed, trimmedSQL)


# ONE MORE SORT (NOT NECESSARY)
finalSort <- arrange(trimmed, desc(hour_7))
finalSortSQL <- sqldf('SELECT * FROM trimmed ORDER BY hour_7 DESC')

identical(finalSort, finalSortSQL)



# Data frames and databases look very similar from the outside
# How are they different?
# In what scenarios would you prefer to use one over the other?


