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
testPeriods = [31; 32]; % Example test periods

% Step 1: Define the parameters
epoch = 1000;
targetError = 0.01;
learningRates = [0.01, 0.03, 0.8];
hiddenLayers = [2, 4, 5, 8];

% Step 2: Normality test (Not implemented in this example)

% Step 3: Random weight initialization
rng('default'); % Set random seed for reproducibility

% Step 4: Data training
bestMSE = inf;
bestNetwork = struct();

% Prepare inputs in the required format (concatenate periods and demands)
inputs = [periods, demands_product1, demands_product2];

for lr = learningRates
    for hl = hiddenLayers
        % Create the ANN
        net = feedforwardnet(hl);

        % Set the learning rate
        net.trainParam.lr = lr;

        % Set the number of epochs
        net.trainParam.epochs = epoch;

        % Set the target error
        net.trainParam.goal = targetError;

        % Train the ANN
        net = train(net, inputs', [demands_product1 demands_product2]');

        % Step 6: MSE calculation
        outputs = net(inputs');
        mse = mean((outputs - [demands_product1 demands_product2]').^2);

        % Step 7: Store the best network based on MSE
        if mse < bestMSE
            bestMSE = mse;
            bestNetwork.lr = lr;
            bestNetwork.hl = hl;
            bestNetwork.net = net;
        end
    end
end

% Step 5: Data testing
testInputs = [testPeriods, zeros(size(testPeriods)), zeros(size(testPeriods))]; % Assume zero demands for testing
testOutputs = bestNetwork.net(testInputs');

% Step 8: Prediction result interpretation
disp("Test Predictions:")
disp(testOutputs)

% Display best model information
disp("Best Model Information:")
disp("Learning Rate: " + bestNetwork.lr)
disp("Hidden Layer Size: " + bestNetwork.hl)
disp("Best MSE: " + min(bestMSE))

% Hasil prediksi dapat dilihat pada Command Window.
% Contoh dari hasil output adalah sebagai berikut:
% Test Predictions:
%  165.1586  165.1148
%    4.8559    4.8644

% Kolom pertama adalah hasil prediksi untuk produk A dan kolom kedua adalah
% hasil prediksi untuk produk B

% Best Model Information:
% Learning Rate: 0.01
% Hidden Layer Size: 2
% Best MSE: 0.025023

% Hasil di atas menunjukkan bahwa pada model terbaik, learning rate terbaik
% adalah 0.01 dan hidden layer yang terbaik adalah 2. Ini berarti, model prediksi
% mencapai hasil yang paling optimal dan akurat pada learning rate 0.01 dan
% hidden layer 2. Untuk hasil perhitungan MSE terbaik tercatat 0.025023,
% ini merupakan nilai MSE terkecil dari seluruh nilai MSE yang telah
% dihitung. MSE ini menggambarkan seberapa akurat suatu model, semakin
% kecil MSE, semakin akurat model tersebut.
% Selain itu, beberapa plot yang berhubungan dapat diklik pada window
% Neural Network Training yang muncul.

% Plot Performance menunjukkan perubahan nilai MSE sepanjang proses
% validasi.
% Plot Training state grafik yang menunjukkan bagaimana performa pelatihan 
% model berubah seiring dengan jumlah epoch yang dilakukan.
% Plot Error Histogram adalah grafik yang menunjukkan distribusi dari kesalahan 
% prediksi model pada data pelatihan atau data validasi.
% Plot Regression adalah grafik yang menunjukkan hubungan antara nilai sebenarnya (ground truth) 
% dan prediksi yang dihasilkan oleh model. Grafik ini membantu dalam memvisualisasikan sejauh mana 
% model dapat memprediksi dengan akurat terhadap data yang sebenarnya.
