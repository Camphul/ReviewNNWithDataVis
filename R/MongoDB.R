print("Loaded MongoDB.R")

# Connect to mongodb reviews
db.connect <- function() {
  print("Connecting to mongodb...")
  MONGODB_CONNECTION <<- mongo(collection=MONGODB_COLLECTION, db=MONGODB_DATABASE, url=MONGODB_URL)
  print("Connected to mongodb")
}

# Inserts a dt
db.insertTable <- function(dt) {
  print("Inserting data into collection")
  MONGODB_CONNECTION$insert(dt)
  print("Done inserting data")
}

# Disconnect MongoDB, connection automatically closed when gc is ran and the reference is removed.
db.disconnect <- function() {
  print("Disconnecting mongodb")
  rm(MONGODB_CONNECTION)
  gc()
}

db.findPositive <- function(lmt) {
  return(data.table(MONGODB_CONNECTION$find('{ "Sentiment": 1}', limit=lmt)))
}

db.findNegative <- function(lmt) {
  return(data.table(MONGODB_CONNECTION$find('{ "Sentiment": 0}', limit=lmt)))
}

db.findAll <- function() {
  return(data.table(MONGODB_CONNECTION$find('{}')))
}

db.find <- function(lmt) {
  return(data.table(MONGODB_CONNECTION$find('{}', limit=lmt)))
}

db.findHotel <- function(addr, sentimentValue, minScore) {
  query <- paste0('{"Hotel_Address": "', addr, '", "Reviewer_Score" : { "$gte" : ',minScore,' } }')
  if(sentimentValue != -1) {
    query <- paste0('{"Hotel_Address": "', addr, '", "Sentiment" : { "$eq" : ',sentimentValue,' }, "Reviewer_Score" : { "$gte" : ',minScore,' } }')
  }
  return(data.table(MONGODB_CONNECTION$find(query)))
}