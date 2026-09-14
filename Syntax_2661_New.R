library(neuralnet)
library(readxl)
# Step 1: Define the parameters
epoch <- 100
target_error <- 0.01
learning_rates <- c(0.01, 0.03, 0.8)
hidden_layers <- c(2, 4, 5, 8)
data <- read_excel('Dataset.xlsx')

# Product A
dataA <- data[,-3]

# Step 2: Normality test
# Perform normality test on your data
# Min-Max normalization
normalized_dataA <- scale(dataA)

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
train_dataA <- normalized_dataA

best_modelA <- NULL
best_learning_rateA <- NULL
best_hidden_layerA <- NULL

for (learning_rate in learning_rates) {
  for (hidden_layer in hidden_layers) {
    # Create and train the ANN
    weightsA <- random_weights(ncol(train_dataA) - 1, hidden_layer, 1)
    ann_modelA <- tryCatch(
      expr = neuralnet(
        formula = A_demand ~ .,
        data = train_dataA,
        hidden = hidden_layer,
        learningrate = learning_rate,
        algorithm = "backprop",
        err.fct = "sse",
        linear.output = TRUE,
        rep = epoch,
        startweights = weightsA
      ),
      error = function(e) NULL
    )
    
    if (!is.null(ann_modelA)) {
      # Step 5: Data testing
      test_dataA <- data.frame(
        input = c(31, 32, 33) # Independent variable(s) for which demand needs to be predicted
      )
      
      # Step 6: MSE calculation
      predictionsA <- compute(ann_modelA, test_dataA)
      predicted_demandA <- predictionsA$net.result
      actual_demandA <- test_dataA  # Replace with the actual demand values for the test data
      mseA <- mean((actual_demandA$input - predicted_demandA)^2)
      cat("MSE A:", mseA, "\n")
      
      # Step 7: Predicting using best network
      if (is.null(best_modelA) || mseA < best_mseA) {
        best_modelA <- ann_modelA
        best_learning_rateA <- learning_rate
        best_hidden_layerA <- hidden_layer
        best_mseA <- mseA
      }
    }
  }
}

# Step 8: Prediction result interpretation
if (!is.null(best_modelA)) {
  new_dataA <- data.frame(
    input = c(31, 32) # Independent variable(s) for which demand needs to be predicted
  )
  
  # Perform prediction using the best model
  predictionsA <- compute(best_modelA, new_dataA)
  predicted_demandA <- predictionsA$net.result
  
  # Print the result
  print(predicted_demandA)
} else {
  print("No model found.")
}

# Product B
dataB <- data[,-2]

# Step 2: Normality test
# Perform normality test on your data
# Min-Max normalization
normalized_dataB <- scale(dataB)

# Step 3: Random weight initialization
set.seed(123)
# Step 4: Data training
train_dataB <- normalized_dataB

best_modelB <- NULL
best_learning_rateB <- NULL
best_hidden_layerB <- NULL

for (learning_rate in learning_rates) {
  for (hidden_layer in hidden_layers) {
    # Create and train the ANN
    weightsB <- random_weights(ncol(train_dataB) - 1, hidden_layer, 1)
    ann_modelB <- tryCatch(
      expr = neuralnet(
        formula = B_demand ~ .,
        data = train_dataB,
        hidden = hidden_layer,
        learningrate = learning_rate,
        algorithm = "backprop",
        err.fct = "sse",
        linear.output = TRUE,
        rep = epoch,
        startweights = weightsB
      ),
      error = function(e) NULL
    )
    
    if (!is.null(ann_modelB)) {
      # Step 5: Data testing
      test_dataB <- data.frame(
        input = c(31, 32, 33) # Independent variable(s) for which demand needs to be predicted
      )
      
      # Step 6: MSE calculation
      predictionsB <- compute(ann_modelB, test_dataB)
      predicted_demandB <- predictionsB$net.result
      actual_demandB <- test_dataB  # Replace with the actual demand values for the test data
      mseB <- mean((actual_demandB$input - predicted_demandB)^2)
      cat("MSE B:", mseB, "\n")
      
      # Step 7: Predicting using best network
      if (is.null(best_modelB) || mseB < best_mseB) {
        best_modelB <- ann_modelB
        best_learning_rateB <- learning_rate
        best_hidden_layerB <- hidden_layer
        best_mseB <- mseB
      }
    }
  }
}

# Step 8: Prediction result interpretation
if (!is.null(best_modelB)) {
  new_dataB <- data.frame(
    input = c(31, 32) # Independent variable(s) for which demand needs to be predicted
  )
  
  # Perform prediction using the best model
  predictionsB <- compute(best_modelB, new_dataB)
  predicted_demandB <- predictionsB$net.result
  
  # Print the result
  print(predicted_demandB)
} else {
  print("No model found.")
}

# Print the best result
plot(best_modelA)
cat("Best Learning Rate of Product A:", best_learning_rateA , "\n")
cat("Best Hidden Layer of Product A:", best_hidden_layerA , "\n")
plot(best_modelB)
cat("Best Learning Rate of Product B:", best_learning_rateB , "\n")
cat("Best Hidden Layer of Product B:", best_hidden_layerB , "\n")
