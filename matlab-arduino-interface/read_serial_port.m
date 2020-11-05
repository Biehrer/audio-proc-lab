serialObject = serial('COM4');

fopen(serialObject);

baud = 57500;
input_buff_size_bytes = 8096;
sig_duration_sec = 0.5;
sample_frequency_hz = 5000;

num_samples = sig_duration_sec*sample_frequency_hz;
samples = zeros(1, num_samples);

set(serialObject, 'BaudRate', baud, ...
    'InputBufferSize', input_buff_size_bytes);

% vector to plot time series
timestamps = (1:1:sig_duration_sec) / sample_frequency_hz;

current_y_min_value = 0;
current_y_max_value = 0;

while(true)
   
    num_bytes = serialObject.BytesAvailable;
    
    if ( num_bytes >= input_buff_size_bytes)
        
        soundValues = fread(serialObject, num_bytes, 'double');    
        % y(x) = m * x + b; 
        % y = (y2-y1)/(x2-x1) * x + b
        % normalerweise: 5V/(AuflösungADC=8bit) * soundValues
        % (5V / 1023) .* soundValues

        % shift vector to make space for the new data
        num_new_samples = length(soundValues);
        for sample_idx=1:num_new_samples
            samples = shift_vector(samples, 0);
        end
        
        % store new samples at the beginning of the sample vector
        samples(1:num_new_samples)= (5.0-3.3) / (1023-0) .* soundValues;
        
        % plot
        plot(timestamps, samples);        
        title('some title');
        % scale axes to current min/max vals in signal
        % if the new values require a rescale
        max_val_new_samples = max(samples(1:num_new_samples));
        if max_val_new_samples > current_y_max_value
           current_y_max_value = max(samples); 
        end
        
        min_val_new_samples = min(samples(1:num_new_samples));
        if min_val_new_samples  < current_y_min_value
            current_y_min_value = min_val_new_samples;
        end
        
        ylim(current_y_min_value, current_y_max_value);
        xlim(timestamps(1), timestamps(num_samples));
        drawnow;
        pause(1)
    end
end

% This is never called because of the infinite while loop
fclose(serialObject);

% Code for saving the serial port:(what a shit show)
% a=instrfind; delete(a);
