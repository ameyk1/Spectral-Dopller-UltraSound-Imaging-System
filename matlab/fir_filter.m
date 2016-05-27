 %Engineer: Amey Kulkarni
 %Module Name:  fir_filter
 %Project Name: Spectral Doppler Ultrasound Imaging System

function Hd = fir_filter
%FIR_FILTER Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 09-Dec-2013 21:37:35
%

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in kHz.
Fs = 150;  % Sampling Frequency

Fstop1 = 1;               % First Stopband Frequency
Fpass1 = 1.6;             % First Passband Frequency
Fpass2 = 10;              % Second Passband Frequency
Fstop2 = 11;              % Second Stopband Frequency
Dstop1 = 0.177827941;     % First Stopband Attenuation
Dpass  = 0.17099735734;   % Passband Ripple
Dstop2 = 0.056234132519;  % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]