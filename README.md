# Week 4: Databases: Postgres and SQL

### Installing Postgres

This week we move on to databases, in particular PostgreSQL (aka Postgres). It is arguably the most powerful and versatile database available and knowing how to use it is almost certain to come in handy for anyone who works with data in their professional life.

Unfortuately, Postgres can be fussy to set up. So in preparation for this week's class, please follow the instructions in the [week-4-postgis-setup.pptx](https://github.com/MUSA-620-Spring-2018/MUSA-620-Week-4/blob/master/week-4-postgis-setup.pptx) document to install Postgres. You can verify that it is working properly by running [postgis.r](https://github.com/MUSA-620-Spring-2018/MUSA-620-Week-4/blob/master/postgres.R). If all goes smoothly, the whole process should only take a few minutes.

If you do run into problems setting up Postgres, please be sure to let me know.

## Databases

![relational schema courses intouch database](https://github.com/MUSA-620-Spring-2018/MUSA-620-Week-4/blob/master/relational-schema.png "relational schema courses intouch database")
Relational schema for a fictional UPenn Courses InTouch database

### Resources
- RPostgreSQL: [documentation](https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf)

## Assignment (optional)

Using the fictional Courses InTouch database we worked with in class, write a single SQL query that returns the list of students who are qualified to graduate.

**Due:** 13-Feb-2018 before the start of class (optional)

### Description

For our fictional students to graduate, they must have completed at least 4 classes with a final grade of 80 or above.

Using the definition above, write a single SQL query that returns the list of all students that are cleared for graduation. This is possible using only the syntax we learned in class. There are also many other ways of achieving the same result using syntax that we did not cover, but can be found with a little investigation online.

Extra credit for turning in three or more valid solutions.

Since the deliverable in this assignment is only a line (or three) of code, cooperation with other students is not permitted.
