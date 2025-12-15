function distances = SulcalDepth_alphashape(connectivity_envelop, vertices_hull, x, y, z)
% Sulcal depth is determined as the minimal projection distance between mesh points and convex hull surface.
    points_set = [x, y, z];  

    % Extract triangle vertex positions from connectivity
    v1 = vertices_hull(connectivity_envelop(:, 1), :);
    v2 = vertices_hull(connectivity_envelop(:, 2), :);
    v3 = vertices_hull(connectivity_envelop(:, 3), :);

    % Compute face centers (midpoint of each triangle)
    faceCenters = (v1 + v2 + v3) / 3;  % Mx3 matrix

    % % Compute normalized face normals
    % edge1 = v2 - v1;
    % edge2 = v3 - v1;
    % faceNormals = cross(edge1, edge2, 2);
    % faceNormals = faceNormals ./ vecnorm(faceNormals, 2, 2);  % Normalize normals

    % Create KD-tree using face centers
    KDTree = createns(faceCenters, 'NSMethod', 'kdtree');

    % Find nearest face center for each ROI point
    [~,distances] = knnsearch(KDTree, points_set);  % Returns indices of closest faces
    
    disp('Sulcal depth calculation completed.');
end 