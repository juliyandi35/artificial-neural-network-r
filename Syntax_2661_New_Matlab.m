clear all; clc;
% Generate the data
% Perhatikan bahwa FilePath harus disesuaikan dengan letak file yang ada di
% perangkat anda. Tinggal klik kanan file Dataset yang ada di dalam folder
% yang telah diekstrak, klik Properties, lalu copy Location dari file dan
% paste di dalam variabel FilePath, jangan lupa tambahkan \Dataset.xlsx
% setelah paste Location dari filenya.
FilePath = 'C:\Users\JULI YANDI RAHMAN\Downloads\Kerjaan\Project 2661\Dataset.xlsx';
Dataset = readtable(FilePath);
periods = table2array(Dataset(:,1));
demands_product1 = table2array(Dataset(:,2));
demands_product2 = table2array(Dataset(:,3));
testPeriods = [31:42]'; % Example test periods

% Step 1: Normality test on each product demand data
alpha = 0.05; % Significance level
[h, p, jbStat1] = jbtest(demands_product1, alpha);
[h, p, jbStat2] = jbtest(demands_product2, alpha);
disp('Normality Test Result for Product 1:')
disp(jbStat1)
disp('Normality Test Result for Product 2:')
disp(jbStat2)

% Step 2: Data normalization
% Define the desired range
min_range = 0;
max_range = 1;

% Calculate the minimum and maximum values of the data
min_data1 = min(demands_product1);
max_data1 = max(demands_product1);
min_data2 = min(demands_product2);
max_data2 = max(demands_product2);

% Normalize the data to the desired range
demands_product1 = (demands_product1- min_data1) / (max_data1 - min_data1) * (max_range - min_range) + min_range;
demands_product2 = (demands_product2- min_data2) / (max_data2 - min_data2) * (max_range - min_range) + min_range;

% Step 3: Train the ANN
% Random weight initialization
rng('default'); % Set random seed for reproducibility
epoch = 1000;
targetError = 0.01;
learningRates = input('Masukkan learning rate anda: ')
hiddenLayers = [2, 4, 5, 8];

bestMSE = inf;
bestNetwork = struct();

% Prepare inputs in the required format (concatenate periods and demands)
inputs = [periods, demands_product1, demands_product2]';

hidden_layer_func = input('Masukkan fungsi hidden layer anda: ')
output_layer_func = input('Masukkan fungsi output layer anda: ')
train_layer_func = input('Masukkan fungsi train layer anda: ')

for hl = hiddenLayers
    % Create the ANN
    net = feedforwardnet(hl);
    
    % Set the transfer functions
    net.layers{1}.transferFcn = hidden_layer_func; % Hidden layer transfer function
    net.layers{2}.transferFcn = output_layer_func; % Output layer transfer function
    
    % Set the learning algorithm
    net.trainFcn = train_layer_func;
    
    % Set the learning rate
    net.trainParam.lr = learningRates;
    
    % Set the number of epochs
    net.trainParam.epochs = epoch;
    
    % Set the target error
    net.trainParam.goal = targetError;
    
    % Train the ANN
    net = train(net, inputs, [demands_product1, demands_product2]');
    
    % Step 4: Calculate MSE for each neural network
    outputs = net(inputs);
    mse = mean((outputs - [demands_product1, demands_product2]').^2);
    
    % Step 5: Store the best network based on MSE
    if mse < bestMSE
        bestMSE = mse;
        bestNetwork.lr = learningRates;
        bestNetwork.hl = hl;
        bestNetwork.net = net;
        bestNetwork.epochs = epoch;
    end
end

% Step 6: Test and forecast using the chosen network
testInputs = [testPeriods, zeros(size(testPeriods)), zeros(size(testPeriods))]; % Assume zero demands for testing
max_data_test = max(testInputs);
min_data_test = min(testInputs);
testInputs = (testInputs - min_data_test) / (max_data_test - min_data_test).* (max_data_test - min_data_test) + min_data_test;
testOutputs = bestNetwork.net(testInputs');

% Step 7: Denormalize the forecasted data
forecastedData = zeros(size(testOutputs));
forecastedData(1,:) = testOutputs(1,:)* (max_data1 - min_data1) + min_data1;
forecastedData(2,:) = testOutputs(2,:)* (max_data2 - min_data2) + min_data2;

% Display the denormalized forecasted data
disp("Forecasted Data:")
disp(forecastedData)

% Display best model information
disp("Best Model Information:")
disp("Learning Rate: " + bestNetwork.lr)
disp("Hidden Layer Size: " + bestNetwork.hl)
disp("Best MSE: " + min(bestMSE))
disp("Best Epoch: "+ bestNetwork.epochs)
disp("Best Neural Network: ")
disp(bestNetwork.net)
view(bestNetwork.net)