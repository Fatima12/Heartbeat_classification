function T_freq_features = extract_freq_dom_features(y_all, assigned_states_all, fs_ds)

% define frequency bands (Hz)
freq_bands = [25 45; 45 65; 65 85; 85 105; 105 125; 125 150; 150 200; 200 300; 300 400];
n_bands = size(freq_bands,1);

NFFT = 256;
window_func = @(x) x .* hamming(length(x));
f = (0:NFFT/2-1)/(NFFT/2) * (fs_ds / 2);

state_names = {'S1', 'Systole', 'S2', 'Diastole'};
freq_names = {};
for i = 1:4
    for b = 1:n_bands
        freq_names{end+1} = sprintf('%s_band_%d', state_names{i}, b);
    end
end

nFiles = length(y_all);
all_features = nan(nFiles, length(freq_names));

for i = 1:nFiles
    fprintf("Processing file %d/%d\n", i, nFiles);
    y = y_all{i};
    assigned_states = assigned_states_all{i};

    freq_features = nan(1, 4 * n_bands);

    for state = 1:4
        state_mask = (assigned_states == state);
        segments = bwconncomp(state_mask);

        median_band_matrix = [];

        for seg = 1:segments.NumObjects
            idx = segments.PixelIdxList{seg};
            if length(idx) < 20
                continue
            end

            seg_signal = window_func(y(idx));

            % FFT-based band powers
            fft_result = abs(fft(seg_signal, NFFT));
            fft_result = fft_result(1:NFFT/2);
            band_medians = zeros(1, n_bands);
            for b = 1:n_bands
                band_mask = (f >= freq_bands(b,1)) & (f < freq_bands(b,2));
                band_medians(b) = median(fft_result(band_mask));
            end
            median_band_matrix = [median_band_matrix; band_medians];
        end

        if ~isempty(median_band_matrix)
            freq_features(1, (state-1)*n_bands+1 : state*n_bands) = mean(median_band_matrix, 1);
        end
    end

    all_features(i,:) = freq_features;
end

T_freq_features = array2table(all_features, 'VariableNames', freq_names);
end


%%

