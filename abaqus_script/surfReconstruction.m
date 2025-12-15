% ---------------------------------------------------------
% ------- Code for abaqus results postprocessing ----------
% ---------------------------------------------------------

clc;clear;

addpath('E:\PhD\PINN\WholeBrain\Postprocessing\functionsMat');                               % matlab functions 
addpath('E:\PhD\PINN\WholeBrain\Postprocessing\datafromAbaqus\connectivityFiles\smooth');    % face connectivity
addpath('E:\PhD\PINN\WholeBrain\Postprocessing\datafromAbaqus\rawData\dataSmooth');          % raw data from simulation
addpath('E:\PhD\PINN\WholeBrain\Mesh\SmoothSurface\inputFiles');                             % reference vtk file

caseId  = {'S01'};
idx = 1;

coordinate_file_gray = sprintf('Data_%s_gray_smooth.xlsx', caseId{idx});
coordinate_file_medium = sprintf('Data_%s_medium_smooth.xlsx',caseId{idx});
coordinate_file_white = sprintf('Data_%s_white_smooth.xlsx',caseId{idx});
connectivity_file = sprintf('Surface_connectivity_%s_smooth.xlsx', caseId{idx});

reference_file_inner = ['22_lh.InnerSurf_', caseId{idx}, '.vtk'];
reference_file_outer = ['22_lh.OuterSurf_', caseId{idx}, '.vtk'];

dataStoragePath = 'E:\PhD\PINN\WholeBrain\Postprocessing\dataTemp\';
fullFilePath = fullfile(dataStoragePath, ['Input_', caseId{idx}]);
if ~exist(fullFilePath, 'dir')
    mkdir(fullFilePath);
end
casename = ['Brain_',caseId{idx}];
max_frame = 100;
num_frames= max_frame/5 + 1;
%%
% Set parameters
iterations = 10;
lambda = 0.3;
batchSize = 1000;

% Surface and connectivity sheets
sheets = struct( ...
    'gray',   'graysurf_connectivity_region19', ...
    'medium', 'midsurf_connectivity_region19', ...
    'white',  'whitesurf_connectivity_region19');

% Read surface connectivity
SurfConnectivity.gray   = readmatrix(connectivity_file, 'Sheet', sheets.gray);
SurfConnectivity.medium = readmatrix(connectivity_file, 'Sheet', sheets.medium);
SurfConnectivity.white  = readmatrix(connectivity_file, 'Sheet', sheets.white);

% Read initial coordinates
Nodes.gray   = readmatrix(coordinate_file_gray, 'Sheet', 'Frame0');
Nodes.medium = readmatrix(coordinate_file_medium, 'Sheet', 'Frame0');
Nodes.white  = readmatrix(coordinate_file_white, 'Sheet', 'Frame0');

% Extract node coordinates
for type = ["gray", "medium", "white"]
    NodeCoord.(type) = Nodes.(type)(:, 1:3);
    triConn.(type) = quadToTriConnectivity(SurfConnectivity.(type), NodeCoord.(type));
    smoothedCoord.(type) = laplacianSmoothing(triConn.(type), NodeCoord.(type), iterations, lambda);
end

% Read parcellation info
pvtk_inner = mvtk_read(reference_file_inner);
pvtk_outer = mvtk_read(reference_file_outer);
par_info_huang = pvtk_inner.par_huang;
par_info_FS2009 = pvtk_inner.par_FS2009;

% Compute parcellation nodes
Nodes_par.inner  = pvtk_inner.vertices;
Nodes_par.outer  = pvtk_outer.vertices;
Nodes_par.medium = (Nodes_par.inner + Nodes_par.outer) / 2;

% Create k-d trees
for surface = ["inner", "medium", "outer"]
    kdtree.(surface) = createns(Nodes_par.(surface), 'NSMethod', 'kdtree');
end

% Assign parcellation
par_simulation_huang.gray   = assignParcellation(smoothedCoord.gray,   kdtree.inner,  par_info_huang, batchSize);
par_simulation_FS2009.gray   = assignParcellation(smoothedCoord.gray,   kdtree.inner,  par_info_FS2009, batchSize);
par_simulation_huang.medium = assignParcellation(smoothedCoord.medium, kdtree.medium, par_info_huang, batchSize);
par_simulation_FS2009.medium   = assignParcellation(smoothedCoord.medium,   kdtree.medium,  par_info_FS2009, batchSize);
par_simulation_huang.white  = assignParcellation(smoothedCoord.white,  kdtree.outer,  par_info_huang, batchSize);
par_simulation_FS2009.white   = assignParcellation(smoothedCoord.white,   kdtree.outer,  par_info_FS2009, batchSize);

