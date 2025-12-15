function [n_sulci, labels, stats,F_keep] = countSulcalBasins(V, F, H, opts)
% COUNT SULCAL BASINS on a cortical surface using curvature valleys.
% Inputs:
%   V    : Nx3 vertices
%   F    : Mx3 faces (1-based indices)
%   H    : Nx1 mean curvature (negative = valley if outward normals)
%   opts : struct with fields (all optional)
%       .smooth_iters  (default 3)     % scalar-field smoothing iters
%       .smooth_alpha  (default 0.5)   % smoothing step (0..1)
%       .thresh_mode   (default 'percentile') % 'percentile' | 'sigma' | 'fixed'
%       .thresh_value  (default 30)    % percentile (if 'percentile'), or k*sigma (if 'sigma'), or absolute value (if 'fixed')
%       .min_vertices  (default 50)    % min vertices per basin (noise filter)
%       .min_area      (default 5)     % mm^2 minimum basin area (noise filter)
%       .visualize     (default true)  % show colored basins
%
% Outputs:
%   n_sulci : number of basins after filtering
%   labels  : Nx1 integer labels (0 = background; 1..n_sulci = sulcal basins)
%   stats   : table with per-basin stats (id, nVerts, area, meanH, minH)
%   F_keep  : surface index of determined sulcus 

if nargin < 4, opts = struct(); end
opts = setdefault(opts, 'smooth_iters', 3);
opts = setdefault(opts, 'smooth_alpha', 0.5);
opts = setdefault(opts, 'thresh_mode', 'percentile');   % 'percentile'|'sigma'|'fixed'
opts = setdefault(opts, 'thresh_value', 30);            % 30th percentile by default
opts = setdefault(opts, 'min_vertices', 50);
opts = setdefault(opts, 'min_area', 5);                 % mm^2
opts = setdefault(opts, 'visualize', true);

V = double(V); F = double(F);
H = double(H(:));

% --- 0) Check curvature sign (optional sanity)
% Sulci should have NEGATIVE mean curvature if V normals are outward.
% If most are positive (rare for sulci), flip sign.
negFrac = mean(H < 0);
if negFrac < 0.3
    warning('Few negative curvatures detected (%.1f%%). Flipping sign of H.', 100*negFrac);
    H = -H;
end

% --- 1) Smooth the scalar curvature on the mesh (uniform Laplacian on vertices)
Hs = smooth_scalar_on_mesh(V, F, H, opts.smooth_iters, opts.smooth_alpha);

% --- 2) Threshold to get a "valley" mask
switch lower(opts.thresh_mode)
    case 'percentile'
        % threshold among ALL vertices but clamp to negative
        t = prctile(Hs, opts.thresh_value);
        mask = Hs < min(t, -eps);
    case 'sigma'
        mu = mean(Hs);
        sd = std(Hs);
        t = mu - opts.thresh_value * sd;  % keep sufficiently below mean
        mask = Hs < min(t, -eps);
    case 'fixed'
        % keep vertices below a fixed negative threshold (e.g., -0.02 mm^-1)
        t = -abs(opts.thresh_value);
        mask = Hs < t;
    otherwise
        error('Unknown thresh_mode.');
end

% Remove isolated singletons quickly
mask = mask(:);

% --- 3) Build vertex adjacency and run connected components on masked subgraph
A = vertex_adjacency(F, size(V,1));              % sparse NxN
idx_mask = find(mask);
subA = A(idx_mask, idx_mask);
G = graph(subA | subA.');                        % undirected
comp = zeros(size(mask));
if ~isempty(idx_mask)
    c = conncomp(G);             % 1..K on masked vertices
    comp(idx_mask) = c;                          % map back to full vertex set
end

% --- 4) Compute per-component area & stats, filter by min_area/min_vertices
triA = triangle_areas(V, F);                     % Mx1
% Assign triangle to a component if all 3 verts share the same nonzero comp id
cF = comp(F);
same = (cF(:,1) == cF(:,2)) & (cF(:,2) == cF(:,3)) & (cF(:,1) > 0);
Fc = cF(same,1);                                 % component id per kept face
% Ac = accumarray(Fc, triA(same), [], @sum, 0);
% 
% K = max(comp);

