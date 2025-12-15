function smoothed_data = dataSmoothing(coords, connectivity, data_to_smooth, iterations, strength)

% This function smooths surface data (like curvature or thickness values) on a 3D mesh by averaging each vertex’s value with its neighbors, weighted by distance
    num_vertices = size(coords, 1);
    num_vars = size(data_to_smooth, 2); % Number of variables to smooth
    
    neighbors = cell(num_vertices, 1);

    % Build neighbor list
    for i = 1:size(connectivity, 1)
        for j = 1:3
            v1 = connectivity(i, j);
            v2 = connectivity(i, mod(j, 3) + 1);
            v3 = connectivity(i, mod(j+1, 3) + 1);
            neighbors{v1} = unique([neighbors{v1}, v2, v3]);
            neighbors{v2} = unique([neighbors{v2}, v1, v3]);
            neighbors{v3} = unique([neighbors{v3}, v1, v2]);
        end
    end

    % Initialize output
    smoothed_data = data_to_smooth;

    % Perform smoothing iterations
    for iter = 1:iterations
        new_data = smoothed_data;
        
        for v = 1:num_vertices
            if isempty(neighbors{v})
                continue;
            end
            
            neighbor_idx = neighbors{v}; % Get neighbor indices
            weights = 1 ./ vecnorm(coords(neighbor_idx, :) - coords(v, :), 2, 2); % Compute weights (inverse distance)
            weights = weights / sum(weights); % Normalize weights
            
            for var_idx = 1:num_vars % Loop over all input variables
                smoothed_value = sum(weights .* smoothed_data(neighbor_idx, var_idx));
                new_data(v, var_idx) = strength * smoothed_value + (1 - strength) * smoothed_data(v, var_idx);
            end
        end

        smoothed_data = new_data; % Update for next iteration
    end
disp('data smoothing finished')    
end