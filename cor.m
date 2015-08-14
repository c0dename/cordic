clear all;
clc;

n = 1000; % length of I and Q
i = zeros(1,n);
q = zeros(1,n);

arctan = [45, 26.56, 14.03, 7.12, 3.57, 1.78, 0.89, 0.44];

step = 7; %input('Enter step between 0 to 7: '); 
delta = arctan(step+1); % angular seperation between 2 pts

an = 0.625; %starting gain value
x = an;
y = 0;
z = 0;

theta = 0; % 0 on reset
z = theta;

for j = 1:n
    if (z > 90) && (z < 180)
        z = z - 90;
        x = 0;
        y = an;
    elseif (z >= 180) && (z < 270)
        z = z - 180;
        x = -an;
    elseif z >= 270
        z = z - 360;
    end;
    for k = 0:6 % number of iterations
        if z >= 0
            d = 1;
        else
            d = -1;
        end;
        xn = x - y*d*2.^(-1*k);
        yn = y + x*d*2.^(-1*k);
        zn = z - d*arctan(k+1);
        x = xn;
        y = yn;
        z = zn;
    end;
    i(j) = xn; % saving to vector - inphase
    q(j) = yn; % saving to vector - quadrature
    x = an; %starting gain value
    y = 0;
    theta = theta + delta;
    if theta > 360
        theta = theta -360;
    end;
    z = theta;
end;

out_i = fi(i, 1, 8); % 8 bit quadrature output test vector 
out_q = fi(q, 1, 8); % 8 bit inphase output test vector 

subplot(2,1,1); stem(i);
subplot(2,1,2); plot(q);

%---------FFT calculation---------------
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(i,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
