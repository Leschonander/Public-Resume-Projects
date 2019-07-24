from flask import Flask, request, jsonify
from joblib import load
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import train_test_split
import pandas as pd


# Loading the data set so the vector transformation of words into numbers works properly...
df = pd.read_csv("BuzzFeedScore.csv")
df["IsWorld"] = [1 if x == "World" else 0 for x in df["category"]]

X_train, X_test, y_train, y_test = train_test_split(
    df['title'], 
    df['IsWorld'],
    random_state=0
)

vect = CountVectorizer().fit(X_train)
model = load('BuzzFeedWorldModel.joblib') # Loading the saved model

app = Flask(__name__)

@app.route('/')
def hello_world():
   return 'Hello, World!'

# curl -d '{"Query": "The World is Not Enough"}' -H "Content-Type: application/json" -X POST http://localhost:5000/predict
# ^ Example Query...
@app.route("/predict", methods=["POST"])
def predict():
    json = request.json

    prediction = (model.predict(vect.transform([json["Query"]])))
    
    result = {"Result": int(prediction[0])}
    
    return jsonify(result)

if __name__ == '__main__':
    app.run()