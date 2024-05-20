library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)
library(DT)
library(plotly)
library(shinyWidgets)

# Load and preprocess your data
mushroom_data <- mushroom_cleaned

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

# Predict on the test set
rf_predictions <- predict(rf_model, newdata = mushroom_test)

# Confusion matrix to evaluate the predictions
conf_matrix <- confusionMatrix(rf_predictions, mushroom_test$class)

# Variable importance
var_importance <- importance(rf_model)

# Tune the Random Forest model
tuned_rf <- train(class ~ ., data = mushroom_train, method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneLength = 5)

# Predict on the test set with the tuned model
tuned_predictions <- predict(tuned_rf, newdata = mushroom_test)

# Evaluate the tuned model
tuned_conf_matrix <- confusionMatrix(tuned_predictions, mushroom_test$class)

# Define UI
ui <- fluidPage(
  titlePanel("Mushroom Classification Model"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Model Overview"),
      verbatimTextOutput("model_summary"),
      hr(),
      pickerInput(
        inputId = "importance_plot_type",
        label = "Variable Importance Plot Type:",
        choices = c("Bar Plot" = "bar", "Dot Plot" = "dot"),
        selected = "bar"
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Confusion Matrix",
                 h4("Initial Model Confusion Matrix"),
                 verbatimTextOutput("conf_matrix"),
                 h4("Tuned Model Confusion Matrix"),
                 verbatimTextOutput("tuned_conf_matrix")),
        tabPanel("Variable Importance",
                 h4("Variable Importance"),
                 plotlyOutput("varImpPlot")),
        tabPanel("Data",
                 h4("Mushroom Data"),
                 DTOutput("data_table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  output$model_summary <- renderPrint({
    print(rf_model)
  })
  
  output$conf_matrix <- renderPrint({
    print(conf_matrix)
  })
  
  output$tuned_conf_matrix <- renderPrint({
    print(tuned_conf_matrix)
  })
  
  output$varImpPlot <- renderPlotly({
    var_importance_df <- as.data.frame(var_importance)
    var_importance_df$Variable <- rownames(var_importance_df)
    
    if (input$importance_plot_type == "bar") {
      p <- ggplot(var_importance_df, aes(x = reorder(Variable, MeanDecreaseGini), y = MeanDecreaseGini)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        coord_flip() +
        theme_minimal() +
        labs(title = "Variable Importance (Bar Plot)", x = "Variable", y = "Importance")
    } else {
      p <- ggplot(var_importance_df, aes(x = MeanDecreaseGini, y = reorder(Variable, MeanDecreaseGini))) +
        geom_point(color = "steelblue", size = 3) +
        theme_minimal() +
        labs(title = "Variable Importance (Dot Plot)", x = "Importance", y = "Variable")
    }
    
    ggplotly(p)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
