function [BW,maskedImage] = segmentImage(X)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 21-Oct-2018
%----------------------------------------------------


% Create empty mask.
BW = false(size(X,1),size(X,2));

% Local graph cut
xPos = [18.7560 57.9560 57.9560 18.7560 ];
yPos = [35.9400 35.9400 67.3000 67.3000 ];
m = size(BW, 1);
n = size(BW, 2);
ROI = poly2mask(xPos,yPos,m,n);
foregroundInd = [];
backgroundInd = [];
L = superpixels(X,208);
BW = BW | grabcut(X,L,ROI,foregroundInd,backgroundInd);

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