K = max(comp);
Ac = zeros(K,1);
if any(same)                      % only if some faces are fully labeled
    Fc = cF(same,1);
    Ac = accumarray(Fc, triA(same), [K 1], @sum, 0);
end

keep = false(K,1);
nVerts = zeros(K,1);
meanH  = zeros(K,1);
minH   = zeros(K,1);
keepF = false(size(F,1),1);

for k = 1:K
    verts_k = (comp == k);
    nVerts(k) = nnz(verts_k);
    if nVerts(k) == 0, continue; end
    meanH(k)  = mean(Hs(verts_k));
    minH(k)   = min(Hs(verts_k));
    area_k    = Ac(k);
    keep(k)   = (nVerts(k) >= opts.min_vertices) & (area_k >= opts.min_area);
end

% Relabel kept components to 1..n_sulci
labels = zeros(size(comp));
kept_ids = find(keep);
n_sulci = numel(kept_ids);
for i = 1:n_sulci
    labels(comp == kept_ids(i)) = i;
end

% Stats table
area_kept = Ac(kept_ids);
stats = table((1:n_sulci).', area_kept(:), nVerts(kept_ids), meanH(kept_ids), minH(kept_ids), ...
    'VariableNames', {'id','area_mm2','nVerts','meanH','minH'});


keepF(same) = ismember(Fc, kept_ids);
F_keep = F(keepF,:);


% --- 5) Visualize
if opts.visualize
    figure('Color','w'); hold on; axis equal off;
    % Color vertices by label (background = light gray)
    C = 0.85*ones(size(V,1),1);              % gray bg
    if n_sulci > 0
        % assign distinct colors by label id
        baseColors = lines(max(n_sulci,7));
        for i = 1:n_sulci
            C(labels == i) = i; 
        end 
        % Use patch with FaceVertexCData
        patch('Faces',F(keepF,:),'Vertices',V, ...
                  'FaceVertexCData',C, 'FaceColor','interp', ...
                  'EdgeColor','none', 'FaceAlpha',1);
        hold on 
        patch('Faces',F,'Vertices',V, ...
            'FaceVertexCData',C, 'FaceColor','interp', ...
            'EdgeColor','none', 'FaceAlpha',0.3);

        colormap([0.85 0.85 0.85; baseColors(1:n_sulci,:)]);
        camlight; lighting gouraud;
    else
        patch('Faces',F,'Vertices',V,'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
        camlight; lighting gouraud;
        title('No sulcal basins kept (try relaxing thresholds).');
    end
    title(sprintf('Sulcal basins: %d', n_sulci));
end
end

% ---------- helpers ----------
function opts = setdefault(opts, field, val)
if ~isfield(opts, field) || isempty(opts.(field)), opts.(field) = val; end
end

function A = vertex_adjacency(F, N)
% Build symmetric vertex adjacency (ignores self edges)
I = [F(:,1); F(:,2); F(:,3)];
J = [F(:,2); F(:,3); F(:,1)];
A = sparse(I,J,1,N,N); 
A = A | A.'; 
A = A - diag(diag(A));
end

function triA = triangle_areas(V, F)
% Triangle area via cross product
v1 = V(F(:,2),:) - V(F(:,1),:);
v2 = V(F(:,3),:) - V(F(:,1),:);
triA = 0.5 * sqrt(sum(cross(v1, v2, 2).^2, 2));
end

function Hs = smooth_scalar_on_mesh(V, F, S, iters, alpha)
% Simple uniform Laplacian smoothing of a scalar field on vertices
N = size(V,1);
A = vertex_adjacency(F, N);
deg = full(sum(A,2));
Dinv = spdiags(1./max(deg,1), 0, N, N);
W = Dinv * A;             % neighbor averaging
Hs = S(:);
for t = 1:iters
    Hs = (1 - alpha)*Hs + alpha*(W*Hs);
end
end
