%Copyright 1026 by Rafael Lourenco de Lima Chehab

function R = landmarks(I)
    
    close all;
    
    figure; imshow(I);
    
    I = rgb2gray(I);
    figure; imshow(I);
    graythresh(I)
    
    I = I > uint8(255 * graythresh(I));
    figure; imshow(I, []);
    Ih = imdilate(I, [1 1 1; 1 1 1; 1 1 1]) - I;
    figure; imshow(Ih);
    figure; imshow(watershed(Ih));
    R = Ih;
end