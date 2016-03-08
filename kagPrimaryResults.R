library(RSQLite)

dbpath = "C:/Users/Salil/Downloads/PE/2016_presidential_election/database.sqlite"
db <- dbConnect(dbDriver("SQLite"), dbpath)



dbListTables(db)

countyfacts <- dbGetQuery(db, "select *  from county_facts")
cfd <- dbGetQuery(db, "select *  from county_facts_dictionary")
presults <- dbGetQuery(db, "select *  from primary_results")



