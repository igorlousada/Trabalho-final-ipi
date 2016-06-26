%Copyright 1026 by Rafael Lourenco de Lima Chehab

function P = landmarks(I, fname)
    
    close all;
    
    detector = vision.CascadeObjectDetector;
    box = step(detector, I);
    
    bbox = [box(1, 1), box(1, 2), box(1, 1) + box(1, 3), box(1, 2) + box(1, 4)];
    
    fid = fopen(fname, 'w');
    
    fprintf(fid, '%d,%d,%d,%d\n', bbox(1, 1), bbox(1, 2), bbox(1, 3), bbox(1, 4));
    
    addpath('../flandmark/matlab_toolbox/mex/');
    model = flandmark_load_model('../flandmark/data/flandmark_model.dat');
 
    Ibw = rgb2gray(I);
    bbox = dlmread([fname]);
    
    % image output
    figure(1);
    imshow(I, [], 'Border', 'tight'); hold on;
    % plotbox(bbox);

    for i = 1 : size(bbox, 1)
        P = flandmark_detector(Ibw, int32(bbox(i, :)),  model);

        % show landmarks 
        comps = ['S0'; 'S1'; 'S2'; 'S3'; 'S4'; 'S5'; 'S6'; 'S7'];
        plot(P(1, 1), P(2, 1), 'bs', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
        %text(P(1, 1)+1, P(2, 1)+1, comps(1,:), 'color', 'b', 'FontSize', 12);
        plot(P(1, 2:end), P(2, 2:end), 'rs', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        %text(P(1, 2:end)+1, P(2, 2:end)+1, comps(2:end,:), 'color', 'r', 'FontSize', 12);
    end;
end