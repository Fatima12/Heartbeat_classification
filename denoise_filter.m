function [y_filtered] = denoise_filter(y, fs, low_cutoff, high_cutoff)

    
    Wn = [low_cutoff high_cutoff] / (fs/2);

    % Design bandpass filter
    [b, a] = butter(4, Wn, 'bandpass');
    
    % Apply zero-phase filtering
    y_filtered = filtfilt(b, a, y);

end