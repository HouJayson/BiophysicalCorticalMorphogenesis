function [connectivity_hull, vertices_hull_smoothed,GI]= GyrificationIndex(connectivity_surf,x,y,z)

%-------------------------------------------------------------------------------------------
% Input:  connectivity_surf: ConnectivityList utlized in "SurfRemodelling", herein it is created from the "ConnectivitybyPy" script
%       x,y,z: Coordinates of the points in ROI set
%       x_normal_thres: the threshold value utlized to filter the upper envelop surface
% Output: Connectivity_envelop: ConnectivityList corresponds to envelop surface
%      GI: gyrification index 

% Calculate the area of the cortical surface
Points_set=[x,y,z];
tri = connectivity_surf;
x = Points_set(:,1);
y = Points_set(:,2);
z = Points_set(:,3);
area_tri = zeros(size(connectivity_surf, 1), 1);
for i=1:size(tri,1)
    v1=[x(tri(i,2))-x(tri(i,1)),y(tri(i,2))-y(tri(i,1)),z(tri(i,2))-z(tri(i,1))];
    v2=[x(tri(i,3))-x(tri(i,1)),y(tri(i,3))-y(tri(i,1)),z(tri(i,3))-z(tri(i,1))];
    area_tri(i,1)=0.5*norm(cross(v1,v2));   
end
surf_area =sum(area_tri);

% Calculate the area of the envelop surface
[connectivity_hull, vertices_hull]=createOuterHull(tri,Points_set);

vertices_hull_smoothed=laplacianSmoothing(connectivity_hull, vertices_hull, 10, 0.5);


% Get the vertex coordinates of the convex hull triangles
v1 = vertices_hull_smoothed(connectivity_hull(:, 1), :);
v2 = vertices_hull_smoothed(connectivity_hull(:, 2), :);
v3 = vertices_hull_smoothed(connectivity_hull(:, 3), :);

% Calculate edge vectors and face normals
edge1 = v2 - v1;
edge2 = v3 - v1;
faceNormals = cross(edge1, edge2, 2);  % Compute face normals

% Calculate the area of each face
faceAreas = sqrt(sum(faceNormals.^2, 2)) / 2;

% Calculate the total surface area of the upper convex surface
envelop_area = sum(faceAreas);

GI = surf_area/envelop_area;
disp('gyrification sucessfully calculated');