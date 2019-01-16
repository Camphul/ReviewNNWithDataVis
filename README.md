# Assignment2

Data visualization of hotel reviews which are rated using sentiment analysis on a neural network.

Final assignment for my Bigdata Scientist & Engineer subject at HvA.

## Workflow

1. Import CSV data using data.table to handle large files
2. Split into negative and positive
3. Store separate datatables
4. Load into another datatable
5. Apply neural network to classify sentiment
6. Store results into mongodb
7. Fetch mongodb for rshiny visualization

Requires Hotel_Reviews.csv from https://www.kaggle.com/jiashenliu/515k-hotel-reviews-data-in-europe in the data directory.