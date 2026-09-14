library(neuralnet)

# Step 1: Define the parameters
epoch <- 1000
target_error <- 0.01
learning_rates <- c(0.01, 0.03, 0.8)
hidden_layers <- c(2, 4, 5, 8)

# Step 2: Normality test
# Perform normality test on your data
# If necessary, apply appropriate transformations to ensure normality

# Step 3: Random weight initialization
set.seed(123)
random_weights <- function(input_neurons, hidden_neurons, output_neurons) {
  weights <- list()
  
  for (i in 1:length(hidden_neurons)) {
    if (i == 1) {
      weights[[i]] <- matrix(runif((input_neurons + 1) * hidden_neurons[i], -1, 1), nrow = input_neurons + 1, ncol = hidden_neurons[i])
    } else {
      weights[[i]] <- matrix(runif((hidden_neurons[i-1] + 1) * hidden_neurons[i], -1, 1), nrow = hidden_neurons[i-1] + 1, ncol = hidden_neurons[i])
    }
  }
  
  weights[[length(hidden_neurons) + 1]] <- matrix(runif((hidden_neurons[length(hidden_neurons)] + 1) * output_neurons, -1, 1), nrow = hidden_neurons[length(hidden_neurons)] + 1, ncol = output_neurons)
  
  return(weights)
}

# Step 4: Data training
train_data <- data.frame(
  input1 = c(0.2, 0.1, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9),
  input2 = c(0.1, 0.4, 0.3, 0.6, 0.7, 0.8, 0.9, 0.2, 0.5),
  target = c(0, 0, 0, 1, 1, 1, 1, 0, 1)
)

best_model <- NULL
best_learning_rate <- NULL
best_hidden_layer <- NULL

for (learning_rate in learning_rates) {
  for (hidden_layer in hidden_layers) {
    # Create and train the ANN
    weights <- random_weights(ncol(train_data) - 1, hidden_layer, 1)
    ann_model <- neuralnet(formula = target ~ ., data = train_data, hidden = hidden_layer, learningrate = learning_rate, algorithm = "backprop", err.fct = "sse", threshold = 0.01, linear.output = FALSE, rep = epoch, startweights = weights)
    
    # Step 5: Data testing
    test_data <- data.frame(
      input1 = c(0.3, 0.8, 0.6),
      input2 = c(0.2, 0.9, 0.4),
      target = c(0, 1, 1)
    )
    
    # Step 6: MSE calculation
    predictions <- compute(ann_model, test_data)
    mse <- mean((predictions$net.result - test_data$target)^2)
    
    # Step 7: Predicting using best network
    if (mse < target_error && is.null(best_model)) {
      best_model <- ann_model
      best_learning_rate <- learning_rate
      best_hidden_layer <- hidden_layer
    }
  }
}

# Step 8: Prediction result interpretation
if (!is.null(best_model)) {
  new_data <- data.frame(
    input1 = c(0.4, 0.7),
    input2 = c(0.3, 0.8)
  )
  
  # Perform prediction using the best model
  predictions <- compute(best_model, newdata = new_data)
  predicted_values <- predictions$net.result
  
  # Print the predicted values
  print(predicted_values)
} else {
  print("No model found that meets the target error criterion.")
}
