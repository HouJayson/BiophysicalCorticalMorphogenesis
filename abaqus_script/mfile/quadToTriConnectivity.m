function [triConnectivity] = quadToTriConnectivity(SurfConnectivity, NodeCoord)
    % quadToTriConnectivity converts quadrilateral connectivity to triangular
    % Inputs:
    %   SurfConnectivity - Quadrilateral connectivity matrix (m x 4), where m is
    %                      the number of quadrilateral elements
    %   NodeCoord        - Node coordinates matrix (nNodes x 3) 
    % Outputs:
    %   triConnectivity  - Triangular connectivity matrix (2*m x 3)

    % Initialize triangular connectivity
    nElements = size(SurfConnectivity, 1); % Number of quadrilateral elements
    triConnectivity = zeros(2 * nElements, 3); % Each quad splits into 2 triangles

    % Loop through each quadrilateral element and split into 2 triangles
    for i = 1:nElements
        % Get the four nodes of the quadrilateral element
        quadNodes = SurfConnectivity(i, :);

        % Two splitting methods
        tri1 = quadNodes([1, 2, 3]);
        tri2 = quadNodes([1, 3, 4]);
        tri3 = quadNodes([1, 2, 4]);
        tri4 = quadNodes([2, 3, 4]);

        % Calculate aspect ratios
        aspectRatio1 = calculateAspectRatio(tri1, NodeCoord);
        aspectRatio2 = calculateAspectRatio(tri2, NodeCoord);
        aspectRatio3 = calculateAspectRatio(tri3, NodeCoord);
        aspectRatio4 = calculateAspectRatio(tri4, NodeCoord);

        % Take the splitting with the minimal aspect ratio
        if (aspectRatio1 + aspectRatio2) <= (aspectRatio3 + aspectRatio4)
            triConnectivity(2 * i - 1, :) = tri1;
            triConnectivity(2 * i, :) = tri2;
        else
            triConnectivity(2 * i - 1, :) = tri3;
            triConnectivity(2 * i, :) = tri4;
        end
    end
end

function aspectRatio = calculateAspectRatio(triNodes, NodeCoord)
    % Calculate the aspect ratio of a triangle given node indices and coordinates
    % Inputs:
    %   triNodes  - Indices of the triangle nodes (1 x 3)
    %   NodeCoord - Node coordinates matrix (nNodes x 3)
    % Output:
    %   aspectRatio - Aspect ratio of the triangle

    % Get the coordinates of the triangle nodes
    coords = NodeCoord(triNodes, :);

    % Calculate side lengths
    L1 = norm(coords(2, :) - coords(1, :));
    L2 = norm(coords(3, :) - coords(2, :));
    L3 = norm(coords(1, :) - coords(3, :));

    % Calculate the semi-perimeter
    s = (L1 + L2 + L3) / 2;

    % Calculate the area using Heron's formula
    area = sqrt(s * (s - L1) * (s - L2) * (s - L3));

    % Aspect ratio: longest side divided by the altitude to that side
    maxSide = max([L1, L2, L3]);
    aspectRatio = maxSide / (2 * area / maxSide);
end
