function NumberOfCircles = HoughCircleDetector(img, plot_show)
%% Example program to use the "hough circle transform" function
%img = imread('im_processed_example_0.5x.png');
% convert the image to grayscale
%rawimg = rgb2gray(rawimg);

tic;
[accumulation_array, centers, radii] = HoughCircleTransform(img, [2 25]);
toc;

% Visualize the accumulation array
% figure(1); imagesc(accumulation_array); axis image;
% title('Accumulation Array from Circular Hough Transform');

if (plot_show==1)
    % plot the recognized circles
    figure(2); imagesc(img); colormap('gray'); axis image;
    hold on; plot(centers(:,1), centers(:,2), 'r+');
    for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), radii(k), 32, 'b-');
    end
    hold off;
    title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);
end

% 3D view of the local maxima
% figure(3); surf(accumulation_array, 'EdgeColor', 'none'); axis ij;
% title('3-D View of the Accumulation Array');

%Number of circles detected
NumberOfCircles = length(centers); 
end

