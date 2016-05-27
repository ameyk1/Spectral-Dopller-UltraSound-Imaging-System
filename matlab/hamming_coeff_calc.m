 %Engineer: Amey Kulkarni
 %Module Name:  hamming_coeff_calc
 %Project Name: Spectral Doppler Ultrasound Imaging System


clear all
close all
clc
format compact

coeffs = hamming(128);

coeffs = coeffs .* 2^16;

coeffs = round(coeffs);

for n=0:127
    fprintf('         7''d%0d: coeff = %0x;\n', n, coeffs(n+1));
end
