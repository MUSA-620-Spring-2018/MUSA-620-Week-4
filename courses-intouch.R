

require(RPostgreSQL)
require(ggplot2)

drv <- dbDriver("PostgreSQL")

# connect to the database
con <- dbConnect(drv, dbname = "upenn",
                 host = "localhost", port = 5432,
                 user = "postgres", password = '')




# Create enrollment table
sqlCommand <- paste0("CREATE TABLE enrollment (",
                     "student_id NUMERIC,",
                     "course_id VARCHAR,",
                     "term VARCHAR,",
                     "letter_grade VARCHAR,",
                     "numeric_grade NUMERIC,",
                     "PRIMARY KEY (student_id,course_id,term)",
                     ")")
dbGetQuery(con, sqlCommand)


# Create semester_roster table
sqlCommand <- paste0("CREATE TABLE semester_roster (",
                     "course_id VARCHAR,",
                     "term VARCHAR,",
                     "time VARCHAR,",
                     "room VARCHAR,",
                     "PRIMARY KEY (course_id,term)",
                     ")")
dbGetQuery(con, sqlCommand)


# Create students table
sqlCommand <- paste0("CREATE TABLE students (",
                     "student_id NUMERIC,",
                     "name VARCHAR,",
                     "major VARCHAR,",
                     "email VARCHAR,",
                     "PRIMARY KEY (student_id)",
                     ")")
dbGetQuery(con, sqlCommand)


# Create courses table
sqlCommand <- paste0("CREATE TABLE courses (",
                     "course_id VARCHAR,",
                     "course_title VARCHAR,",
                     "instructor VARCHAR,",
                     "PRIMARY KEY (course_id)",
                     ")")
dbGetQuery(con, sqlCommand)


enrollment <- read.csv('d:/enrollment.csv', stringsAsFactors = FALSE)
semester_roster <- read.csv('d:/semester_roster.csv', stringsAsFactors = FALSE)
students <- read.csv('d:/students.csv', stringsAsFactors = FALSE)
courses <- read.csv('d:/courses.csv', stringsAsFactors = FALSE)

dbWriteTable(con, "enrollment", value = enrollment, append = TRUE, row.names = FALSE)
dbWriteTable(con, "semester_roster", value = semester_roster, append = TRUE, row.names = FALSE)
dbWriteTable(con, "students", value = students, append = TRUE, row.names = FALSE)
dbWriteTable(con, "courses", value = courses, append = TRUE, row.names = FALSE)


# BASIC QUERY
# List all of the students
sqlCommand <- paste0("SELECT * ",
                     "FROM students")
dbGetQuery(con, sqlCommand)


# THE "WHERE" CLAUSE
# What classes were offered in Fall 2017?
sqlCommand <- paste0("SELECT * ",
                     "FROM semester_roster ",
                     "WHERE term = 'Fall 2017'")
dbGetQuery(con, sqlCommand)



# AGGREGATE FUNCTIONS (SUM,AVG,COUNT,MIN,MAX)
# What is the overall average GPA (on a 0-100 scale)?
sqlCommand <- paste0("SELECT AVG(numeric_grade) AS overall_gpa ",
                     "FROM enrollment")
dbGetQuery(con, sqlCommand)



# AGGREGATE FUNCTIONS (SUM,AVG,COUNT,MIN,MAX) WITH "WHERE" CLAUSE
# What is the average GPA for MUSA 620 (on a 0-100 scale)?
sqlCommand <- paste0("SELECT AVG(numeric_grade) AS musa620_gpa ",
                     "FROM enrollment ",
                     "WHERE course_id='MUSA 620'")
dbGetQuery(con, sqlCommand)



# AGGREGATE FUNCTION AND "GROUP BY" CLAUSE
# What is the average GPA for all courses (on a 0-100 scale)?
sqlCommand <- paste0("SELECT course_id, AVG(numeric_grade) AS course_gpa ",
                     "FROM enrollment ",
                     "GROUP BY course_id")
dbGetQuery(con, sqlCommand)



# USING JOINS
# Which instructors have taught in which rooms?
sqlCommand <- paste0("SELECT c.instructor, sr.room, sr.term ",
                     "FROM courses AS c ",
                     "JOIN semester_roster AS sr ",
                     "ON c.course_id = sr.course_id ")
dbGetQuery(con, sqlCommand)



# USING JOINS
# What courses has 'Callaway, Julie' taken?
sqlCommand <- paste0("SELECT s.name,e.* ",
                     "FROM enrollment AS e ",
                     "JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "WHERE s.name = 'Callaway, Julie'")
dbGetQuery(con, sqlCommand)



# JOIN THREE TABLES
# What instructors has 'Callaway, Julie' had?
sqlCommand <- paste0("SELECT e.course_id, s.name, c.instructor ",
                     "FROM enrollment AS e ",
                     "JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "JOIN courses AS c ",
                     "ON e.course_id = c.course_id ",
                     "WHERE s.name = 'Callaway, Julie'")
dbGetQuery(con, sqlCommand)



# JOIN AND AGGREGATE FUNCTION
# What is the average GPA of each student (on a 0-100 scale)?
sqlCommand <- paste0("SELECT s.name, AVG(e.numeric_grade) AS gpa ",
                     "FROM enrollment AS e ",
                     "JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "GROUP BY s.name")
dbGetQuery(con, sqlCommand)



# JOIN AND AGGREGATE FUNCTION
# What are the average GPAs of 'Callaway, Julie' and 'Edwards, Joe' (on a 0-100 scale)?
sqlCommand <- paste0("SELECT s.name, AVG(e.numeric_grade) AS gpa ",
                     "FROM enrollment AS e ",
                     "JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "WHERE s.name = 'Callaway, Julie' OR s.name = 'Edwards, Joe'",
                     "GROUP BY s.name")
dbGetQuery(con, sqlCommand)




# ORDER BY
# Who has taken the most classes?
sqlCommand <- paste0("SELECT s.name,COUNT(e.*) AS num_classes ",
                     "FROM enrollment AS e ",
                     "LEFT JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "GROUP BY s.name ",
                     "ORDER BY num_classes DESC")
dbGetQuery(con, sqlCommand)



# LIMIT CLAUSE
# Who has taken the most classes (return just the top 3)?
sqlCommand <- paste0("SELECT s.name,COUNT(e.*) AS num_classes ",
                     "FROM enrollment AS e ",
                     "LEFT JOIN students AS s ",
                     "ON e.student_id = s.student_id ",
                     "GROUP BY s.name ",
                     "ORDER BY num_classes DESC ",
                     "LIMIT 3")
dbGetQuery(con, sqlCommand)



dbDisconnect(con)
dbUnloadDriver(drv)



