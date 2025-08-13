function y_ds = downsample_safe(y, fs, n_downsample)

    % define new sampling rate
    fs_ds = fs / n_downsample;
    nyquist_ds = fs_ds / 2;

    % design anti-aliasing filter
    cutoff = nyquist_ds * 0.9;  % Leave margin below Nyquist
    Wn = cutoff / (fs / 2);     % Normalize cutoff to original Nyquist
    [b, a] = butter(4, Wn, 'low');  % 4th order Butterworth lowpass

    % apply zero-phase filtering to avoid distortion
    y_filtered = filtfilt(b, a, y);

    % downsample
    y_ds = downsample(y_filtered, n_downsample);
end
