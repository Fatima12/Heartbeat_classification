function [peak_times_S1_alldata, peak_times_S2_alldata, assigned_states_alldata, tot_murmur_normal] = S1_S2_normal_murmur(labels, y_denoised, fs_ds, springer_options, ...
                                             B_matrix, pi_vector, total_obs_distribution)

    uniqueLabels = unique(labels);  % Find unique label names
    counts = cellfun(@(x) sum(strcmp(labels, x)), uniqueLabels);  % Count each
    tot_murmur_normal = sum(counts(2:3));
    
    peak_times_S1_alldata = cell(tot_murmur_normal, 1);  
    peak_times_S2_alldata = cell(tot_murmur_normal, 1);
    assigned_states_alldata = cell(tot_murmur_normal, 1);

    for i = 1:tot_murmur_normal
        idx = i
    
        % y = y_denoised{idx};
        y = schmidt_spike_removal(y_denoised{idx}, fs_ds); % remove spikes
        t_axis = (0:length(y)-1) / fs_ds;
    
        %% my S1/S2 detection algorithm
    
        assigned_states = runSpringerSegmentationAlgorithm(y, springer_options.audio_Fs, B_matrix, pi_vector, total_obs_distribution, true);
        [peak_times_S1_alldata{i}, peak_times_S2_alldata{i}] = get_true_peaks_from_states(y, assigned_states, fs_ds);
        assigned_states_alldata{i} = assigned_states;

        %% my old code
        % matrix_S1 = assigned_states == 1;
        % matrix_S2 = assigned_states == 3;
        % S1_state = y .* matrix_S1; 
        % S2_state = y .* matrix_S2; 
        % peak_times_S1_alldata{i} = return_peaks(S1_state, fs_ds);
        % peak_times_S2_alldata{i} = return_peaks(S2_state, fs_ds);
    
        %% plot
        % figure(1);
        % plot(t_axis, y, '-b', 'DisplayName', 'Downsampled+Filtered');
        % hold on;
        % ylims = ylim;
        % xlabel('Time (s)');
        % ylabel('Amplitude');
        % legend show
        % grid on;
        % ylims = ylim;
        % hold on
        % plot(peak_times_S1_alldata{i}, repmat(ylims(2)*0.8, size(peak_times_S1_alldata{i})), 'r*', 'MarkerSize', 10, 'DisplayName', 'S1 Estimated');
        % plot(peak_times_S2_alldata{i}, repmat(ylims(2)*0.6, size(peak_times_S2_alldata{i})), 'g*', 'MarkerSize', 10, 'DisplayName', 'S2 Estimated');
        % hold on;
        % ylims = ylim;
        % legend('Location', 'southeast')
        % filename = sprintf('figure_%d.png', i);
        % % sound(y, fs_ds);
        close all
    
    end
end