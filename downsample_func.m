function [downsampledData, y_len_orig_sec] = downsample_func(audioData, fs, n_downsample)

    downsampledData = cell(size(audioData));
    y_len_orig_sec = zeros(1, length(audioData));
    
    for i = 1:length(audioData)
        y = audioData{1, i}; 
        y_len_orig_sec(i) = length(y)/fs;
        y_ds = downsample_safe(y, fs, n_downsample);
        downsampledData{i} = y_ds;
    end

end