I = imread('face2.jpg');
RI = imresize(I, [320 320]);
GSRI = rgb2gray(RI);

det = vision.CascadeObjectDetector;
bbox = step(det, RI);

%CI = imcrop(RI, [bbox(1) bbox(2) bbox(3) bbox(4)]);

corners = detectMinEigenFeatures(GSRI, 'ROI', [bbox(1) bbox(2) bbox(3) bbox(4)]);

eyedet = vision.CascadeObjectDetector('lefteye', 'MergeThreshold', 64);
nosedet = vision.CascadeObjectDetector('nose', 'MergeThreshold', 16);
mouthdet = vision.CascadeObjectDetector('mouth', 'MergeThreshold', 64);
bboxeye = step(eyedet, RI);
bboxnose = step(nosedet, RI);
bboxmouth = step(mouthdet, RI);

out = insertObjectAnnotation(RI, 'rectangle', bbox, 'detection');
outeyes = insertObjectAnnotation(RI, 'rectangle', bboxeye, 'eye');
outnose = insertObjectAnnotation(RI, 'rectangle', bboxnose, 'nose');
outmouth = insertObjectAnnotation(RI, 'rectangle', bboxmouth, 'mouth');

figure, imshowpair(outnose, outeyes, 'montage');
figure(2), imshow(outmouth); figure(3), imshow(GSRI); hold on;
plot(corners.selectStrongest(50));
    