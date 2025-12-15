function distances = SulcalDepth_alphashape_shrink(connectivity_envelop, vertices_hull, x, y, z)
% Sulcal depth is determined as the minimal projection distance between mesh points and convex hull surface.
    points_set = [x, y, z];  

    tri = connectivity_envelop;
    xyz = vertices_hull;

    % Compute face normals
    v1 = xyz(tri(:, 1), :);
    v2 = xyz(tri(:, 2), :);
    v3 = xyz(tri(:, 3), :);
    edge1 = v2 - v1;
    edge2 = v3 - v1;
    faceNormals = cross(edge1, edge2, 2);
    faceNormals = faceNormals ./ vecnorm(faceNormals, 2, 2); % Normalize
    
    % Compute vertex normals (average of adjacent face normals)
    vertexNormals = zeros(size(xyz));
    for i = 1:size(tri, 1)
        vertexNormals(tri(i, :), :) = vertexNormals(tri(i, :), :) + faceNormals(i, :);
    end
    vertexNormals = vertexNormals ./ vecnorm(vertexNormals, 2, 2); % Normalize
    
    % Shrinking factor
    shrink_dist = 7; % Fixed distance in mm
    
    % Move vertices inward
    xyz_shrunk = xyz - shrink_dist * vertexNormals;
    
    % Create new alpha shape
    shp_shrunk = alphaShape(xyz_shrunk, 13);

    [tri_shrunk,xyz_shrunk]=boundaryFacets(shp_shrunk);

    
    % Extract triangle vertex positions from connectivity
    v1 = xyz_shrunk(tri_shrunk(:, 1), :);
    v2 = xyz_shrunk(tri_shrunk(:, 2), :);
    v3 = xyz_shrunk(tri_shrunk(:, 3), :);

    % Compute face centers (midpoint of each triangle)
    faceCenters = (v1 + v2 + v3) / 3;  % Mx3 matrix
    
    % Create KD-tree using face centers
    KDTree = createns(faceCenters, 'NSMethod', 'kdtree');

    % Find nearest face center for each ROI point
    [~,distances] = knnsearch(KDTree, points_set);  % Returns indices of closest faces

    % Determine if points are inside the alpha shape
    inside = inShape(shp_shrunk, points_set(:, 1), points_set(:, 2), points_set(:, 3));

    % Assign signed distance: positive if inside, negative if outside
    distances(~inside) = -distances(~inside);
    
    disp('Sulcal depth calculation completed.');
end 