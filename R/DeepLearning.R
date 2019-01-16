print("Loaded DeepLearning.R")

# Creates the tokenizer which is used to convert documents into word indices
dl.createTokenizer <- function(reviews) {
  tokenizer <- text_tokenizer(num_words = NN_NUM_WORDS)
  tokenizer %>% fit_text_tokenizer(reviews)
  print("Created text tokenizer")  
  return(tokenizer)
}


# Turn the tokenized data into data understandable by a NN
vectorize_sequences <- function(sequences, dimension = 10000) {
  # Creates an all-zero matrix of shape (length(sequences), dimension)
  results <- matrix(0, nrow = length(sequences), ncol = dimension) 
  for (i in 1:length(sequences)) {
    # Sets specific indices of results[i] to 1s
    results[i, sequences[[i]]] <- 1 
  }
  return(results)
}

dl.predict <- function(review) {
  print("Generating prediction")
  tokenizedReview <- texts_to_sequences(DL_TOKENIZER, c(review))
  print("Tokenized review:")
  print(tokenizedReview)
  vectorizedSequence <- vectorize_sequences(tokenizedReview)
  #print("Vectorized Sequence:")
  #print(vectorizedSequence)
  prediction <- predict(NN_MODEL,vectorizedSequence)
  return(prediction[1,])
}

# Create train and test sets
dl.prepareSets <- function() {
  # Fetch reviews from db
  reviews <- db.find(lmt = NN_TRAIN_SIZE + NN_TEST_SIZE)
  # Create tokenizer vocabulary from reviews
  DL_TOKENIZER  <<- dl.createTokenizer(reviews$Review)
  
  print("Creating tokenized data sets")
  
  # Create matrices of reviews which are encoded through the tokenizer
  DL_TRAIN_DATA <<- texts_to_sequences(DL_TOKENIZER, reviews[1:NN_TRAIN_SIZE]$Review)
  DL_TRAIN_LABELS <<- reviews[1:NN_TRAIN_SIZE]$Sentiment
  DL_TEST_DATA <<- texts_to_sequences(DL_TOKENIZER, reviews[NN_TRAIN_SIZE-1:NN_TEST_SIZE-1]$Review)
  DL_TEST_LABELS <<- reviews[NN_TRAIN_SIZE-1:NN_TEST_SIZE-1]$Sentiment
  
  print("Vectorizing train and set data")
  
  DL_X_TRAIN <<- vectorize_sequences(DL_TRAIN_DATA)
  DL_X_TEST <<-  vectorize_sequences(DL_TEST_DATA)
  
  print("Converting train and test labels")
  
  DL_Y_TRAIN <<- as.numeric(DL_TRAIN_LABELS)
  DL_Y_TEST <<- as.numeric(DL_TEST_LABELS)
  print("Created train and test sets")
}

dl.buildModel <- function() {
  NN_MODEL <<- keras_model_sequential() %>% 
  layer_dense(units = 16, activation = "relu", input_shape = c(NN_NUM_WORDS)) %>% 
  layer_dense(units = 16, activation = "relu") %>% 
  layer_dense(units = 1, activation = "sigmoid")
  
  # Configure loss function with optimizer(for gradient descent)
  NN_MODEL %>% compile(
    optimizer = "rmsprop",
    loss = "binary_crossentropy",
    metrics = c("accuracy")
  )
}

# Validates model against a set of data which is not known yet.
dl.validate <- function() {
  x_val <- DL_X_TRAIN[NN_VALIDATE_INDICES, ]
  partial_x_train <- DL_X_TRAIN[-NN_VALIDATE_INDICES, ]
  
  y_val <- DL_Y_TRAIN[NN_VALIDATE_INDICES]
  partial_y_train <- DL_Y_TRAIN[-NN_VALIDATE_INDICES]
  
  history <- NN_MODEL %>% fit(
    partial_x_train,
    partial_y_train,
    epochs = NN_EPOCHS,
    batch_size = NN_BATCH_SIZE,
    validation_data = list(x_val, y_val)
  )
  
  plot(history)
}

dl.setup <- function() {
  print("Setting up DeepLearning")
  dl.prepareSets()
  print("Building model..")
  dl.buildModel()
  print("Validating model..")
  dl.validate()
}