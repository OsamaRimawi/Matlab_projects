clear

[voice,fs] = audioread("male/0.wav"); %read voice and frequency 

Freq20ms = fs/50;
Freq30ms = 3*fs/100;

%Approch 1
window = voice(1:2*Freq30ms); %take sample from the voice 
Fpitch = pitch(window,fs);  %matlab function to find the pitch frequency 
Fpitch =round(Fpitch);

Fthreshold = 160; 
if (Fpitch < Fthreshold)
    disp('this is a male voice') 
else
    disp('this is a female or a child voice')
end

%Approch 2
R = xcorr(voice, Freq20ms,'coeff'); % autocorrelation on the voice for (20ms) 
t = (-Freq20ms:Freq20ms)/fs;
plot(t, R);

R = R((Freq20ms +50): Freq30ms);  
[Rmax, Tpitch] = max(R);  % find the first peak on the right side of the function 
Fp = fs/(50+Tpitch-1);  % find the pitch frequency 

Fthreshold = 160;
if (Fp < Fthreshold)
    disp('this is a male voice')
else
    disp('this is a female or a child voice')
end
