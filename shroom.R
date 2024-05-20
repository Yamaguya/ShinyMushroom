library(tidyverse)
library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)

mushroom_data <- mushroom_cleaned

View(mushroom_data)

summary(mushroom_data)

# Ensure the target variable is a factor
mushroom_data$class <- as.factor(mushroom_data$class)

# Check for any remaining missing values
sum(is.na(mushroom_data))


colnames(mushroom_data) <- make.names(colnames(mushroom_data))

set.seed(123)  # For reproducibility
trainIndex <- createDataPartition(mushroom_data$class, p = .8, 
                                  list = FALSE, 
                                  times = 1)
mushroom_train <- mushroom_data[trainIndex,]
mushroom_test <- mushroom_data[-trainIndex,]

# Train the Random Forest model
set.seed(123)
rf_model <- randomForest(class ~ ., data = mushroom_train, importance = TRUE)

# Print the model
print(rf_model)


# Predict on the test set
rf_predictions <- predict(rf_model, newdata = mushroom_test)

# Confusion matrix to evaluate the predictions
confusionMatrix(rf_predictions, mushroom_test$class)

# Variable importance
importance(rf_model)
varImpPlot(rf_model)


# Generate confusion matrix
conf_matrix <- confusionMatrix(rf_predictions, mushroom_test$class)
print(conf_matrix)


# Tune the Random Forest model
tuned_rf <- train(class ~ ., data = mushroom_train, method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 5)

# Print the best parameters
print(tuned_rf$bestTune)

# Predict on the test set with the tuned model
tuned_predictions <- predict(tuned_rf, newdata = mushroom_test)

# Evaluate the tuned model
tuned_conf_matrix <- confusionMatrix(tuned_predictions, mushroom_test$class)
print(tuned_conf_matrix)

