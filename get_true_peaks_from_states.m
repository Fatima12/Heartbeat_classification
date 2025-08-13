function [s1_peaks, s2_peaks] = get_true_peaks_from_states(y, assigned_states, fs)
    s1_peaks = [];
    s2_peaks = [];

    states = assigned_states(:);  % ensure column vector
    curr_state = states(1);
    start_idx = 1;

    for i = 2:length(states)
        if states(i) ~= curr_state || i == length(states)
            end_idx = i - 1;

            % Handle case when last sample belongs to current state
            if i == length(states)
                end_idx = i;
            end

            % Extract region from signal
            region = y(start_idx:end_idx);
            [~, local_peak] = max(abs(region));
            peak_sample = start_idx + local_peak - 1;
            peak_time = peak_sample / fs;

            % Save based on state
            if curr_state == 1
                s1_peaks(end+1) = peak_time;
            elseif curr_state == 3
                s2_peaks(end+1) = peak_time;
            end

            % Update for next segment
            start_idx = i;
            curr_state = states(i);
        end
    end
end
