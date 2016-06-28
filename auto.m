function final = auto(face1, face2, opt, grad_type)
    
    close all;

    %% Le imagens
    
    det1 = 'img1.det';
    det2 = 'img2.det';
    
    close all;
    
    function a = bound(b, c)
        a =  1 <= b && b <= c;
    end
    
    I1 = imread(face1);
    I2 = imread(face2);
    
    %% Rotacao
    
    P1 = landmarks(I1, det1);
    P2 = landmarks(I2, det2);
    
    eye1_1 = [(P1(1, 2) + P1(1, 5)) / 2, (P1(2, 2) + P1(2, 5)) / 2];
    eye1_2 = [(P2(1, 2) + P2(1, 5)) / 2, (P2(2, 2) + P2(2, 5)) / 2];
    
    eye2_1 = [(P1(1, 3) + P1(1, 7)) / 2, (P1(2, 3) + P1(2, 7)) / 2];
    eye2_2 = [(P2(1, 3) + P2(1, 7)) / 2, (P2(2, 3) + P2(2, 7)) / 2];
    
    if eye1_2(1) - eye1_1(1) ~= 0
        inc_1 = atan((eye1_2(2) - eye1_1(2)) / (eye1_2(1) - eye1_1(1)))
    else
        inc_1 = 0;
    end
    if eye2_2(1) - eye2_1(1) ~= 0
        inc_2 = atan((eye2_2(2) - eye2_1(2)) / (eye2_2(1) - eye2_1(1)))
    else
        inc_2 = 0;
    end
    
    close all;
    
    rot = 180 * (inc_2 - inc_1) / pi;
    
    I2 = imrotate(I2, rot);
    
    %% Cria mascara
    
    [Op, mak, cen2, x, y] = seam_search(I2, det2, opt, grad_type);
    P1 = landmarks(I1, det1);
    
    %% Resize
    
    cx = P1(1, 1);
    cy = P1(2, 1);
        
    cen1 = [cy, cx];
        
    minix = 0;
    miniy = 0;
    
    [~, t] = size(P1)
    for i = 2:t
        if ((P1(1, i) - cx)^2 >= minix^2)
            minix = abs(P1(1, i) - cx);
        end
        if ((P1(2, i) - cy)^2 >= miniy^2)
            miniy = abs(P1(2, i) - cy);
        end
    end

    [n, m, ~] = size(Op);
    Op = imresize(Op, [n * miniy / y, m * minix / x]);
    mak = imresize(mak, [n * miniy / y, m * minix / x]);
    
    [y, x]
    [miniy, minix]
    [n, m]
    [n * miniy / y, m * minix / x]
    figure; imshow(Op);
    figure; imshow(mak);
    figure; imshow(I1);
    
    P2 = landmarks(Op, det2);
    cen2 = [P2(2, 1), P2(1, 1)];
    
    %% Desloca
    
    cen1 = round(cen1);
    cen2 = round(cen2);
    
    vet = cen1 - cen2;
    
    [n, m, ~] = size(I1);
    [d, e, ~] = size(Op);
    
    figure; imshow(I1);
    for i = 1:d
        for j = 1:e
            if mak(i, j) ~= 0
                I1(i + vet(1), j + vet(2), :) = Op(i, j, :);
            end
            
         end
    end
    figure; imshow(I1);
    
    final = I1;
    
end
