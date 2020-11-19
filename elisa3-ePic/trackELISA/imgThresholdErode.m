function [BW,BWD]=imgThresholdErode(I,thr,raw)

J   = rgb2gray(I);
BW  = im2bw(J,thr);
SE  = strel('disk',raw);
BWD = imerode(BW,SE);

