clear all
close all

%LOAD THE DATA
load('data_simulation.mat','param_true','param_estim','prperson_true','prpersoff_true','prperson_estim','prpersoff_estim') %"prpers" = proba of persistence = survival proba

shape = size(prperson_estim);
N = shape(3);


%FIGURES
% n_show = 20; %if the simulation was stopped before its end (then n_show<N)
n_show = N; %the simulation completed until the end
shape_plot = [4 2]; %the product should be = N

% Plot the model prediction versus the data, 20 times to get an estimate of the error bars: 
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

%Show a (and a-r) predicted vs true
figure(2)
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