%
% ---------------------------------------------------------
% --- Write vtk file of each frame into "Input" folder ----
% ---------------------------------------------------------
%
for i =1:num_frames

    coordinate_sheet_deformed = ['Frame', num2str(5*(i-1))];
    RegionNodes_gray_deformed = readmatrix(coordinate_file_gray, 'Sheet', coordinate_sheet_deformed);
    RegionNodes_medium_deformed = readmatrix(coordinate_file_medium, 'Sheet', coordinate_sheet_deformed);
    RegionNodes_white_deformed = readmatrix(coordinate_file_white, 'Sheet', coordinate_sheet_deformed);

    NodeCoord_gray_deformed = RegionNodes_gray_deformed(:,1:3);
    NodeCoord_medium_deformed = RegionNodes_medium_deformed(:,1:3);
    NodeCoord_white_deformed = RegionNodes_white_deformed(:,1:3);

    triConnectivity_gray_deformed = triConn.gray;
    triConnectivity_medium_deformed = triConn.medium;
    triConnectivity_white_deformed = triConn.white;

    smoothedNodesCoord_gray_deformed = laplacianSmoothing(triConnectivity_gray_deformed, NodeCoord_gray_deformed, iterations, lambda);
    smoothedNodesCoord_medium_deformed = laplacianSmoothing(triConnectivity_medium_deformed, NodeCoord_medium_deformed, iterations, lambda);
    smoothedNodesCoord_white_deformed = laplacianSmoothing(triConnectivity_white_deformed, NodeCoord_white_deformed, iterations, lambda);

    vtkFilename_gray = [fullFilePath,'\gray_frame', num2str(5*(i-1)), '_',caseId{idx},'.vtk'];
    vtkFilename_medium = [fullFilePath,'\medium_frame', num2str(5*(i-1)), '_',caseId{idx},'.vtk'];
    vtkFilename_white = [fullFilePath,'\white_frame', num2str(5*(i-1)),'_',caseId{idx},'.vtk'];

    dataVTK_gray=struct('vertices',smoothedNodesCoord_gray_deformed,'faces',triConnectivity_gray_deformed,'par_huang',par_simulation_huang.gray,'par_FS2009',par_simulation_FS2009.gray);
    dataVTK_medium=struct('vertices',smoothedNodesCoord_medium_deformed,'faces',triConnectivity_medium_deformed,'par_huang',par_simulation_huang.medium,'par_FS2009',par_simulation_FS2009.medium);
    dataVTK_white=struct('vertices',smoothedNodesCoord_white_deformed,'faces',triConnectivity_white_deformed,'par_huang',par_simulation_huang.white,'par_FS2009',par_simulation_FS2009.white);

    mvtk_write(dataVTK_gray,vtkFilename_gray,'legacy');
    mvtk_write(dataVTK_medium,vtkFilename_medium,'legacy');
    mvtk_write(dataVTK_white,vtkFilename_white,'legacy');
    disp(coordinate_sheet_deformed);
end

disp('All vtk files have been written into "Input" folder.');

%%
% -------------------------------------------------------------------------------------------------------
% --- Calculating the quantitative metrics: MC, Cortical thickness,sulcal depth, local and global GI ----
% -------------------------------------------------------------------------------------------------------
%

GI = zeros(num_frames,1);
GI_alpha = zeros(num_frames,1);

