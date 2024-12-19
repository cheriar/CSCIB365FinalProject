library(dplyr, warn.conflicts = FALSE)
library(rpart)
library(nflreadr)
library(tidyr)
library(caTools)
library(rattle)

data <- load_pbp(2023)

# Step 2: Filter the dataset for dropback plays
dropback_data <- data %>%
  filter(play_type == "pass") %>%  # Only passing plays (dropbacks)
  select(qb_epa, down, ydstogo, yardline_100, air_yards, complete_pass, score_differential, interception, touchdown) %>% 
  na.omit()  # Remove rows with missing values

# Step 3: Normalize the data
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

dropback_data <- dropback_data %>%
  mutate(across(-qb_epa, normalize))

# Step 4: Split the data into training and testing sets
# Allows us to reproduce the same split every time
# Delete this to make a different tree
set.seed(42)  
sample <- sample(nrow(dropback_data), 0.8 * nrow(dropback_data))
train_data <- dropback_data[sample, ]
test_data <- dropback_data[-sample, ]

# Step 5: Define the decision tree, predict 'epa' using the selected features
formula <- qb_epa ~ down + ydstogo + yardline_100 + air_yards + complete_pass + score_differential + interception + touchdown

# I want to time the creation of the  model, thought this could be handy for optimization
print("Starting creation of Descision Tree model")
start_time <- Sys.time()

# Step 6: Train the decision tree
dTree <- rpart(formula,
                      data = train_data,  
                      method = "anova")  

#Stop time and record the time it took to run the model
print("Finished creation")
end_time <- Sys.time()
time_taken <- end_time - start_time
print(time_taken)

# Show the rules of the tree
asRules(dTree)
printcp(dTree)

# Mean squared error
predicted <- predict(dTree, test_data)
actual <- test_data$qb_epa

mse <- mean((predicted - actual)^2)
cat("Mean Squared Error (MSE):", mse, "\n")

# Define a threshold for "accurate" predictions, not sure what the threshold should be for a decision tree
threshold <- 1 

# Predict using the decision tree
predicted <- predict(dTree, test_data)
actual <- test_data$qb_epa

# Count accurate predictions
accurate_predictions <- sum(abs(predicted - actual) <= threshold)

# Calculate accuracy
accuracy <- (accurate_predictions / length(actual)) * 100

# Output the result
cat("Accuracy (%):", accuracy, "\n")

# Visualize the tree
fancyRpartPlot(dTree)

# THIS SHOWS A BAR PLOT UNCOMMENT OUT TO SEE
# Variable importance as barplot
#importance <- dTree$variable.importance
#barplot(importance, main = "Variable Importance", col = "lightblue", las = 2)
