# 1. Load Packages
# 2. Load Dataset
# 3. Preprocess Data
# 4. Train-Test Split
# 5. Train GBM Model
# 6. Make Predictions
# 7. Evaluate Model
# 8. Predict New Card
# -----------------------------
# 1. Install and Load Packages
# -----------------------------
install.packages("gbm")
install.packages("caret")
install.packages("dplyr")

library(gbm)
library(caret)
library(dplyr)

# -----------------------------
# 2. Load Dataset
# -----------------------------
card_data <- read.csv("old_card_price_dataset.csv")

# Convert character columns to factors
card_data <- card_data %>%
  mutate(across(where(is.character), as.factor))

# -----------------------------
# 3. Train-Test Split
# -----------------------------
set.seed(123)
train_index <- createDataPartition(card_data$price, p = 0.8, list = FALSE)
train_data <- card_data[train_index, ]
test_data <- card_data[-train_index, ]

# -----------------------------
# 4. Train Gradient Boosting Model
# -----------------------------
gbm_model <- gbm(
  price ~ .,
  data = train_data,
  distribution = "gaussian",
  n.trees = 300,
  interaction.depth = 3,
  shrinkage = 0.05,
  n.minobsinnode = 2,
  bag.fraction = 0.6,
  train.fraction = 1.0,
  verbose = FALSE
)

# -----------------------------
# 5. Make Predictions
# -----------------------------
gbm_pred <- predict(gbm_model, newdata = test_data, n.trees = 300)

# -----------------------------
# 6. Evaluate Model Performance
# -----------------------------
evaluate <- function(true, predicted) {
  mae <- mean(abs(true - predicted))
  rmse <- sqrt(mean((true - predicted)^2))
  r2 <- 1 - sum((true - predicted)^2) / sum((true - mean(true))^2)
  return(list(MAE = mae, RMSE = rmse, R2 = r2))
}

# Print performance metrics
print(evaluate(test_data$price, gbm_pred))

# -----------------------------
# 7. Predict Price for a New Card
# -----------------------------
new_card <- data.frame(
  card_age = 12,
  rarity_score = 8,
  condition_score = 6
)

final_price <- predict(gbm_model, new_card, n.trees = 300)
print(final_price)

