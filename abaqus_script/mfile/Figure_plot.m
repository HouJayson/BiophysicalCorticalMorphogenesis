function Figure_plot(NodeCoord, SurfConnectivity,NodeDisp,EdgeColor,viewflag)
    patch('Vertices', NodeCoord, ...          % Node coordinates
        'Faces', SurfConnectivity, ...      % Surface face connectivity
        'FaceVertexCData', NodeDisp, ...    % Displacement values for coloring
        'FaceColor', 'interp', ...            % Color of the faces
        'EdgeColor', EdgeColor, ...           % Color of the edges
        'FaceAlpha', 1);                  % Transparency of the faces
    
    % Colormap and colorbar
    colormap jet;      

    % Set fixed color limits for the legend range
    clim([0, 20]);       % Fix the color range from 0 to 8
    
    % Create and position the colorbar
    c = colorbar;
    c.Title.String = 'U [mm]';      % Set colorbar title
    c.Title.FontSize = 8;          % Set colorbar title font size
    c.Location = 'southoutside';    % Position the colorbar at the bottom
    c.Position = [0.75, 0.15, 0.15, 0.03];  % Adjust the position (x, y, width, height)

    % Optional: Adjust additional properties of the colorbar
    c.Label.FontSize = 8;
    c.Label.FontWeight = 'bold';

    % Set fixed axis limits for x, y, and z
    xlim([-100, 100]);                           %
    ylim([-100, 100]);                          
    zlim([-100, 100]);                           

    % Set axis properties to prevent scaling or adjustments
    axis equal;                                % Ensure equal scaling along all axes
    axis manual;                               % Prevent automatic rescaling of axes
    axis off;                                 
    
    % Set a fixed view
    if viewflag==1
        view([-90, 0]);
        light('Position', [-30, 10, 30]);       % for half brain left
    elseif viewflag ==2
        view([90, 0]);
        light('Position', [30, 10, 30]);        % for half brain right
    elseif viewflag ==3
        view([-45, 150]);
        light('Position', [-30, 60, 60]);       % for whole brain
    elseif viewflag ==4
        view([45, 150]);
        light('Position', [-30, 60, 60]); 
    end

    % camproj('perspective');  % Use perspective projection for 3D visualization
end