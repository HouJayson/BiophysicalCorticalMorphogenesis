function [GC, MC_dimensionless, MC, k_max, k_min,shapeIndex] = Curvatures(tri, x, y, z)

tri3d = triangulation(tri, [x, y, z]);
bndry_edge = freeBoundary(tri3d);
f_normal = faceNormal(tri3d);
f_center = incenter(tri3d);

% Preallocate arrays
num_points = length(x);
area_tri = zeros(num_points, 1);
ang_tri = zeros(num_points, 3);
l_edg = zeros(num_points, 3);
v1 = zeros(num_points, 3);
v2 = zeros(num_points, 3);
v3 = zeros(num_points, 3);
a_mixed = zeros(1, num_points);
Lc = zeros(1, num_points);
alf = zeros(1, num_points);
GC = zeros(num_points, 1);
MC = zeros(num_points, 1);
MC_mean = zeros(num_points, 1);
k_max = zeros(num_points, 1);
k_min = zeros(num_points, 1);
MC_dimensionless = zeros(num_points, 1);
shapeIndex = zeros(num_points, 1);

% Calculate areas and angles for each triangle
for i = 1:length(tri(:, 1))
    v1_temp = [x(tri(i, 2)) - x(tri(i, 1)), y(tri(i, 2)) - y(tri(i, 1)), z(tri(i, 2)) - z(tri(i, 1))];
    v2_temp = [x(tri(i, 3)) - x(tri(i, 1)), y(tri(i, 3)) - y(tri(i, 1)), z(tri(i, 3)) - z(tri(i, 1))];
    area_tri(i) = 0.5 * norm(cross(v1_temp, v2_temp));

    % Compute edge lengths and angles
    v1(i, :) = [x(tri(i, 2)) - x(tri(i, 1)), y(tri(i, 2)) - y(tri(i, 1)), z(tri(i, 2)) - z(tri(i, 1))];
    v2(i, :) = [x(tri(i, 3)) - x(tri(i, 2)), y(tri(i, 3)) - y(tri(i, 2)), z(tri(i, 3)) - z(tri(i, 2))];
    v3(i, :) = [x(tri(i, 1)) - x(tri(i, 3)), y(tri(i, 1)) - y(tri(i, 3)), z(tri(i, 1)) - z(tri(i, 3))];

    l_edg(i, :) = [norm(v1(i, :)), norm(v2(i, :)), norm(v3(i, :))];

    ang_tri(i, 1) = acos(dot(v1(i, :) / l_edg(i, 1), -v3(i, :) / l_edg(i, 3)));
    ang_tri(i, 2) = acos(dot(-v1(i, :) / l_edg(i, 1), v2(i, :) / l_edg(i, 2)));
    ang_tri(i, 3) = pi - (ang_tri(i, 1) + ang_tri(i, 2));
end

% Calculate curvatures for each point
bndry_idx = ismember(1:num_points, bndry_edge); % boundary indices (logical array)
for i = 1:num_points
    if bndry_idx(i) % Skip boundary nodes
        GC(i) = 0;
        MC(i) = 0;
        MC_dimensionless(i) = 0;
        k_max(i) = 0;
        k_min(i) = 0;
        continue;
    end

    mc_vec = [0, 0, 0];
    n_vec = [0, 0, 0];

    neib_tri = vertexAttachments(tri3d, i); % Neighbouring triangles

    % Calculate angles around point i for GC and MC
    for j = 1:length(neib_tri{1})
        neib = neib_tri{1}(j);

        % Sum of angles for Gaussian Curvature (GC)
        for k = 1:3
            if tri(neib, k) == i
                alf(i) = alf(i) + ang_tri(neib, k);
                break;
            end
        end

        % Mean curvature vector calculation
        if k == 1
            mc_vec = mc_vec + (v1(neib, :) / tan(ang_tri(neib, 3)) - v3(neib, :) / tan(ang_tri(neib, 2)));
        elseif k == 2
            mc_vec = mc_vec + (v2(neib, :) / tan(ang_tri(neib, 1)) - v1(neib, :) / tan(ang_tri(neib, 3)));
        elseif k == 3
            mc_vec = mc_vec + (v3(neib, :) / tan(ang_tri(neib, 2)) - v2(neib, :) / tan(ang_tri(neib, 1)));
        end

        % A_mixed calculation
        if ang_tri(neib, k) >= pi / 2
            a_mixed(i) = a_mixed(i) + area_tri(neib) / 2;
        else
            if any(ang_tri(neib, :) >= pi / 2)
                a_mixed(i) = a_mixed(i) + area_tri(neib) / 4;
            else
                sum_edge = 0;
                for m = 1:3
                    if m ~= k
                        ll = mod(m, 3) + 1;
                        sum_edge = sum_edge + (l_edg(neib, ll)^2 / tan(ang_tri(neib, m)));
                    end
                end
                a_mixed(i) = a_mixed(i) + sum_edge / 8;
            end
        end

        % Normal vector calculation (weighted average)
        wi = 1 / norm([f_center(neib, 1) - x(i), f_center(neib, 2) - y(i), f_center(neib, 3) - z(i)]);
        n_vec = n_vec + wi * f_normal(neib, :);
    end

    % Calculate Lc
    Lc(i) = sqrt(a_mixed(i) / (4 * pi));

    % Gaussian curvature (GC)
    GC(i) = (2 * pi - alf(i)) / a_mixed(i);

    % Mean curvature vector (MC)
    mc_vec = 0.25 * mc_vec / a_mixed(i);
    n_vec = n_vec / norm(n_vec);

    % Sign of MC
    if dot(mc_vec, n_vec) < 0
        MC(i) = norm(mc_vec);
    else
        MC(i) = -norm(mc_vec);
    end
    MC_dimensionless(i) = MC(i) * Lc(i);

    % Maximum and minimum curvatures (k_max, k_min)
    k_max(i) = MC(i) + sqrt(abs(MC(i)^2 - GC(i)));
    k_min(i) = MC(i) - sqrt(abs(MC(i)^2 - GC(i)));

    if k_max(i)==k_min(i)
        shapeIndex(i) = 1;
    else
        shapeIndex(i) = 2 / pi * atan((k_max(i) + k_min(i)) / (k_max(i) - k_min(i)));
    end
end

% Calculate the mean curvature of neighbors
for i = 1:num_points
    if ~bndry_idx(i) % Skip boundary nodes
        neib_tri = vertexAttachments(tri3d, i);
        nodeidx_neighbor = unique(tri(neib_tri{1}));
        MC_mean(i) = mean(MC(nodeidx_neighbor));
    end
end
disp('curvature calculation finished');
end
