 %Engineer: Amey Kulkarni
 %Module Name:  input_data_file
 %Project Name: Spectral Doppler Ultrasound Imaging System

clear all
close all
clc
format compact

% Open the file to which the data will be written.
input_data_file = fopen('input_data.txt', 'w');

% Select a patient.
patient = 1;

% Load the data for that patient.
load patient_data_ADC
rx_signal = (rx_signals_I(patient,:) + 1i*rx_signals_Q(patient,:));

% Break out the real and imaginary parts of the signal.
rx_re = rx_signals_I(patient,:);
rx_im = rx_signals_Q(patient,:);

% Write the data to the file.
for k = 1:896*10
    
    if rx_re(k) < 0
        hex_re = 2^16 + rx_re(k);
    else
        hex_re = rx_re(k);
    end
    
    if rx_im(k) < 0
        hex_im = 2^16 + rx_im(k);
    else
        hex_im = rx_im(k);
    end
   
    fprintf(input_data_file, '%04x%04x\n', hex_re, hex_im);
    
end
