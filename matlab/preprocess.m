% preprocess the image
% this function crops out the area of interest from the input image based
% on the features of the bottle (the lid and the bottom)

function im_processed = preprocess(im_original)
% first we downsize the image to save computation time
im = imresize(im_original,0.5);
sizefactor = round(size(im,2)/100);
% locate the lid and the bottom of the bottle
im_blur = imgaussfilt(im, sizefactor);
% the parameter is determined by trial and error
im_bw = im2bw(im_blur,0.004*mean(mean(im)));

% the lid
CC1 = bwconncomp(1-im_bw);
numPixels = cellfun(@numel,CC1.PixelIdxList);
numPixels(numPixels<30*sizefactor^2) = 9999999;
[~, idx_lid] = min(numPixels);
idx = CC1.PixelIdxList{idx_lid};
bw_lid = false(size(im_bw));
bw_lid(idx) = 1;
% fill the bright spot in the lid in some cases
bw_lid = imfill(bw_lid,'holes');
im_bw = im_bw + bw_lid;

% the bottom
CC2 = bwconncomp(im_bw);
numPixels = cellfun(@numel,CC2.PixelIdxList);
numPixels(numPixels<30*sizefactor^2) = 9999999;
[~, idx_bottom] = min(numPixels);
idx = CC2.PixelIdxList{idx_bottom};
bw_bottom = false(size(im_bw));
bw_bottom(idx) = 1;
% the bottom is smaller than the size of the bottle
[c1,c2] = ind2sub(size(bw_bottom),idx);
[c1_min,idx_min] = min(c1);
[c1_max,idx_max] = max(c1);
bw_bottom(c1_min-4*sizefactor,c2(idx_min)-sizefactor) = 1;
bw_bottom(c1_max+4*sizefactor,c2(idx_max)-sizefactor) = 1;
bw_bottom = bwconvhull(bw_bottom);

% the area of interest
bw1 = bwconvhull(bw_lid+bw_bottom)-bw_lid-bw_bottom;
CC = bwconncomp(bw1);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~, idxcell] = max(numPixels);
idx = CC.PixelIdxList{idxcell};
bw = false(size(im_bw));
bw(idx) = 1;
bw = imerode(bw,ones(sizefactor));

% get rid of the non meaningful pixels
im_processed = im.*(uint8(bw));
[c1,c2] = ind2sub(size(bw),idx);
im_processed = im_processed(min(c1):max(c1),min(c2):max(c2));