function [peak_times] = return_peaks(y, fs_ds)

    % normalize
    y = y / max(abs(y)); % Normalize to maximum absolute value

    % shannon energy envelope
    shannonEnergy = -(y.^2) .* log(y.^2 + eps); % eps avoids log(0)

    % moving average of shannon energy (with 20 ms window, 10 ms overlap)
    window_size = round(0.02 * fs_ds);   % 20 ms
    overlap = round(0.01 * fs_ds);       % 10 ms
    averagedEnvelope = movmean(shannonEnergy, window_size);

    % peak detection 
    delta = 0.03;
    min_peak_distance = round(0.2 * fs_ds); % 200 ms (to avoid double detection)
    [pks, locs] = findpeaks(averagedEnvelope, ...
    'MinPeakHeight', delta, ...
    'MinPeakDistance', min_peak_distance);

    % time of detected peaks
    peak_times = locs / fs_ds;

end