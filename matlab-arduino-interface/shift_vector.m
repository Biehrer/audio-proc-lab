function [shifted_samples] = shift_vector(samples, replacement_char)
%SHIFT_VECTOR 
%     shifts all values in the vector one position to the right
%     and does replace the value at the beginning with 'replacement_char'
shifted_samples(1) = replacement_char;
shifted_samples(2:length(samples)) = samples(1:length(samples)-1);
end

