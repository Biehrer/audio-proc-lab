function [recording] = record_microphone(duration_sec, sample_freq, bits_per_sample)
% Records a audio file over the microphone
%   Detailed explanation goes here
recObj = audiorecorder(sample_freq, bits_per_sample, 1);
recordblocking(recObj, duration_sec);
recording = getaudiodata(recObj);
end

