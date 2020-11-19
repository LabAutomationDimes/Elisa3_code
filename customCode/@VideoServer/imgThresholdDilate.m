function [BW,BWD]=imgThresholdDilate(I,thr,raw)

J   = rgb2gray(I);
BW  = im2bw(J,thr);
SE  = strel('disk',raw);
BWD = imdilate(BW,SE);

