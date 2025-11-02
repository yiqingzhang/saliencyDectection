function [im] = drawRectangleOnImage(im, boundingbox)
% DRAWRECTANGLEONIMAGE - Draw bounding boxes on an image
%
% This function draws rectangular bounding boxes on an image.
%
% Syntax:
%   im = drawRectangleOnImage(im, boundingbox)
%
% Inputs:
%   im - Input RGB image (H x W x 3 uint8 array)
%   boundingbox - Bounding box coordinates (N x 4 matrix)
%                 Each row: [row_min, col_min, row_max, col_max]
%
% Outputs:
%   im - Output image with bounding boxes drawn (H x W x 3 uint8 array)


for i = 1:size(boundingbox,1)
    coor1 = boundingbox(i,1);
    coor2 = boundingbox(i,2);
    coor3 = boundingbox(i,3);
    coor4 = boundingbox(i,4);

    % Use red color for bounding box
    R = uint8(255);
    G = uint8(0);
    B = uint8(0);

    % Draw left line
    im(coor1:coor3,coor2,1) = R;
    im(coor1:coor3,coor2,2) = G;
    im(coor1:coor3,coor2,3) = B;

    % Draw right line
    im(coor1:coor3,coor4,1) = R;
    im(coor1:coor3,coor4,2) = G;
    im(coor1:coor3,coor4,3) = B;

    % Draw top line
    im(coor1,coor2:coor4,1) = R;
    im(coor1,coor2:coor4,2) = G;
    im(coor1,coor2:coor4,3) = B;

    % Draw bottom line
    im(coor3,coor2:coor4,1) = R;
    im(coor3,coor2:coor4,2) = G;
    im(coor3,coor2:coor4,3) = B;

end

end