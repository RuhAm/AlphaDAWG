function Transform_Curvelet(num_, p, q)
    % Validate input arguments
    if nargin < 3
        error('Not enough input arguments. Usage: Transform_Curvelet(num_, p, q)');
    end 
    
    % p: 1 for sweep, 0 for neutral
    % q: 1 for sweep, 0 for neutral
    if ~isnumeric(num_) || num_ < 0
        error('Invalid input for num_. It should be a non-negative integer.');
    end
    
    if p ~= 1 && p ~= 0
        error('Invalid input for p. It should be 1 (sweep) or 0 (neutral).');
    end
    
    if q ~= 1 && q ~= 0
        error('Invalid input for q. It should be 1 (sweep) or 0 (neutral).');
    end
    
    disp(['Input: num_ = ', num2str(num_), ', p = ', num2str(p), ', q = ', num2str(q)]);
    
    if p == 1
        S = 'sweep_parse_resized_';
    else
        S = 'neut_parse_resized_';
    end
    
    if q == 1
        R = 'sweep_align_resized_';
    else
        R = 'neut_align_resized_';
    end
    
    disp(['Chosen S: ', S, ', Chosen R: ', R]);

    % Process the first dataset
    processCurveletData(S, 0);
    
    for u = 1:num_-1
        processCurveletData(S, u);
        disp(['Finished curvelet transforming ', S, num2str(u), '.csv']);
    end

    % Process the second dataset
    processCurveletData(R, 0);
    
    for u = 1:num_-1
        processCurveletData(R, u);
        disp(['Finished curvelet transforming ', R, num2str(u), '.csv']);
    end
end

function processCurveletData(prefix, index)
    % Helper function to process curvelet data
    if index == 0
        filename = strcat('../../Data/', prefix, '0.csv');
    else
        filename = strcat('../../Data/', prefix, num2str(index), '.csv');
    end

    X1 = readtable(filename);
    X1(:, 1) = [];  % Remove the first column
    X1(1, :) = [];   % Remove the first row
    X = table2array(X1);
    C = fdct_wrapping(X, 1);
    
    A = [];
    for i = 1:length(C)
        for j = 1:length(C{i})
            D = reshape(C{i}{j}, 1, []);
            A = [A D];
        end
    end
    
    writematrix(A, strcat('../../Data/Curvelets/Curvelets_', prefix, '.csv'), 'WriteMode', 'append');
end
