
clc;
clear;
close all;


%% STEP 1: SELECT AND LOAD IMAGE

% Topic: RGB Image Representation

[file, path] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'}, ...
    'Select Original Image');

if isequal(file, 0)
    disp('No image selected.');
    return;
end

I = imread(fullfile(path, file));

% Convert RGB to grayscale
grayImage = im2gray(I);
grayDouble = im2double(grayImage);

fprintf('Image loaded successfully: %s\n', file);
fprintf('Image dimensions: %d x %d\n', size(I,1), size(I,2));


%% STEP 2: DISPLAY ORIGINAL AND GRAYSCALE IMAGE


figure('Name', 'Original and Grayscale Images', ...
    'NumberTitle', 'off');

subplot(1,2,1);
imshow(I);
title('Original Image');

subplot(1,2,2);
imshow(grayImage);
title('Grayscale Image');

drawnow;


%% STEP 3: IMAGE HISTOGRAM


figure('Name', 'Image Histogram', ...
    'NumberTitle', 'off');

imhist(grayImage);
title('Grayscale Image Histogram');
xlabel('Pixel Intensity');
ylabel('Number of Pixels');
grid on;

drawnow;


%% STEP 4: INTENSITY PROFILE


middleRow = round(size(grayDouble,1)/2);

figure('Name', 'Intensity Profile', ...
    'NumberTitle', 'off');

plot(grayDouble(middleRow,:), 'LineWidth', 1.2);
title('Horizontal Intensity Profile');
xlabel('Pixel Position');
ylabel('Normalized Intensity');
grid on;

drawnow;


%% STEP 5: FREQUENCY DOMAIN ANALYSIS

F = fft2(grayDouble);
Fshift = fftshift(F);

magnitudeSpectrum = log(1 + abs(Fshift));

figure('Name', 'Frequency Domain Analysis', ...
    'NumberTitle', 'off');

subplot(1,2,1);
imshow(grayDouble);
title('Grayscale Image');

subplot(1,2,2);
imshow(mat2gray(magnitudeSpectrum));
title('2D Fourier Magnitude Spectrum');

drawnow;


%% STEP 6: SPATIAL FILTERING

% Topics: Averaging, Median and Gaussian Filters

averageImage = imfilter(grayDouble, ...
    fspecial('average',[3 3]), 'replicate');

medianImage = medfilt2(grayDouble,[3 3]);

gaussianImage = imgaussfilt(grayDouble,1);

figure('Name', 'Spatial Filtering', ...
    'NumberTitle', 'off');

subplot(2,2,1);
imshow(grayDouble);
title('Original Grayscale');

subplot(2,2,2);
imshow(averageImage);
title('Averaging Filter');

subplot(2,2,3);
imshow(medianImage);
title('Median Filter');

subplot(2,2,4);
imshow(gaussianImage);
title('Gaussian Filter');

drawnow;


%% STEP 7: IMAGE SHARPENING


sharpenedImage = imsharpen(grayDouble);

figure('Name', 'Image Sharpening', ...
    'NumberTitle', 'off');

subplot(1,2,1);
imshow(grayDouble);
title('Original Image');

subplot(1,2,2);
imshow(sharpenedImage);
title('Sharpened Image');

drawnow;


%% STEP 8: EDGE DETECTION

%% Topic: Canny Edge Detection

edgeImage = edge(grayDouble,'Canny');

figure('Name', 'Edge Detection', ...
    'NumberTitle', 'off');

subplot(1,2,1);
imshow(grayDouble);
title('Grayscale Image');

subplot(1,2,2);
imshow(edgeImage);
title('Canny Edge Detection');

drawnow;


%% STEP 9: MORPHOLOGICAL IMAGE PROCESSING


se = strel('disk',5);

topHatImage = imtophat(grayDouble,se);
closedImage = imclose(grayDouble,se);

figure('Name', 'Morphological Processing', ...
    'NumberTitle', 'off');

subplot(1,3,1);
imshow(grayDouble);
title('Original Image');

subplot(1,3,2);
imshow(topHatImage,[]);
title('Top-Hat Transformation');

subplot(1,3,3);
imshow(closedImage,[]);
title('Morphological Closing');

drawnow;


%% STEP 10: COMPLETION MESSAGE

disp('==========================================');
disp('INITIAL DIP CONCEPT DEMONSTRATIONS DONE');
disp('==========================================');
disp('Original and grayscale images displayed.');
disp('Histogram and intensity profile displayed.');
disp('Fourier frequency spectrum displayed.');
disp('Spatial filters demonstrated.');
disp('Sharpening and edge detection demonstrated.');
disp('Morphological operations demonstrated.');
disp('Next stage: Reflection Detection and Removal.');

choice = questdlg( ...
    'Have you finished inspecting the Stage 1 results?', ...
    'Stage 1 Complete', ...
    'Continue to Stage 2', ...
    'Stop Here', ...
    'Continue to Stage 2');

