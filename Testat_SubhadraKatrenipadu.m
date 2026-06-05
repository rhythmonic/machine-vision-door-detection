%% 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Matlab Lab Testat Winter Term 2020/21                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
%%%% Read in a test image with a door %%%%%

% First test image 
image = imread('./01 - R2441 - i.JPG');
[M N C] = size(image);
figure(1),imshow(image,'Border','tight');

% Second test image
%image = imread('./01 - R2442 - i.JPG');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 1: Image Preprocessing - Contrast Adjustment, Noise Reduction      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Your code goes here ...

%%%% Conversion to Gray Value Image %%%%
img_gray = rgb2gray(image);

%%%% Adjust Contrast %%%%
img_contrast = imadjust(img_gray);


%%%% Noise reduction via binomial low-pass filtering %%%% 
 h = [1 4 6 4 1] / 16;
img = imfilter(img_contrast, h, 'replicate');
img = imfilter(img, h', 'replicate');

%%%% If you have no result load the given one %%%%
%%
load('Solutions_Task_1.mat')
figure(1),imshow(img,'Border','tight');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2: Feature Extraction - Contours                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Your code goes here ...

%%%% Optimized Sobel x %%%%
Sx = (1/32) * [-3 0 3; -10 0 10; -3 0 3];
Sy = (1/32) * [-3 -10 -3; 0 0 0; 3 10 3];

img_sobel_x = imfilter(double(img), Sx, 'replicate');
img_sobel_y = imfilter(double(img), Sy, 'replicate');


%%%% Edge Strength %%%%
img_edge_strength_x = abs(img_sobel_x);
img_edge_strength_y = abs(img_sobel_y);


% Negative x-Gradients (bright to dark)  %
Tx = 0.7 * mean(img_edge_strength_x(:));
img_neg_edge_x = (img_sobel_x < 0) & (img_edge_strength_x > Tx);

% Define edge strength threshold %

% Segment strong negative x-Gradients %

% Noise reduction %
img_neg_edge_x = imopen(img_neg_edge_x, strel('square',3));

% Dilate for 1 pixel %
img_neg_edge_x = imdilate(img_neg_edge_x, strel('diamond',1));

% Positive x-Gradients (dark to bright) %
img_pos_edge_x = (img_sobel_x > 0) & (img_edge_strength_x > Tx);


% Segment strong positive x-Gradients %

% Noise reduction %
img_pos_edge_x = imopen(img_pos_edge_x, strel('square',3));

% Dilate for 1 pixel %
img_pos_edge_x = imdilate(img_pos_edge_x, strel('diamond',1));
% Optimized Sobel y %

% Negative y-Gradients (bright to dark)  %
Ty = 0.7 * mean(img_edge_strength_y(:));
img_neg_edge_y = (img_sobel_y < 0) & (img_edge_strength_y > Ty);
% Define y-edge strength threshold %

% Segment strong negative y-Gradients %

% Noise reduction %
img_neg_edge_y = imopen(img_neg_edge_y, strel('square',3));

% Dilate for 1 pixel %
img_neg_edge_y = imdilate(img_neg_edge_y, strel('diamond',1));
% Positive y-Gradients (dark to bright) %
img_pos_edge_y = (img_sobel_y > 0) & (img_edge_strength_y > Ty);
% Segment strong positive y-Gradients %

% Noise reduction %
img_pos_edge_y = imopen(img_pos_edge_y, strel('square',3));

% Dilate for 1 pixel %
img_pos_edge_y = imdilate(img_pos_edge_y, strel('diamond',1));
%%%% If you have no result load the given one %%%%
%%
load('Solutions_Task_2.mat')
%%
%%%% Visualize Results %%%%
figure(2),imagesc(img_sobel_x); colorbar; colormap hsv; axis off;
figure(3),imagesc(log(1+img_edge_strength_x)); colorbar; axis off;
figure(4),imagesc(img_neg_edge_x); colorbar; colormap gray; axis off;
figure(5),imagesc(img_pos_edge_x); colorbar; colormap gray; axis off;
figure(6),imagesc(img_neg_edge_y); colorbar; colormap gray; axis off;
figure(7),imagesc(img_pos_edge_y); colorbar; colormap gray; axis off;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 3: Segmentation of Door Gap Contour                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Your code goes here ...

% Extract Vertical Edge candidates for %
img_sym_x = img_neg_edge_x & img_pos_edge_x;

% Design a symmetric filter %

% Combine knowledge on gray value range and bright-to-dark gradients 

% Fatten lines to improve detection
candidates_x = imclose(img_sym_x, strel('line',15,90));
candidates_x = imdilate(candidates_x, strel('diamond',1));

% Extract Horizontal Edge candidates 
img_sym_y = img_neg_edge_y & img_pos_edge_y;
% Combine knowledge on absolute gray value and bright-to-dark-gradient

% Fatten lines to improve detection 
candidates_y = imclose(img_sym_y, strel('line',15,0));
candidates_y = imdilate(candidates_y, strel('diamond',1));

%%%% If you have no result load the given one %%%%
%%
load('Solutions_Task_3.mat')
%%
%%%% Visualize Results %%%%
figure(8),imagesc(max(max(img_sym_x))-abs(img_sym_x));colorbar; colormap gray;axis off;
figure(9),imagesc(1-candidates_x);colorbar; colormap gray;axis off;
figure(10),imagesc(1-candidates_y);colorbar; colormap gray;axis off
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 4: Measuring Lines of the Door Gap                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Your code goes here ...

% Compute Hough space for vertical lines
[H_x, theta_x, rho_x] = hough(candidates_x);

%%%% Find vertical Hough Lines %%%%
P_x = houghpeaks(H_x, 2);
lines_x = houghlines(candidates_x, theta_x, rho_x, P_x);


% Transform two best candidates to Hesse Normalform
l_x = zeros(3,2);
for k = 1:2
    a = cosd(lines_x(k).theta);
    b = sind(lines_x(k).theta);
    c = -lines_x(k).rho;
    l_x(:,k) = [a; b; c];
end


% Compute Hough space for horizontal lines
[H_y, theta_y, rho_y] = hough(candidates_y);

%%%% Find horizontal Hough Lines %%%%
P_y = houghpeaks(H_y, 2);
lines_y = houghlines(candidates_y, theta_y, rho_y, P_y);


% Transform two best candidates to Hesse Normalform
l_y = zeros(3,2);
for k = 1:2
    a = cosd(lines_y(k).theta);
    b = sind(lines_y(k).theta);
    c = -lines_y(k).rho;
    l_y(:,k) = [a; b; c];
end
%%
%%%% If you have no result load the given one %%%%

load('Solutions_Task_4.mat')
%%
%%%% Visualize Results %%%%
figure(11),imshow(image,'Border','tight');hold on;
for k=1:2,
    plot([round(-(l_x(2,k)+l_x(3,k))/l_x(1,k)); round(-(M*l_x(2,k)+l_x(3,k))/l_x(1,k));],...
    [1,M],...
    'LineWidth',1,'Color','green');hold on;
end
for k=1:2,
plot([1,N],...
    [round(-(l_y(1,k)+l_y(3,k))/l_y(2,k)); round(-(N*l_y(1,k)+l_y(3,k))/l_y(2,k));],... 
    'LineWidth',1,'Color','green');hold on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 5: Measure and Classify Corner Points                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Your code goes here ...

% Find left and right door gap lines %
[~, idx_x] = sort(abs(l_x(3,:)));
l_x_left  = l_x(:,idx_x(1));
l_x_right = l_x(:,idx_x(2));

% Find up and down door gap lines %
[~, idx_y] = sort(abs(l_y(3,:)));
l_y_up   = l_y(:,idx_y(1));
l_y_down = l_y(:,idx_y(2));


% Find corner points %
intersect = @(l1,l2) ...
    [ (l1(2)*l2(3)-l1(3)*l2(2)) / (l1(1)*l2(2)-l1(2)*l2(1)); ...
      (l1(3)*l2(1)-l1(1)*l2(3)) / (l1(1)*l2(2)-l1(2)*l2(1)) ];

lb = intersect(l_x_left,  l_y_down);   % left bottom
lu = intersect(l_x_left,  l_y_up);     % left upper
ru = intersect(l_x_right, l_y_up);     % right upper
rb = intersect(l_x_right, l_y_down);   % right bottom



%%%% If you have no result load the given one %%%%

load('Solutions_Task_5.mat')
%%%% Visualize Results %%%%
figure(12),imshow(image,'Border','tight');hold on;
plot([round(-(l_x_left(2)+l_x_left(3))/l_x_left(1)); round(-(M*l_x_left(2)+l_x_left(3))/l_x_left(1));],...
    [1,M],...
    'LineWidth',1,'Color','red');hold on;
plot([round(-(l_x_right(2)+l_x_right(3))/l_x_right(1)); round(-(M*l_x_right(2)+l_x_right(3))/l_x_right(1));],...
    [1,M],...
    'LineWidth',1,'Color','green');hold on;
plot([1,N],...
    [round(-(l_y_up(1)+l_y_up(3))/l_y_up(2)); round(-(N*l_y_up(1)+l_y_up(3))/l_y_up(2));],... 
    'LineWidth',1,'Color','red');hold on;
plot([1,N],...
    [round(-(l_y_down(1)+l_y_down(3))/l_y_down(2)); round(-(N*l_y_down(1)+l_y_down(3))/l_y_down(2));],... 
    'LineWidth',1,'Color','green');hold on;
plot(lb(1),lb(2),'ro','MarkerFaceColor','r');hold on;
plot(lu(1),lu(2),'go','MarkerFaceColor','g');hold on;
plot(ru(1),ru(2),'bo','MarkerFaceColor','b');hold on;
plot(rb(1),rb(2),'ko','MarkerFaceColor','k');hold on;
