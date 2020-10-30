clear;
close all;
% load example audio 
load handel.mat
filename = 'handel.wav';
audiowrite(filename,y,Fs);
clear y Fs;

% now use audioread to read the file we wrote to disk previously
[samples, sample_freq_hz] = audioread(filename, "double");

% instead, for testing, use a recording of my voice
% sample_freq_hz = 44100;
% duration_sec = 5;
% bits_per_sample = 8;
% % record sound of voice
% samples = record_microphone(duration_sec, sample_freq_hz, bits_per_sample);                
% % play sound back to verify corectness
% voice_rec = audioplayer(samples, sample_freq_hz);
% play(voice_rec);

t_dist_sec = 1/sample_freq_hz;
num_of_samples = length(samples);
timestamps = (0:1:num_of_samples-1) * t_dist_sec;
% Plot time series
figure(1);
subplot(2,1,1);
plot(timestamps, samples);
title('audio time series');
% FFT
% Because of the matlab specific fft implementation, we have to divide through
% 'num_of_samples'
% Power spec
SAMPLES=abs(fft(samples)/ num_of_samples);
%Power spec percentage
pow_spec_percentage=SAMPLES/max(SAMPLES);
pow_spec_db = 10 * log10(pow_spec_percentage);

if mod(num_of_samples, 2) == 0
   n_max = (num_of_samples-2) / 2;
else
   n_max = (num_of_samples-1) / 2;
end

f0 = sample_freq_hz / num_of_samples;

% plot fft
frequencies = (1:1:n_max) * f0;
subplot(2,1,2);
% start plotting at index 2, because the first value is mittelwert
fft_plot_part = SAMPLES(2:length(frequencies)+1);
plot(frequencies, fft_plot_part);
title('FFT');
% only plot data range which is interesting to detect vocal properties
 xlim([ 0 1000]);
 
 % Possibility 1: Bandpass signal to the male frequency range (1time)and female frequency
 % range(1time), so only these important frequencies are inside the resulting signal...Then compare
 % both bandpassed signals and dependent on some threshold, decide if its a
 % male or female
 
 % Possibility 2:
 % Offset method: Check highest / lowest frequency parts and dependent on
 % this, decide if its male or female => high amount of false
 % positives..Just a probabilistic 

%f0 = fs/2;
%2*f0 = fs;
%f0 = maximale frequenz des signals