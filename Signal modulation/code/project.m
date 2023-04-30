mu= 0.25;
Ac= 1;
fc= 25;
fm= 1;
t= 0:0.001:2;

m = cos(2*pi*fm*t);     % m(t) message signal
c = cos(2*pi*fc*t);     % c(t) carrier signal
s = Ac*(1+(mu*m)).*c;   % s(t) AM modulated signal
ideal_env = abs(Ac*(1+(mu*m)));     % ideal envelope detector output signal

max_tau =1/fm;           
min_tau = 1/fc;          
tau = min_tau:0.001:max_tau;

tlength =length(t);         %time lentgh
taulength =length(tau);     %tau lentgh

D(1,1) = 0;     %mean squared error between ideal env and ?(?)
for i=1 :taulength   
    y(1,1)=s(1,1);      %envelope detector output signal for tau(i)
    T0(1,1) =1;         %the time value just before the diode turns off
    V0 = s(1,1);        %the value of s(t) just before the diode turns off
    for n=1: tlength-1
        if y(1,n) < s(1,n+1)    %diode is on
            y(1,n+1)= s(1,n+1);
            T0 = n;
            V0 = s(1,n+1);
        else                    %diode is off
            y(1,n+1)= V0*exp( -(t(1,n)- t(1,T0)) /tau(1,i));
        end
    end
    D(1,i)= sum((y - ideal_env).^2) / tlength;
end

[~,optimum_tau] = min(D);   %the optimum value of the tau that minimizes D
fprintf("optimum value of tau = %0.4f \n",tau(1,optimum_tau));

 y(1,1)=s(1,1);     %envelope detector output signal for optimum tau
 T0(1,1) =1;
 V0 = s(1,1);
 for n=1: tlength-1
    if y(1,n) < s(1,n+1)
        y(1,n+1)= s(1,n+1);
        T0 = n;
        V0= s(1,n+1);
    else
        y(1,n+1)=V0*exp(-(t(1,n)- t(1,T0))/tau(1,optimum_tau));
    end
 end

 %Plots
subplot(2,2,1);
plot(t,s)
axis([0 2 -2 2]);
title("s(t) AM modulated signal");
xlabel("t (time in seconds)");
ylabel("s(t)");
grid on;

subplot(2,2,2);
plot(t,ideal_env)
axis([0 2 -2 2]);
title("Ideal envolpe output vs t");
xlabel("t (time in seconds)");
ylabel("ideal env");
grid on;

subplot(2,2,3); 
plot(tau,D)
title("mean squared error between y(t) and Idael envolpe vs tau");
axis([0.04 1 0 0.15]);
xlabel("tau values");
ylabel("D(t)");
grid on;

subplot(2,2,4); 
plot(t,y)
axis([0 2 -2 2]);
title("y(t) that corresponds to the minimum D (optimum tau)");
xlabel("t (time in seconds)");
ylabel("y(t)");
grid on;

