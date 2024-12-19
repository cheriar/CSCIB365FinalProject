library(nflreadr)  
library(neuralnet) 
library(dplyr)     
library(ggplot2)

data <- load_pbp(2023)

# Step 2: Filter the dataset for dropback plays
dropback_data <- data %>%
  filter(play_type == "pass") %>%  # Only passing plays (dropbacks)
  select(qb_epa, down, ydstogo, yardline_100, air_yards, complete_pass, score_differential, interception) %>% 
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

# Step 5: Define the neural network, predict 'epa' using the selected features
formula <- qb_epa ~ down + ydstogo + yardline_100 + air_yards + complete_pass + score_differential + interception

# I want to time the creation of the neural network model, thought this could be handy for optimization
print("Starting creation of Neural Network model")
start_time <- Sys.time()

# Step 6: Train the neural network
nnModel <- neuralnet(formula,
                      data = train_data,
                      hidden = c(5, 3),  # Two hidden layers with 5 and 3 neurons
                      linear.output = TRUE)  # Linear output for regression

print("Finished creating Neural Network model")
end_time <- Sys.time()
time_taken <- end_time - start_time
print(time_taken)

# Step 7: Show the neural network, I cant get this to work
#plot(nnModel)

# Step 8: Try the test set
test_features <- test_data[, -1] 
predicted_epa <- neuralnet::compute(nnModel, test_features)$net.result

# Step 9: Evaluate the model
# For now, assume the data is still normalized for evaluation purposes
actual_epa <- test_data$qb_epa
mse <- mean((actual_epa - predicted_epa)^2)

# Measure the Mean Squared Error, our performance metric
cat("Mean Squared Error:", mse)

# I just want to see the actual number of correct guesses, this is more a pain than I thought it would be
# Define the actual `epa` values from the test dataset
actual_epa <- test_data$qb_epa

# Define a threshold
threshold <- 1

# Count the number of "correct" predictions
correct_predictions <- sum(abs(predicted_epa - actual_epa) <= threshold)

# Calculate the accuracy
accuracy <- correct_predictions / length(actual_epa) * 100

# Print the results
cat("Number of Correct Predictions:", correct_predictions, "\n")
cat("Accuracy (%):", accuracy, "\n")
