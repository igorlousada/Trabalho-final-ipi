function [Op, mak, cen, xa, yb] = seam_search(I, filename, opt)
    
    function [c, n] = elipse(x, y, x0, y0, a, b, r)
        
        c = (x - x0).^2 / a.^2 + (y - y0).^2 / b.^2 <= r.^2;
        n = sum(c(:));
    end
    
    function [c, n] = square(x, y, x0, y0, a, b)
        
        c = (abs(x - x0) <= a) & (abs(y - y0) <= b);
        n = sum(c(:));
    end
    
    
    function [mask, num, mi_ta, cen, minix, miniy] = region(I, filename, op)
        [n, m, ~] = size(I);
        mask = zeros([n, m, 1]);
        
        P = landmarks(I, filename)
        [~, j] = size(P);
        
        cx = P(1, 1);
        cy = P(2, 1);
        
        cen = [cy, cx]
        
        minix = 0;
        miniy = 0;
        
        for i = 2:j
            if ((P(1, i) - cx)^2 >= minix^2)
                minix = abs(P(1, i) - cx);
            end
            if ((P(2, i) - cy)^2 >= miniy^2)
                miniy = abs(P(2, i) - cy);
            end
        end
        for i = 1:m
            x(1:n, i) = i;
        end
        for i = 1:n
            y(i, 1:m) = i;
        end
        
        if op == 1
        
        [mask, num] = square(y, x, cy, cx, 1.4 * miniy, 1.4 * minix);
        figure; imshow(mask);
        [temp, ntemp] = square(y, x, cy, cx, 1.2 * miniy, 1.2 * minix);
        figure; imshow(temp);
        mask = (mask | temp) & ~(mask & temp);
        num = num - ntemp;
        mask2(:,:,1) = mask;
        mask2(:,:,2) = mask;
        mask2(:,:,3) = mask;
        mi_ta = 2 * 1.2 * minix + 2 * 1.2 * miniy;
        figure; imshow(uint8(mask2) .* I);
        
        else
        [miniy, minix]
        
        [mask, num] = elipse(y, x, cy, cx, miniy, minix, 1.5);
        figure; imshow(mask);
        [temp, ntemp] = elipse(y, x, cy, cx, miniy, minix, 1.3);
        figure; imshow(temp);
        
        mask = (mask | temp) & ~(mask & temp);
        num = num - ntemp;
        
        figure; imshow(mask);
        mask2(:,:,1) = mask;
        mask2(:,:,2) = mask;
        mask2(:,:,3) = mask;
        mi_ta = minix * miniy * pi;
        figure; imshow(uint8(mask2) .* I);
        end
    end
    
    %I eh a imagem
    %land sao os landmarks
    
    [mask, num, mintam, cen, xa, yb] = region(I, filename, opt);
    
    for k = 1:round(cen(1))
        if mask(k, round(cen(2))) == 1
            mask(k, round(cen(2))) = 0;
            ini = [k, round(cen(2))];
        end
    end
    
    if mask(ini(1), ini(2) - 1) == 1
        beg = [ini(1), ini(2) - 1];
    else
        beg = [ini(1) - 1, ini(2) - 1];
    end
    if mask(ini(1), ini(2) + 1) == 1
        endi = [ini(1), ini(2) + 1];
    else
        endi = [ini(1) - 1, ini(2) + 1];
    end
    
    figure; imshow(mask);
    
    beg = int16(beg);
    endi = int16(endi);
    
    mask(beg(1), beg(2))
    mask(endi(1), endi(2))
    
    route =  djikstra(beg, endi, rgb2gray(I), mask);
    
    route(ini(1), ini(2)) = 1;
    figure; imshow(route, []);
    
    mask = route;
    
    mak = mask;
    
    mak = imfill(mak, 'holes');
    
    figure; imshow(mak);
    
    Op(:,:,1) = uint8(mak) .* I(:,:,1);
    Op(:,:,2) = uint8(mak) .* I(:,:,2);
    Op(:,:,3) = uint8(mak) .* I(:,:,3);
    
    figure; imshow(Op);
    
    cen = round(cen);
    
end
