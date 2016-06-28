%Copyright 1026 by Rafael Lourenco de Lima Chehab

function P = landmarks(I, fname)
    
    function d = search_int(I)
        [a, b, ~] = size(I);
        x_min = b;
        y_min = a;
        x_max = 0;
        y_max = 0;
        
        for k = 1:a
            for l = 1:b
                if I(k, l, 1) ~= 0 || I(k, l, 2) ~= 0 || I(k, l, 3) ~= 0
                    if k < y_min
                        y_min = k;
                    end
                    if k > y_max
                        y_max = k;
                    end
                    if l < x_min
                        x_min = l;
                    end
                    if l > x_max
                        x_max = l;
                    end
                end
            end
        end
        d = [x_min, y_min, x_max, y_max];
    end
    
    detector = vision.CascadeObjectDetector;
    box = step(detector, I)
    
    [n, m] = size(box);
    
    if n == 0
       bbox = search_int(I)
    else
        bbox = [box(1, 1), box(1, 2), box(1, 1) + box(1, 3), box(1, 2) + box(1, 4)];
    end
    
    fid = fopen(fname, 'w');
    
    fprintf(fid, '%d,%d,%d,%d\n', bbox(1, 1), bbox(1, 2), bbox(1, 3), bbox(1, 4));
    
    addpath('../flandmark/matlab_toolbox/mex/');
    model = flandmark_load_model('../flandmark/data/flandmark_model.dat');
 
    Ibw = rgb2gray(I);
    bbox = dlmread([fname]);
    
    % image output
    figure;
    imshow(I, [], 'Border', 'tight'); hold on;
    % plotbox(bbox);

    for i = 1 : size(bbox, 1)
        P = flandmark_detector(Ibw, int32(bbox(i, :)),  model);

        % show landmarks 
        comps = ['S0'; 'S1'; 'S2'; 'S3'; 'S4'; 'S5'; 'S6'; 'S7'];
        plot(P(1, 1), P(2, 1), 'bs', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
        text(P(1, 1)+1, P(2, 1)+1, comps(1,:), 'color', 'b', 'FontSize', 12);
        plot(P(1, 2:end), P(2, 2:end), 'rs', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'r');
        text(P(1, 2:end)+1, P(2, 2:end)+1, comps(2:end,:), 'color', 'r', 'FontSize', 12);
        
        pause;
    end;
    hold off
end