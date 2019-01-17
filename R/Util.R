print("Loaded Util.R")

getTermMatrix <- memoise(function(txts) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  myCorpus = Corpus(VectorSource(txts))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    #we get rid of the terms positive and negative because they're too common in the "No negative" reviews
                    #we also get rid of "hotel" because it's too common. 
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but", "hotel", "positive", "negative"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})