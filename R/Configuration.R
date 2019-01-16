print("Loaded Configuration.R")

HOTEL_REVIEW_FILE <- "data/Hotel_Reviews.csv"
HOTEL_REVIEW_POSITIVE_FILE <- "data/Hotel_Reviews_Positive.csv"
HOTEL_REVIEW_NEGATIVE_FILE <- "data/Hotel_Reviews_Negative.csv"

MONGODB_COLLECTION <- "reviews"
MONGODB_DATABASE <- "HotelReviews"
MONGODB_URL <- "mongodb://localhost"

NN_NUM_WORDS <- 10000
NN_TRAIN_SIZE <- 14000
NN_TEST_SIZE <- 6000
NN_EMBEDDING_SIZE <- 128
NN_SKIP_WINDOW <- 5
NN_NUM_SAMPLED <- 1
NN_VALIDATE_INDICES <- 1:10000
#Amount of iterations we give the network to learn
NN_EPOCHS <- 25
#Amount of samples per gradient upgrade(high is better)
NN_BATCH_SIZE <- 1024
