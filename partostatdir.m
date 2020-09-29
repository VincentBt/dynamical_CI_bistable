function [ws,ron,roff,a] = partostatdir(rd,param)

% Parameters (all corresponding to "rates") are not allowed to become negative


ws = param(1,:) * 10;
alpha = param(2,:) * 0.2; % Bias (prior)

ron = rd .* alpha;
roff = rd .* (1-alpha);

a = param(3,:) .* rd; % positive loops