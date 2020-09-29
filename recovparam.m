function [wse,rone,roffe,ae,val,prperson,prpersoff,prpersonmod_all,prpersoffmod_all] = recovparam(rd, ws, ron, roff, a, Ton, T, Nexp, Nmod, Nit) 

% This function generates estimate statistics wse, rone, roffe, ae from fake data
% generated using ws, ron, roff, a. 
% val gives the prediction error after optimization.  

% Generate fake data:

k=1;

for Toff = T(1:length(T))
    [prperson(k),prpersoff(k)] = runm(ws,ron,roff,a,Ton,Toff,Nexp);
    k=k+1;
end

% Run optimization for Nit random initial states

% This limits the model to a "reasonable" parameter range. 
% lb = [3, 0.8, 0];
% ub = [7, 4.2, 6];
lb = [2, 0.8, 0]; %covers the possible range (and even more for p2 and p3)
ub = [10, 5, 6]; %covers the possible range (and even more for p2 and p3)


[param_recovered, rd_recovered] = stattopardir(ws,ron,roff,a);
param_recovered

for i=1:Nit 
   %We select random initial statistics
   x0 = lb + rand(1,3).*(ub-lb);
   %[param_recovered, rd_recovered] = stattopardir(ws,ron,roff,a);
   %param_recovered
   %rd_recovered;
   %x0
   
   %We run patternsearch with the initial statistics and the parameter range as argument 
   [param(:,i), fval(i)] = patternsearch(@(x) objfun(prperson,prpersoff,Ton,T,rd,x,Nmod),x0,[],[],[],[],lb,ub)  
%    disp("---> param(:,i)");
%    disp(param(:,i));
end
param

% Finds the optimal run

[u,v] = min(fval);
paramopt = param(:,v);
paramopt %estimated parameters
param_recovered %true parameters

% Extract the optimal statistics from the optimal parameters
[wse,rone,roffe,ae] = partostatdir(rd,paramopt);
val = fval(v);

k=1;

% Plot the model prediction versus the data, 20 times to get an estimate of
% the error bars   %%% We do that instead in produce_plots.m

% plot(prperson,'r') %Fake data = full lines
% hold on
% plot(prpersoff,'b') %Fake data = full lines

n_sim = 20;
prpersonmod_all = zeros(n_sim,length(T));
prpersoffmod_all = zeros(n_sim,length(T));
for it=1:n_sim
    k=1;
    for Toff = T(1:length(T))
        [prpersonmod(k),prpersoffmod(k)] = runm(ws,rone,roffe,ae,Ton,Toff,Nexp);
        k=k+1;
    end
    prpersonmod_all(it,:) = prpersonmod;
    prpersoffmod_all(it,:) = prpersoffmod;
    
%     plot(prpersonmod,'r:') %model prediction = dotted lines (based on data generated using the fitted parameters)
%     plot(prpersoffmod,'b:') %model prediction = dotted lines (based on data generated using the fitted parameters)
end

% hold off  

  