function [T] = extract_features(peak_times_S1_alldata, peak_times_S2_alldata, y_len_orig_sec)

    numFiles = length(peak_times_S1_alldata);
    s1s2_features = [];

    for i = 1:numFiles
        s1_peaks = peak_times_S1_alldata{i};
        s2_peaks = peak_times_S2_alldata{i};
        features = nan(1, 15);

        if ~isempty(s1_peaks) && ~isempty(s2_peaks)
            s1_intervals = diff(s1_peaks);
            s2_intervals = diff(s2_peaks);
            rr_intervals = s1_intervals;
            mean_rr = mean(rr_intervals);

            % clean systole pairing 
            systole = [];
            for k = 1:length(s1_peaks)
                s2_after = s2_peaks(s2_peaks > s1_peaks(k));
                if ~isempty(s2_after)
                    systole(end+1) = s2_after(1) - s1_peaks(k);
                end
            end

            % diastole (from valid S2 to next S1) 
            diastole = [];
            for k = 1:length(s2_peaks)
                s1_after = s1_peaks(s1_peaks > s2_peaks(k));
                if ~isempty(s1_after)
                    diastole(end+1) = s1_after(1) - s2_peaks(k);
                end
            end

            % compute features only if enough data
            if ~isempty(systole) && ~isempty(diastole)
                features = [
                    mean(s1_intervals), std(s1_intervals), ...
                    mean(s2_intervals), std(s2_intervals), ...
                    mean(systole), std(systole), ...
                    mean(diastole), std(diastole), ...
                    mean(systole)/mean_rr, ...
                    mean(diastole)/mean_rr, ...
                    mean(systole)/mean(diastole), ...
                    length(s1_peaks)/y_len_orig_sec(i), ...
                    length(s2_peaks)/y_len_orig_sec(i), ...
                    length(s1_peaks) / (s1_peaks(end) - s1_peaks(1))
                ];
            end
        end

        s1s2_features = [s1s2_features; features];
    end

    feature_names = {
        'mean_s1_interval', 'std_s1_interval', ...
        'mean_s2_interval', 'std_s2_interval', ...
        'mean_systole', 'std_systole', ...
        'mean_diastole', 'std_diastole', ...
        'systole_rr_ratio', ...
        'diastole_rr_ratio', ...
        'systole_diastole_ratio', ...
        's1_rate_per_sec', ...
        's2_rate_per_sec', ...
        's1_rate_local'
    };

    T = array2table(s1s2_features, 'VariableNames', feature_names);
end

