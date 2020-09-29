function [param, rd] = stattopardir(ws,ron,roff,a)

param = zeros(3,1);

alpha = ron / (ron + roff);
param(1) = ws / 10;
param(2) = alpha / 0.2; 
rd = ron + roff;
param(3) = a / rd; 