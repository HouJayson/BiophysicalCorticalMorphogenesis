function Cthickness = corticalThickness(nodes_pial, nodes_white)
% CORTICALTHICKNESS computes the minimal distance between pial surface 
% points and white matter surface points using a kd-tree for efficient 
% nearest-neighbor search.
%
% Input:
%   nodes_pial  - Nx3 matrix, node coordinates of the pial surface
%   nodes_white - Mx3 matrix, node coordinates of the white matter surface
%
% Output:
%   Cthickness  - Nx1 vector, cortical thickness at each pial surface node

% Build kd-tree for efficient nearest-neighbor search
kdtree_white = createns(nodes_white, 'NSMethod', 'kdtree');

% Perform batch nearest-neighbor search for all pial nodes
[~, Cthickness] = knnsearch(kdtree_white, nodes_pial);

end

