% Create the neuron diagram
figure;
hold on;

% Define the neuron positions
neuron_positions = [
    1   0.8;    % Input neuron 1
    1   0.4;    % Input neuron 2
    1   0.0;    % Input neuron 3
    2   0.6;    % Hidden neuron 1
    2   0.2;    % Hidden neuron 2
    3   0.4;    % Output neuron
];

% Plot the neurons as circles
neuron_radius = 0.1;
plot(neuron_positions(:,1), neuron_positions(:,2), 'ko', 'MarkerSize', 2*neuron_radius);

% Add labels to the neurons
neuron_labels = {'Input 1', 'Input 2', 'Input 3', 'Hidden 1', 'Hidden 2', 'Output'};
text(neuron_positions(:,1), neuron_positions(:,2), neuron_labels, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

% Define the connections between neurons
connections = [
    1 4;    % Connection from input neuron 1 to hidden neuron 1
    1 5;    % Connection from input neuron 1 to hidden neuron 2
    2 4;    % Connection from input neuron 2 to hidden neuron 1
    2 5;    % Connection from input neuron 2 to hidden neuron 2
    3 4;    % Connection from input neuron 3 to hidden neuron 1
    3 5;    % Connection from input neuron 3 to hidden neuron 2
    4 6;    % Connection from hidden neuron 1 to output neuron
    5 6;    % Connection from hidden neuron 2 to output neuron
];

% Plot the connections as lines
for i = 1:size(connections, 1)
    start_neuron = connections(i, 1);
    end_neuron = connections(i, 2);
    start_pos = neuron_positions(start_neuron, :);
    end_pos = neuron_positions(end_neuron, :);
    plot([start_pos(1), end_pos(1)], [start_pos(2), end_pos(2)], 'k-', 'LineWidth', 1);
end

% Set the axis limits
xlim([0.5 3.5]);
ylim([-0.1 0.9]);

% Remove axis ticks and labels
set(gca, 'xtick', []);
set(gca, 'ytick', []);

% Set the plot title
title('Neuron Diagram');

% Display the plot
hold off;
