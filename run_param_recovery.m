%Same as run_vincent.m, except we set intelligently the parameters (so that
%SP<0.85 and SP>0.65, in order for the data to be informative enough)

clear
close all

% On stimulus duration
Ton = 10;

% Off stimulus durations
T = [1 10 50 200 500];

%Number of repetition of each off duration during the "experiment"
Nexp=10; %5000; %2000;

%Number of repetition of each off duration during each run of the model
Nmod=10; %2000; %2000;

%Number of random initial settings for patternsearch
Nit=2; %50; %50;



N = 8; %100; %number of data points (= number of times we try to fit parameters)

param_true = zeros(4,N);
param_estim = zeros(4,N); %zeros(5,N);
prperson_true = zeros(length(T),N);
prpersoff_true = zeros(length(T),N);
prperson_estim = zeros(20,length(T),N);
prpersoff_estim = zeros(20,length(T),N);

for i=1:N
    
    i
    SPon = 0; SPoff = 0;
    cpt = 0;
%     while min([SPon(1) SPoff(1)])<0.65 | max([SPon(1) SPoff(1)])>0.85
    while (SPon(1)<0.65 & SPoff(1)<0.65) | max([SPon(1) SPoff(1)])>0.85
        % Set parameters
        rd = 2; %fixed (= ron + roff)
        a_min = 1; a_max = 3;
        a = rd * (a_min + (a_max - a_min)*rand()); %random (in [1;3]*rd)
        alpha_min = 0.5; alpha_max = 0.9;
        alpha = alpha_min + (alpha_max-alpha_min)*rand(); %random (in [0.5; 0.9])
        ron = alpha*rd;
        roff = (1-alpha)*rd;
        ws_min = 20; ws_max = 100;
        ws = ws_min + (ws_max-ws_min)*rand(); %60;
        
        k=1;
        for Toff = T(1:length(T))
            [SPon(k),SPoff(k)] = runm(ws,ron,roff,a,Ton,Toff,Nexp);
            k=k+1;
        end
        cpt = cpt + 1;        
%         disp(SPon);
%         disp(SPoff);
%         disp(min([SPon SPoff])<0.65 | max([SPon SPoff])>0.85)
    end
    cpt
    
%     disp("params")
%     [ws ron roff a]
%     [param_recovered, rd_recovered] = stattopardir(ws,ron,roff,a);
%     param_recovered'
%     ron / (ron + roff)
    
    %recover the parameters
%     [wse,rone,roffe,ae,val] = recovparam(rd, ws, ron, roff, a, Ton, T, Nexp, Nmod, Nit);
    [wse,rone,roffe,ae,val,prperson,prpersoff,prpersonmod_all,prpersoffmod_all] = recovparam(rd, ws, ron, roff, a, Ton, T, Nexp, Nmod, Nit);
    
    %save the results
    param_true(:,i) = [ws,ron,roff,a]';
    param_estim(:,i) = [wse,rone,roffe,ae]'; %[wse,rone,roffe,ae,val]';
    prperson_true(:,i) = prperson;
    prpersoff_true(:,i) = prpersoff;
    prperson_estim(:,:,i) = prpersonmod_all;
    prpersoff_estim(:,:,i) = prpersoffmod_all;
    
end

%SAVE THE DATA
save('data_simulation.mat','param_true','param_estim','prperson_true','prpersoff_true','prperson_estim','prpersoff_estim') %"prpers" = proba of persistence = survival proba


%FIGURES
% n_show = 20; %if the simulation was stopped before its end (then n_show<N)
n_show = N; %the simulation completed until the end
shape_plot = [4 2]; %[10 10];
if not(prod(shape_plot) == N)
    return
end
disp('ok');
figure(1)
for i=1:N
    subplot(shape_plot(1),shape_plot(2),i)
    plot(prperson_true(:,i),'r') %Fake data = full lines
    hold on
    plot(prpersoff_true(:,i),'b') %Fake data = full lines
    
    shape = size(prperson_estim);
    for it=1:shape(1) %20
        plot(prperson_estim(it,:,i),'r:') %model prediction = dotted lines (based on data generated using the fitted parameters)
        plot(prpersoff_estim(it,:,i),'b:') %model prediction = dotted lines (based on data generated using the fitted parameters)
    end
    hold off  
end

figure(2) %Show a (and a-r) predicted vs true
list_params = ["ws", "ron", "roff", "a"];
for i_param=1:4
    subplot(2,2,i_param)
    scatter(param_true(i_param,1:n_show),param_estim(i_param,1:n_show)) %plot
    xlabel(join(['True ' list_params(i_param)]))
    ylabel(join(['Estimated ' list_params(i_param)]))
end

figure(3)
scatter(param_true(4,1:n_show)-param_true(2,1:n_show)-param_true(3,1:n_show),param_estim(4,1:n_show)-param_estim(2,1:n_show)-param_estim(3,1:n_show))
xlabel('True  a - ron - roff')
ylabel('Estimated a - ron - roff')

figure(4)
scatter(param_true(2,1:n_show)./(param_true(2,1:n_show)+param_true(3,1:n_show)),param_estim(2,1:n_show)./(param_estim(2,1:n_show)+param_estim(3,1:n_show)))
xlabel('True  ron / (ron + roff)')
ylabel('Estimated ron / (ron + roff)')