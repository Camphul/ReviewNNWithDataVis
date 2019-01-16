print("Loaded CsvData.R")

csvdata.import <- function() {
  print("Loading CSV using data.table")
  # Read CSV using data.table for large files
  reviews <- fread(HOTEL_REVIEW_FILE)
  # Base column names 
  baseColNames <- c("Hotel_Address", "Hotel_Name", "lat", "lng", "Average_Score", "Total_Number_of_Reviews", 
                "Additional_Number_of_Scoring", "Reviewer_Nationality", "Review_Date", "Total_Number_of_Reviews_Reviewer_Has_Given",
                "Reviewer_Score", "Tags")
  positiveColNames <- append(baseColNames, values=c("Positive_Review", "Review_Total_Positive_Word_Counts"))
  negativeColNames <- append(baseColNames, values=c("Negative_Review", "Review_Total_Negative_Word_Counts"))
  finalColNames <- append(baseColNames, values=c("Review", "Review_Word_Counts"))
  finalColNames[3] <- "Lat"
  finalColNames[4] <- "Lng"

  print("Splitting into negatives and positives")
  #Create two datatables 
  positiveReviews <- reviews[, ..positiveColNames]
  negativeReviews <- reviews[, ..negativeColNames]
  
  #Rename columns
  colnames(positiveReviews) <- finalColNames
  colnames(negativeReviews) <- finalColNames
  
  #Write back to disk
  print("Writing positive reviews")
  fwrite(positiveReviews, HOTEL_REVIEW_POSITIVE_FILE)
  print("Writing negative reviews")
  fwrite(negativeReviews, HOTEL_REVIEW_NEGATIVE_FILE)
  print("Adding sentiment score")
  #Add sentiment
  postiveReviews <- positiveReviews[, Sentiment := 1]
  negativeReviews <- negativeReviews[, Sentiment := 0]
  
  print("Combining reviews")
  #rbind list with matching colnames
  reviews <- rbindlist(list(positiveReviews, negativeReviews), use.names=TRUE)
  #Sample
  print("Omitting empty reviews")
  reviews <- na.omit(reviews, cols="Review")
  reviews <- reviews[reviews$Review != "",]
  reviews <- reviews[sample(nrow(reviews), nrow(reviews)),]
  print("Sampling reviews")
  HOTEL_REVIEWS <<- reviews
  
  csvdata.importAddresses()
}

# Distinct all addresses and long/lat
csvdata.importAddresses <- function() {
  addressColumns <- c('Hotel_Address', 'Hotel_Name', 'Lat', 'Lng', 'Average_Score')
  
  HOTEL_ADDRESSES <<- HOTEL_REVIEWS[,..addressColumns] %>% unique()

}