if isempty(choice) || strcmp(choice, 'Stop Here')
    return;
end


%% STAGE 2: AUTOMATIC REFLECTION DETECTION

% Classical DIP-based reflection candidate detection.

% Estimate slowly varying local intensity
sigma = max(5, round(min(size(grayDouble)) / 40));
localMean = imgaussfilt(grayDouble, sigma);

% Calculate local intensity variation
localContrast = stdfilt(grayDouble, true(7));

% Detect locally brighter regions
intensityDifference = grayDouble - localMean;

brightThreshold = max(0.035, ...
    prctile(intensityDifference(:), 92));

brightCandidate = intensityDifference > brightThreshold;

% Detect high local contrast regions
contrastThreshold = prctile(localContrast(:), 92);
intensityThreshold = prctile(grayDouble(:), 55);

contrastCandidate = ...
    (localContrast > contrastThreshold) & ...
    (grayDouble > intensityThreshold);

% Combine candidate regions
reflectionMask = brightCandidate | contrastCandidate;

% Refine candidate regions
minimumArea = max(20, round(numel(grayDouble) / 20000));

reflectionMask = bwareaopen(reflectionMask, minimumArea);
reflectionMask = imclose(reflectionMask, strel('disk', 5));
reflectionMask = imfill(reflectionMask, 'holes');


%% STEP 11: DISPLAY AUTOMATICALLY DETECTED REGIONS

showReflectionOverlay(I, reflectionMask, ...
    'Automatic Reflection Detection', ...
    'Automatically Detected Reflection Candidates - RED');

drawnow;
pause(3);


%% STEP 12: INTERACTIVE REFLECTION MASK EDITING

reflectionMask = editReflectionMask(I, reflectionMask);


%% STEP 13: FINAL MASK VERIFICATION

while true

    fprintf('\nFINAL MASK VERIFICATION\n');
    fprintf('Total selected pixels: %d\n', nnz(reflectionMask));

    showReflectionOverlay(I, reflectionMask, ...
        'Final Reflection Mask Verification', ...
        'Final Selected Reflection Regions - RED');

    drawnow;

    choice = questdlg( ...
        'Do you want to remove the selected reflection regions?', ...
        'Remove Reflection', ...
        'Yes - Remove Reflection', ...
        'No - Edit Again', ...
        'Cancel', ...
        'Yes - Remove Reflection');

    if isempty(choice) || strcmp(choice, 'Cancel')

        disp('Reflection removal cancelled.');
        return;

    elseif strcmp(choice, 'Yes - Remove Reflection')

        break;

    else

        reflectionMask = editReflectionMask(I, reflectionMask);

    end

end


%% STEP 14: CHECK FINAL MASK

if ~any(reflectionMask(:))

    errordlg('No reflection region selected. Processing stopped.');
    return;

end





%% STEP 15: NATURAL REFLECTION REMOVAL AND SMOOTH RECONSTRUCTION

% Expand the mask slightly to include reflection edges and halos
fillMask = imdilate(logical(reflectionMask), strel('disk', 12));

% Convert original image to double precision
originalImage = im2double(I);

% Prepare reconstructed image
filledImage = originalImage;

% Reconstruct selected regions channel-by-channel
for channel = 1:size(I,3)

    currentChannel = originalImage(:,:,channel);

    filledImage(:,:,channel) = regionfill( ...
        currentChannel, fillMask);

end

% Calculate distance from the reconstructed region
distanceMap = bwdist(fillMask);

% Define the width of the smooth blending boundary
featherWidth = 20;

% Create a gradual blending transition outside the mask
t = min(distanceMap / featherWidth, 1);

% Smoothstep function for a gradual transition
smoothTransition = 3*t.^2 - 2*t.^3;

% Full reconstruction inside the mask, gradual transition outside
alpha = ones(size(fillMask));

alpha(~fillMask) = 1 - smoothTransition(~fillMask);

% Blend reconstructed pixels with the original image
I_result = originalImage;

for channel = 1:size(I,3)

    I_result(:,:,channel) = ...
        alpha .* filledImage(:,:,channel) + ...
        (1-alpha) .* originalImage(:,:,channel);

end

% Keep output pixel values within the valid range
I_result = min(max(I_result,0),1);




%% STEP 16: DISPLAY IMAGE AFTER REFLECTION RECONSTRUCTION

figure('Name', 'Reflection Region Removal and Inpainting', ...
       'NumberTitle', 'off', ...
       'Position', [100 100 1400 600]);

subplot(1,3,1);
imshow(I);
title('Original Image');

subplot(1,3,2);
imshow(reflectionMask);
title('Selected Reflection Region');

subplot(1,3,3);
imshow(I_result);
title('Image After Inpainting / Reconstruction');

sgtitle('Reflection Removal & Background Reconstruction');

disp('Selected reflection region successfully processed.');


%% LOCAL FUNCTION 1: DISPLAY REFLECTION OVERLAY

