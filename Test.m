%  An example how to use landmarks points
%  The below codes are not optimized. It is straightforward for easy
%  understanding.
%  Copyright 2014 by Caroline Pacheco do E.Silva
%  If you have any problem, please feel free to contact Caroline Pacheco do E.Silva.
%  lolyne.pacheco@gmail.com
%
%  If the algorithm is tested with other databases,  you may need to change
%  some parameters (See the file readme)
%% 

clc
clear all

% read the input image
I = imread('face3.jpg');
I = imresize(I, [224,224]);

[imgFace, LeftEye, RightEye, Mouth, LeftEyebrow,  RightEyebrow] = detectFacialRegions(I);

% config landmarks to Eyes and Mouth (4 and 5)
landconf = 5;

% config of landmarks Eyebrows (only 2)
landconfEyebrow = 2;

%% landmarks the eyes
imgLeftEye = (imgFace(LeftEye(1,2):LeftEye(1,2)+LeftEye(1,4),LeftEye(1,1):LeftEye(1,1)+LeftEye(1,3),:));
[landLeftEye, leftEyeCont] = eyesProcessing(imgLeftEye,landconf);

imgRightEye = (imgFace(RightEye(1,2):RightEye(1,2)+RightEye(1,4),RightEye(1,1):RightEye(1,1)+RightEye(1,3),:));
[landRightEye, rightEyeCont] = eyesProcessing(imgRightEye,landconf);

% landmarks the mouth
imgMouth = (imgFace(Mouth(1,2):Mouth(1,2)+Mouth(1,4),Mouth(1,1):Mouth(1,1)+Mouth(1,3),:));
[landMouth, MouthCont] = mouthProcessing(imgMouth,landconf);

% landmarks the eyebrows
imgLeftEyebrow = (imgFace(LeftEyebrow(1,2):LeftEyebrow(1,2)+LeftEyebrow(1,4),LeftEyebrow(1,1):LeftEyebrow(1,1)+LeftEyebrow(1,3),:));
[landLeftEyebrow, leftEyebrowCont] = eyebrowsProcessing(imgLeftEyebrow,landconfEyebrow);

imgRightEyebrow = (imgFace(RightEyebrow(1,2):RightEyebrow(1,2)+RightEyebrow(1,4),RightEyebrow(1,1):RightEyebrow(1,1)+RightEyebrow(1,3),:));
[landRightEyebrow, RightEyebrowCont] = eyebrowsProcessing(imgRightEyebrow,landconfEyebrow);

%% shows (eyes, mouth and eyebrows)

imshow(imgFace,'InitialMagnification',50); hold on;
showsLandmarks(landLeftEye,leftEyeCont,LeftEye,landconf);
showsLandmarks(landRightEye,rightEyeCont,RightEye,landconf);
showsLandmarks(landMouth,MouthCont,Mouth,landconf);
showsLandmarks(landLeftEyebrow,leftEyebrowCont,LeftEyebrow,landconfEyebrow);
showsLandmarks(landRightEyebrow,RightEyebrowCont,RightEyebrow,landconfEyebrow);