tic;
for i=7:9
    last_time=toc;
    pvtk_gray=mvtk_read([fullFilePath,'\gray_frame', num2str(5*(i-1)), '_',caseId{idx},'.vtk']);
    pvtk_medium=mvtk_read([fullFilePath,'\medium_frame', num2str(5*(i-1)), '_',caseId{idx},'.vtk']);
    pvtk_white=mvtk_read([fullFilePath,'\white_frame', num2str(5*(i-1)), '_',caseId{idx},'.vtk']);

    Nodes_gray=pvtk_gray.vertices;
    Nodes_medium = pvtk_medium.vertices;
    Nodes_white=pvtk_white.vertices;
    connectivity_gray=double(pvtk_gray.faces);
    par_simu_huang = pvtk_gray.par_huang;
    par_simu_FS2009 = pvtk_gray.par_FS2009;

    txtFiles = dir([dataStoragePath, 'lgi\', sprintf('gray_frame%d_%s*.txt',5*(i-1), caseId{idx})]); 

    if isempty(txtFiles)
        warning('No matching file found for gray_frame%d', 5 * (i-1));
        continue;
    end
    lgiFilePath = fullfile([dataStoragePath, 'lgi\'], txtFiles(1).name);
    lgi = readmatrix(lgiFilePath);

    Cthickness1 = corticalThickness(Nodes_gray, Nodes_white);       
    Cthickness2 = corticalThickness(Nodes_gray, Nodes_medium);

    [GC, MC_dimensionless, MC, k_max, k_min, shapeIndex]= Curvatures(connectivity_gray,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the mean curvature
    data_to_smooth = [GC, MC_dimensionless, MC, k_max, k_min, shapeIndex];
    smoothed_data = dataSmoothing(Nodes_gray, connectivity_gray, data_to_smooth, 10, 0.5);
    GC_corr = smoothed_data(:,1);
    MC_corr = smoothed_data(:,2);
    MC_dimensionless_corr = smoothed_data(:,3);
    k_max_corr = smoothed_data(:,4);
    k_min_corr = smoothed_data(:,5);
    shapeIndex_corr = smoothed_data(:,6);

    [Connectivity_hull, vertices_hull, GI(i)]= GyrificationIndex(connectivity_gray,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the global GI
    SulcDepth = SulcalDepth(Connectivity_hull,vertices_hull,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the sulcal depth

    [Connectivity_hull_alpha, vertices_hull_alpha, GI_alpha(i)]= GyrificationIndex_alphashape(connectivity_gray,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the global GI
    SulcDepth_alpha = SulcalDepth_alphashape(Connectivity_hull_alpha,vertices_hull_alpha,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the sulcal depth
    SulcDepth_alpha_shrink = SulcalDepth_alphashape_shrink(Connectivity_hull_alpha,vertices_hull_alpha,Nodes_gray(:,1),Nodes_gray(:,2),Nodes_gray(:,3));  % calculate the sulcal depth

    data_to_smooth1= [SulcDepth,SulcDepth_alpha,SulcDepth_alpha_shrink];
    smoothed_data1 = dataSmoothing(Nodes_gray, connectivity_gray, data_to_smooth1, 2, 1);

    SulcDepth_corr = smoothed_data1(:,1);
    SulcDepth_alpha_corr = smoothed_data1(:,2);
    SulcDepth_alpha_shrink_corr = smoothed_data1(:,3);

    vtkFilename = [dataStoragePath,'DataSummary\',caseId{idx},'_data_frame', num2str(5 * (i-1)), '.vtk'];

    dataVTK=struct('vertices',Nodes_gray,'faces',connectivity_gray, ...
        'MC',MC_corr,'MC_dimensionless',MC_dimensionless_corr, 'GC',GC_corr,'k_max',k_max_corr,'k_min',k_min_corr,'shapeIndex',shapeIndex_corr,...
        'par_huang',par_simu_huang,'par_FS2009',par_simu_FS2009,'SulcDepth',SulcDepth_corr,'SulcDepth_alpha',SulcDepth_alpha_corr,'SulcDepth_alpha_shrink',SulcDepth_alpha_shrink_corr,...
        'CorticalThickness_GW',Cthickness1,'CorticalThickness_GM',Cthickness2, 'Lgi', lgi, 'GI',GI(i)*ones(length(MC_corr),1),'GI_alpha',GI_alpha(i)*ones(length(MC_corr),1));
    mvtk_write(dataVTK,vtkFilename,'legacy');
    fprintf('Frame %d, finished within %f s\n',5*(i-1), toc);
end

%%
% --------------------------------------------------------------------------------------------
% --- Collecting results by averaging those quantitative metrics throughtout each regions ----
% --------------------------------------------------------------------------------------------
%
num_regions=length(unique(par_simu_huang));

MC_aver = zeros(num_regions,num_frames);
MC_dimensionless_aver = zeros(num_regions,num_frames);
GC_aver = zeros(num_regions,num_frames);
k_max_aver = zeros(num_regions,num_frames);
k_min_aver = zeros(num_regions,num_frames);
shapeIndex_aver = zeros(num_regions,num_frames);
CThickness_GW_aver = zeros(num_regions,num_frames);
CThickness_GM_aver = zeros(num_regions,num_frames);
SulcDepth_aver = zeros(num_regions,num_frames);
SulcDepth_alpha_aver = zeros(num_regions,num_frames);
SulcDepth_alpha_shrink_aver = zeros(num_regions,num_frames);
Lgi_aver = zeros(num_regions,num_frames);
GI_aver = zeros(num_regions,num_frames);
GI_alpha_aver = zeros(num_regions,num_frames);
%
for i=1:num_frames
    pvtk = mvtk_read([dataStoragePath,'DataSummary\',caseId{idx},'_data_frame', num2str(5 * (i-1)), '.vtk']);
    for j = 1:num_regions
        MC_aver(j,i)=mean(abs(pvtk.MC(pvtk.par_huang==j-1)));
        MC_dimensionless_aver(j,i)=mean(abs(pvtk.MC_dimensionless(pvtk.par_huang==j-1)));
        GC_aver(j,i) = mean(abs(pvtk.GC(pvtk.par_huang==j-1)));
        k_max_aver(j,i) = mean(abs(pvtk.k_max(pvtk.par_huang==j-1)));
        k_min_aver(j,i) = mean(abs(pvtk.k_min(pvtk.par_huang==j-1)));
        shapeIndex_aver(j,i) = mean(abs(pvtk.shapeIndex(pvtk.par_huang==j-1)));
        CThickness_GW_aver(j,i)=mean(pvtk.CorticalThickness_GW(pvtk.par_huang==j-1));
        CThickness_GM_aver(j,i)=mean(pvtk.CorticalThickness_GM(pvtk.par_huang==j-1));
        SulcDepth_aver(j,i) = mean(abs(pvtk.SulcDepth(pvtk.par_huang==j-1)));
        SulcDepth_alpha_aver(j,i) = mean(abs(pvtk.SulcDepth_alpha(pvtk.par_huang==j-1)));
        SulcDepth_alpha_shrink_aver(j,i) = mean(abs(pvtk.SulcDepth_alpha_shrink(pvtk.par_huang==j-1)));
        Lgi_aver(j,i)=mean(pvtk.Lgi(pvtk.par_huang==j-1));
        GI_aver(j,i)=mean(pvtk.GI(pvtk.par_huang==j-1));
        GI_alpha_aver(j,i)=mean(pvtk.GI_alpha(pvtk.par_huang==j-1));
    end
end

excel_file = [dataStoragePath,'dataSummary\Data_summary_',caseId{idx},'_L.xlsx'];
time_values = (0.05 * (1:num_frames) - 0.05); % Compute time values
variable_names = {'MC_aver', 'MC_dimensionless_aver', 'GC_aver','k_max_aver','k_min_aver','shapeIndex_aver','SulcDepth_aver','SulcDepth_alpha_aver',...
    'SulcDepth_alpha_shrink_aver','CThickness_GW_aver','CThickness_GM_aver','Lgi_aver','GI_aver','GI_alpha_aver'};

% Write data to Excel
for region = 1:num_regions
    % Initialize data matrix for the region
    data_matrix = [(time_values)', ... % Frame numbers
        MC_aver(region, 1:num_frames)', ...
        MC_dimensionless_aver(region, 1:num_frames)', ...
        GC_aver(region, 1:num_frames)', ...
        k_max_aver(region, 1:num_frames)', ...
        k_min_aver(region, 1:num_frames)', ...
        shapeIndex_aver(region, 1:num_frames)', ...
        SulcDepth_aver(region, 1:num_frames)', ...
        SulcDepth_alpha_aver(region, 1:num_frames)', ...
        SulcDepth_alpha_shrink_aver(region, 1:num_frames)', ...
        CThickness_GW_aver(region, 1:num_frames)',...
        CThickness_GM_aver(region, 1:num_frames)',...
        Lgi_aver(region, 1:num_frames)',...
        GI_aver(region, 1:num_frames)',...
        GI_alpha_aver(region, 1:num_frames)',...
        ];
    % Create headers
    headers = {'Time', 'MC', 'MC_dimensionless','GC','k_max','k_min','shapeIndex','SulcDepth','SulcDepth_alpha','SulcDepth_alpha_shrink', 'CThickness_GW','CThickness_GM','LGI','GI','GI_alpha'};

    % Write to Excel
    sheet_name = sprintf('Region_%d', region - 1);
    writecell([headers; num2cell(data_matrix)], excel_file, 'Sheet', sheet_name);
end
disp('Data successfully written to Excel file.');
%
save([dataStoragePath,'dataSummary\',casename,'.mat']);


% Helper function to assign parcellation labels in parallel
function par_cell = assignParcellation(nodes, kdtree, par_info, batchSize)
numPoints = size(nodes, 1);
numBatches = ceil(numPoints / batchSize);
par_cell = cell(numBatches, 1);
parfor batch = 1:numBatches
    idxRange = (batch - 1) * batchSize + 1 : min(batch * batchSize, numPoints);
    batchPoints = nodes(idxRange, :);
    idx = knnsearch(kdtree, batchPoints);
    par_cell{batch} = par_info(idx);
end
par_cell = vertcat(par_cell{:});
end