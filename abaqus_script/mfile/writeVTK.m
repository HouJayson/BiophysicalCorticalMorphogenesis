function writeVTK(filename, points, connectivity)
    % Function to write VTK file with quadrilateral connectivity
    %
    % Inputs:
    %   - filename: Name of the VTK file to create (string)
    %   - points: Matrix of node coordinates (nPoints x 3)
    %   - connectivity: Quadrilateral connectivity (nQuads x 4)
    %
    % Example Usage:
    %   points = [0 0 0; 1 0 0; 1 1 0; 0 1 0]; % 4 points
    %   connectivity = [1 2 3 4]; % Single quad element
    %   writeVTK_quadrilateral('example.vtk', points, connectivity);

    % Open the file for writing
    fid = fopen(filename, 'w');
    if fid == -1
        error('Could not open file for writing.');
    end

    % Write the VTK header
    fprintf(fid, '# vtk DataFile Version 4.0\n');
    fprintf(fid, 'VTK file with quadrilateral connectivity\n');
    fprintf(fid, 'ASCII\n');
    fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');

    % Write points (nodes) section
    nPoints = size(points, 1);
    fprintf(fid, 'POINTS %d float\n', nPoints);
    for i = 1:nPoints
        fprintf(fid, '%f %f %f\n', points(i, :));
    end

    % Write quadrilateral connectivity (cells) section
    nQuads = size(connectivity, 1);
    nEntries = nQuads * 5; % Each cell has 1 size entry + 4 nodes
    fprintf(fid, '\nCELLS %d %d\n', nQuads, nEntries);
    for i = 1:nQuads
        fprintf(fid, '4 %d %d %d %d\n', connectivity(i, :) - 1); % VTK uses 0-based indexing
    end

    % Write cell types (VTK_QUAD)
    VTK_QUAD = 9; % VTK code for quadrilateral cells
    fprintf(fid, '\nCELL_TYPES %d\n', nQuads);
    for i = 1:nQuads
        fprintf(fid, '%d\n', VTK_QUAD);
    end

    % Close the file
    fclose(fid);

    fprintf('VTK file "%s" written successfully.\n', filename);
end
