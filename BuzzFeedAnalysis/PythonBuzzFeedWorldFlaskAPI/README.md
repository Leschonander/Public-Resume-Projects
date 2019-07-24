# BuzzFeed Naive Bayes API in Flask

Turns out after collecting nearly 50,000 BuzzFeed news articles, doing textual machine learning tasks is much easier, only because you actually have a dataset now.


API sends a string to a pickled naive bayes model which then predicts if the text would be a World article [1], or not [0].

Example query below. 
```bash
curl -d '{"Query": "The World is Not Enough"}' -H "Content-Type: application/json" -X POST http://localhost:5000/predict
```