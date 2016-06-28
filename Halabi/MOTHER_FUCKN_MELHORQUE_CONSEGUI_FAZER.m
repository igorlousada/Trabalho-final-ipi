I = imread('face4.jpg');
gI = rgb2gray(I);
RI = imresize(gI, [640 640]);
imshow(RI);
[x,y] = ginput(8);

LeftEyeOuterMark = [x(1) y(1)];
LeftEyeInnerMark = [x(2) y(2)];
RightEyeOuterMark = [x(3) y(3)];
RightEyeInnerMark = [x(4) y(4)];
CenterNose = [x(5) y(5)];
CenterHead = [x(6) y(6)];
MouthMark1 = [x(7) y(7)];
MouthMark2 = [x(8) y(8)];

LeftEyeCenter = [(LeftEyeOuterMark(1)+LeftEyeInnerMark(1))/2 (LeftEyeOuterMark(2)+LeftEyeInnerMark(2))/2];
RightEyeCenter = [(RightEyeOuterMark(1)+RightEyeInnerMark(1))/2 (RightEyeOuterMark(2)+RightEyeInnerMark(2))/2];
rot = asin((LeftEyeCenter(2) - RightEyeCenter(2))/(LeftEyeCenter(1) - RightEyeCenter(1)));

eyePairDist = sqrt(((RightEyeOuterMark(1)-LeftEyeOuterMark(1))^2)+((RightEyeOuterMark(2)-LeftEyeOuterMark(2))^2));
eyePairRegion = imcrop(RI, [LeftEyeOuterMark(1) LeftEyeOuterMark(2)-eyePairDist/4 eyePairDist eyePairDist/2]);

eyeMiddle = [(LeftEyeCenter(1)+RightEyeCenter(1))/2 (LeftEyeCenter(2)+RightEyeCenter(2))/2];
mouthMiddle = [(MouthMark1(1)+MouthMark2(1))/2 (MouthMark1(2)+MouthMark2(2))/2];
mouthSize = sqrt(((MouthMark1(1)-MouthMark2(1))^2)+((MouthMark1(2)-MouthMark2(2))^2));
faceSize = mouthMiddle(2)-eyeMiddle(2)+mouthSize;

faceRegion = imcrop(RI, [round(LeftEyeOuterMark(1)+((LeftEyeOuterMark(1)-LeftEyeInnerMark(1))/4)) round(LeftEyeOuterMark(2)-eyePairDist/4) round(eyePairDist-((LeftEyeOuterMark(1)-LeftEyeInnerMark(1))/2)) round(faceSize)]);
bbox = [round(LeftEyeOuterMark(1)+((LeftEyeOuterMark(1)-LeftEyeInnerMark(1))/4)) round(LeftEyeOuterMark(2)-eyePairDist/4) round(eyePairDist-((LeftEyeOuterMark(1)-LeftEyeInnerMark(1))/2)) round(faceSize)];

figure(1),
imshow(faceRegion);

I2 = imread('face7.jpg');
gI2 = rgb2gray(I2);
RI2 = imresize(gI2, [640 640]);
figure(2),
imshow(RI2);
[x,y] = ginput(8);

LeftEyeOuterMark_2 = [x(1) y(1)];
LeftEyeInnerMark_2 = [x(2) y(2)];
RightEyeOuterMark_2 = [x(3) y(3)];
RightEyeInnerMark_2 = [x(4) y(4)];
CenterNose_2 = [x(5) y(5)];
CenterHead_2 = [x(6) y(6)];
MouthMark1_2 = [x(7) y(7)];
MouthMark2_2 = [x(8) y(8)];

LeftEyeCenter_2 = [(LeftEyeOuterMark_2(1)+LeftEyeInnerMark_2(1))/2 (LeftEyeOuterMark_2(2)+LeftEyeInnerMark_2(2))/2];
RightEyeCenter_2 = [(RightEyeOuterMark_2(1)+RightEyeInnerMark_2(1))/2 (RightEyeOuterMark_2(2)+RightEyeInnerMark_2(2))/2];
rot_2 = asin((LeftEyeCenter_2(2) - RightEyeCenter_2(2))/(LeftEyeCenter_2(1) - RightEyeCenter_2(1)));

eyePairDist_2 = sqrt(((RightEyeOuterMark_2(1)-LeftEyeOuterMark_2(1))^2)+((RightEyeOuterMark_2(2)-LeftEyeOuterMark_2(2))^2));
eyePairRegion_2 = imcrop(RI, [LeftEyeOuterMark_2(1) LeftEyeOuterMark_2(2)-eyePairDist_2/4 eyePairDist_2 eyePairDist_2/2]);

eyeMiddle_2 = [(LeftEyeCenter_2(1)+RightEyeCenter_2(1))/2 (LeftEyeCenter_2(2)+RightEyeCenter_2(2))/2];
mouthMiddle_2 = [(MouthMark1_2(1)+MouthMark2_2(1))/2 (MouthMark1_2(2)+MouthMark2_2(2))/2];
mouthSize_2 = sqrt(((MouthMark1_2(1)-MouthMark2_2(1))^2)+((MouthMark1_2(2)-MouthMark2_2(2))^2));
faceSize_2 = mouthMiddle_2(2)-eyeMiddle_2(2)+mouthSize_2;

faceRegion_2 = imcrop(RI2, [round(LeftEyeOuterMark_2(1)+((LeftEyeOuterMark_2(1)-LeftEyeInnerMark_2(1))/4)) round(LeftEyeOuterMark_2(2)-eyePairDist_2/4) round(eyePairDist_2-((LeftEyeOuterMark_2(1)-LeftEyeInnerMark_2(1)))) round(faceSize_2)]);
seam = imresize(faceRegion_2, [bbox(4) bbox(3)]);

for i = 1:bbox(4)
    for j = 1:bbox(3)
        RI(i+bbox(2), j+bbox(1)) = seam(i, j);
    end
end

figure(3),
imshow(seam);

figure(4),
imshow(faceRegion_2);

figure(5),
imshow(RI);
