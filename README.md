# Mushroom Classification Shiny App

This Shiny app demonstrates a binary classification model for mushroom characteristics. It uses a Random Forest classifier to predict whether mushrooms are edible or poisonous based on various characteristics. The app provides an interactive interface to view model performance and variable importance.

## Features

- **Model Overview**: Display summary information about the trained Random Forest model.
- **Confusion Matrix**: View confusion matrices for both the initial and tuned models.
- **Variable Importance**: Visualize the importance of different variables using interactive bar or dot plots.

## Installation

### Prerequisites

Ensure you have R and RStudio installed on your computer. You will also need to install the following R packages:

```R
install.packages(c("shiny", "tidyverse", "dplyr", "ggplot2", "caret", "randomForest", "DT", "plotly", "shinyWidgets"))
```

### Clone the Repository

Clone this repository to your local machine using:

```bash
git clone <repository-url>
```

## Running the App

1. Open RStudio.
2. Set your working directory to the location of the cloned repository.
3. Open the app.R file.
4. Run the app by clicking on the "Run App" button in RStudio, or by executing the following command in the R console:

```
shiny::runApp()
```

## File Structure
app.R: Main file containing the Shiny app code.
mushroom_cleaned.RData (optional): Preprocessed mushroom dataset. Ensure this is loaded correctly in the app.R script.

## Code Explanation

### Data Loading and Preprocessing
The app loads and preprocesses the mushroom dataset, ensuring the target variable is a factor and splitting the data into training and testing sets.

### Model Training and Evaluation
A Random Forest model is trained on the training set. The app evaluates the model's performance using a confusion matrix and calculates variable importance. It also tunes the Random Forest model using cross-validation and evaluates the tuned model.

### User Interface (UI)
The UI is defined using Shiny's fluidPage, sidebarLayout, and mainPanel functions. It includes tabs for displaying confusion matrices, variable importance plots, and the mushroom dataset.

### Server Logic
The server function handles the reactive elements of the app, including rendering model summaries, confusion matrices, variable importance plots, and the mushroom dataset.

## Usage
Navigate through the tabs to explore different aspects of the model and dataset.
Use the dropdown menu in the "Variable Importance" tab to switch between bar plots and dot plots.

## Contributing
If you would like to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
