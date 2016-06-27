function Op = seam_search(I, filename)
    
    function [c, n] = elipse(x, y, x0, y0, a, b, r)
        
        c = (x - x0).^2 / a.^2 + (y - y0).^2 / b.^2 <= r.^2;
        n = sum(c(:));
    end
    
    function [c, n] = square(x, y, x0, y0, a, b)
        
        c = (abs(x - x0) <= a) & (abs(y - y0) <= b);
        n = sum(c(:));
    end
    
    
    function [mask, num, mi_ta] = region(I, filename)
        [n, m, ~] = size(I);
        mask = zeros([n, m, 1]);
        
        P = landmarks(I, filename);
        [~, j] = size(P);
        
        cx = P(2, 1);
        cy = P(1, 1);
        
        minix = 0;
        miniy = 0;
        
        for i = 2:j
            if ((P(2, i) - cx)^2 >= minix^2)
                minix = abs(P(2, i) - cx);
            end
            if ((P(1, i) - cy)^2 >= miniy^2)
                miniy = abs(P(1, i) - cy);
            end
        end
        for i = 1:n
            x(i, 1:m) = i;
        end
        for i = 1:m
            y(1:n, i) = i;
        end
        
        [mask, num] = square(x, y, cx, cy, 1.5 * minix, 1.5 * miniy);
        figure; imshow(mask);
        [temp, ntemp] = square(x, y, cx, cy, 1.2 * minix, 1.2 * miniy);
        figure; imshow(temp);
        mask = (mask | temp) & ~(mask & temp);
        num = num - ntemp;
        mask2(:,:,1) = mask;
        mask2(:,:,2) = mask;
        mask2(:,:,3) = mask;
        mi_ta = 2 * 1.2 * minix + 2 * 1.2 * miniy;
        figure; imshow(uint8(mask2) .* I); %pause;
        
        
        %minix = minix * 1.3;
        %miniy = miniy * 0.9;
        
        %[mask, num] = elipse(x, y, cx, cy, minix, miniy, 1.6);
        %figure; imshow(mask);
        %[temp, ntemp] = elipse(x, y, cx, cy, minix, miniy, 1.0);
        %figure; imshow(temp);
        
        %mask = (mask | temp) & ~(mask & temp);
        %num = num - ntemp;
        
        %figure; imshow(mask);
        %mask2(:,:,1) = mask;
        %mask2(:,:,2) = mask;
        %mask2(:,:,3) = mask;
        %mi_ta = minix * miniy * pi;
        %figure; imshow(uint8(mask2) .* I);
    end
    
    function q = grad(I, x, y, z, w)
        Ia = double(I(x,y,1)) + double(I(x,y,2)) + double(I(x,y,3));
        Ib = double(I(z,w,1)) + double(I(z,w,2)) + double(I(z,w,3));
        %Mudar pra outro espaco de cores
        q = abs(Ib - Ia);
    end
    
    %I eh a imagem
    %land sao os landmarks
    
    [mask, num, mintam] = region(I, filename);
    
    mat = zeros([num, 8]);
    
    [lin, col] = size(mask);
    vis = zeros([lin, col]);
    fim = 1;
    
    vet = size([num, 2]);
    
    v8_x = [-1, -1, -1,  0, 0,  1, 1, 1];
    v8_y = [-1,  0,  1, -1, 1, -1, 0, 1];
    
    for k = 1:lin
        for l = 1:col
            if mask(k, l) == 1
                vet(fim, 1) = k;
                vet(fim, 2) = l;
                vis(k, l) = fim;
                
                for a = 1:8
                    if vis(k + v8_x(a), l + v8_y(a)) ~= 0
                        tem = vis(k + v8_x(a), l + v8_y(a));
                        mat(fim, a) = grad(I, k, l, k + v8_x(a), l + v8_y(a));
                        mat(tem, 8 - a + 1) = mat(fim, a);
                    end
                end
                fim = fim + 1;
            end
        end
    end
    %figure; imshow(mat, []);
    %figure; imshow(double(vis), []);
    
    djikstra(mat, 1, );
    
end