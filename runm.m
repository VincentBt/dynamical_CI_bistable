function [prperson, prpersoff] = runm(ws,ron,roff,a,Ton,Toff,Nrepeat)

dt = 0.01; 
Ntime = min((Ton + Toff) * (Nrepeat+1), 1000000);

L=zeros(1,1); 

Mask = mod(1:Ntime,Toff+Ton) < Ton;
n = randn(1,Ntime).*Mask;

k=1;

Resp = zeros(1,Nrepeat);
%L_all = [];

for t=1:Ntime-1               
     L = L + dt* (a * L +ron*exp(-L)-roff*exp(L)+ ron-roff + ws * n(t));
     if isnan(L)
         prpersoff = 0.5;
         prperson =  0.5;
         break
     end
     if ~isnan(L) && (mod(t+1,Toff+Ton) == (Ton-1))
         Resp(k) = sign(L);
         k = k+1;
     end
     %L_all = [L_all L]; %slows down a lot the code
     %disp(L_all);
end
% disp(Resp);
%disp(min(Resp));
%disp(max(Resp));


prpersoff = (1-sum(diff(Resp)>0)/(sum(Resp==-1)+0.0001));
prperson = (1-sum(diff(Resp)<0)/(sum(Resp==1)+0.0001));

%figure();
%plot(L_all(1:10000))




    