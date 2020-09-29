function E = objfun(prperson,prpersoff,Ton,T,rd,param,Nmod)

% This function computes the model prediction error as a function of the
% model parameters (param)

%Recover the stats from the param

[ws,ron,roff,a] = partostatdir(rd,param');

%Generate model predictions: 

k=1;
for Toff = T(1:length(T))
    [prpersonm(k), prpersoffm(k)] = runm(ws,ron,roff,a,Ton,Toff,Nmod);
     k=k+1;
end

% Compute error with between data and predictions 

E = sum((prpersonm-prperson).^2) +  sum((prpersoffm-prpersoff).^2);

