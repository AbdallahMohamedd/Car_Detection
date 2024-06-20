clc;
clear;
%% Determine Reference Background
Reference = vision.ForegroundDetector('NumGaussians', 7, 'NumTrainingFrames', 67);

%% Read video
videoReader = VideoReader('aaaa.mp4');

%% Extract frame rate
disp(['Frame Rate: ' ,num2str(videoReader.FrameRate), ' fps']);

%% Generate Frame Matrix
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    before_filter = step(Reference, frame);     %%Binary matrix
    %%%%----------------- To remove noise -----------------%%%%
    se = strel('square', 11); %%change to more clearance frame
    after_filter = imopen(before_filter, se);
% figure; imshow(frame); title('Frame');
% figure; imshow(before_filter); title('before_filter');
% figure; imshow(after_filter); title('Clean Foreground');
end 
%  figure; imshow(frame); title('Frame');
%  figure; imshow(before_filter); title('before_filter');
%  figure; imshow(after_filter); title('Clean Foreground');
%%
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 365, 'MaximumBlobArea', 700, 'LabelMatrixOutputPort', 4);
videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position (3:4)= [640,360];
videoReader = VideoReader('aaaa.mp4');
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    before_filter = step(Reference, frame);
    after_filter = imopen(before_filter, se);
    the_Box = step(blobAnalysis, after_filter);
    Detected_Car = insertShape(frame, 'Rectangle', the_Box, 'Color', 'green', 'LineWidth', 50 );
    Number_of_Cars = size(the_Box, 1);
    Detected_Car = insertText(Detected_Car, [10 10], Number_of_Cars, 'FontSize', 14);
    step(videoPlayer, Detected_Car);
    pause(0.5/30);
end
