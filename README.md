# Card Price Prediction

Predicting resale prices of collectible credit cards using a Gradient Boosting Machine (GBM) model in R.

## Dataset
- `old_card_price_dataset.csv` contains features like:
  - `card_age` – age of the card in months/years
  - `rarity_score` – scale of 1–10
  - `condition_score` – scale of 1–10
  - `price` – resale price (target variable)

## How to Run
1. Install R or RStudio.
2. Install required packages:
```r
install.packages("gbm")
install.packages("caret")
install.packages("dplyr")