function showReflectionOverlay(I, mask, figureName, plotTitle)

    figure('Name', figureName, 'NumberTitle', 'off');

    imshow(I);
    hold on;

    redOverlay = cat(3, ...
        ones(size(mask)), ...
        zeros(size(mask)), ...
        zeros(size(mask)));

    overlayHandle = imshow(redOverlay);

    set(overlayHandle, 'AlphaData', 0.40 * double(mask));

    title(plotTitle);
    hold off;

end



%% LOCAL FUNCTION 2: INTERACTIVE MASK EDITOR

function updatedMask = editReflectionMask(I, initialMask)

    updatedMask = logical(initialMask);

    fig = figure( ...
        'Name', 'Reflection Mask Editor', ...
        'NumberTitle', 'off', ...
        'WindowState', 'maximized');

    ax = axes('Parent', fig);

    % Display original image and retain its handle
    hImage = imshow(I, 'Parent', ax);
    hold(ax, 'on');

    % Create red mask overlay
    redOverlay = cat(3, ...
        ones(size(updatedMask)), ...
        zeros(size(updatedMask)), ...
        zeros(size(updatedMask)));

    overlayHandle = imshow(redOverlay, 'Parent', ax);

    set(overlayHandle, 'AlphaData', ...
        0.40 * double(updatedMask));

    title(ax, 'REFLECTION MASK EDITOR');

    drawnow;

    operations = {'Add Area', 'Remove Area', 'Reset All', 'Done'};

    % Continue until Done is selected
    while isgraphics(fig)

        [selection, ok] = listdlg( ...
            'PromptString', 'Choose the next operation:', ...
            'SelectionMode', 'single', ...
            'ListString', operations, ...
            'Name', 'Reflection Mask Editing', ...
            'ListSize', [220 140]);

        if ~ok || selection == 4
            break;
        end

        choice = operations{selection};


        %% RESET ALL SELECTED REGIONS

        if strcmp(choice, 'Reset All')

            resetChoice = questdlg( ...
                'Clear all automatic and manually selected regions?', ...
                'Reset Mask', ...
                'Yes - Reset', ...
                'No - Keep Mask', ...
                'No - Keep Mask');

            if strcmp(resetChoice, 'Yes - Reset')

                updatedMask = false(size(initialMask));

                set(overlayHandle, 'AlphaData', ...
                    0.40 * double(updatedMask));

                title(ax, 'ALL REGIONS CLEARED');

                drawnow;

            end

            continue;

        end


        %% ADD OR REMOVE MODE

        if strcmp(choice, 'Add Area')

            title(ax, { ...
                'ADD MODE: Draw around the missed reflection', ...
                'Double-click to finish the freehand selection'});

            roiColor = 'yellow';

        else

            title(ax, { ...
                'REMOVE MODE: Draw around the unwanted detection', ...
                'Double-click to finish the freehand selection'});

            roiColor = 'cyan';

        end

        drawnow;


        %% DRAW FREEHAND REGION

        try

            roi = drawfreehand(ax, ...
                'Color', roiColor, ...
                'FaceAlpha', 0.05);

            if isempty(roi) || ~isvalid(roi)
                continue;
            end

            % Generate mask using the original image as reference
            correctionMask = createMask(roi, hImage);

            % Remove temporary drawing from the figure
            delete(roi);

        catch ME

            warning('ROI selection failed: %s', ME.message);

            title(ax, 'Selection failed. Please try again.');

            drawnow;
            continue;

        end


        %% CHECK SELECTED PIXELS

        correctionMask = logical(correctionMask);

        if ~isequal(size(correctionMask), size(updatedMask))

            errordlg('Selection mask dimensions do not match the image.');

            continue;

        end

        selectedPixels = nnz(correctionMask);

        if selectedPixels == 0

            warndlg('No pixels were selected. Please draw again.');

            continue;

        end


        %% UPDATE REFLECTION MASK

        if strcmp(choice, 'Add Area')

            % Include newly selected reflection pixels
            updatedMask = updatedMask | correctionMask;

            fprintf('Manually added pixels: %d\n', selectedPixels);

        else

            % Remove selected pixels from the existing mask
            removedPixels = nnz(updatedMask & correctionMask);

            updatedMask = updatedMask & ~correctionMask;

            fprintf('Pixels removed from mask: %d\n', removedPixels);

        end


        %% UPDATE RED OVERLAY

        set(overlayHandle, 'AlphaData', ...
            0.40 * double(updatedMask));

        title(ax, { ...
            'MASK UPDATED SUCCESSFULLY', ...
            sprintf('Currently selected pixels: %d', nnz(updatedMask)), ...
            'Choose the next operation'});

        drawnow;

        fprintf('Total pixels currently selected: %d\n', ...
            nnz(updatedMask));

    end


    %% CLOSE EDITOR

    if isgraphics(fig)
        close(fig);
    end

end

