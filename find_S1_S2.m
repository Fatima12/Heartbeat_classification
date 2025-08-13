function [peak_times_S1, peak_times_S2] = find_S1_S2(Normal_timestamps, fileNames, audioData, y_denoised, springer_options, ...
                                    B_matrix, pi_vector, total_obs_distribution, fs, fs_ds)

    uniqueFiles = unique(Normal_timestamps.fname);
    idx_array = zeros(1, length(uniqueFiles));
    peak_times_S1 = cell(length(uniqueFiles), 1);  
    peak_times_S2 = cell(length(uniqueFiles), 1);
    s1_times_GT = cell(length(uniqueFiles), 1);
    s2_times_GT = cell(length(uniqueFiles), 1);


    for i = 1:length(uniqueFiles)
        i
        fname = uniqueFiles{i}; % current file name as string
    
        % Find index in fileNames
        idx = find(strcmp(fileNames, fname));
        idx_array(i) = idx(1);
    
        if isempty(idx)
            warning('File %s not found in fileNames.', fname);
            continue;
        end
    
        % Get audio and timestamps
        y_original = audioData{idx};
        t = (0:length(y_original)-1) / fs;
    
        % Get S1 and S2 time points for this file
        rows = strcmp(Normal_timestamps.fname, fname);
        s1_times_GT{i} = Normal_timestamps.time_s_(rows & strcmp(Normal_timestamps.soundEvent, 'S1'));
        s2_times_GT{i} = Normal_timestamps.time_s_(rows & strcmp(Normal_timestamps.soundEvent, 'S2'));
    
        % Plot (original waveform)
        figure(1);
        %y = y_denoised{idx};
        y = schmidt_spike_removal(y_denoised{idx}, fs_ds); % remove spikes
        t_axis = (0:length(y)-1) / fs_ds;
        plot(t_axis, y, '-b', 'DisplayName', 'Downsampled+Filtered');
        hold on;
        % Plot S1 and S2 markers (from original waveform)
        ylims = ylim;
        plot(s1_times_GT{i}, repmat(ylims(2)*0.8, size(s1_times_GT{i})), 'ro', 'MarkerSize', 10, 'DisplayName', 'S1 GT');
        plot(s2_times_GT{i}, repmat(ylims(2)*0.6, size(s2_times_GT{i})), 'go', 'MarkerSize', 10, 'DisplayName', 'S2 GT');
    
        title(['Heart Sound: ', fname]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        legend show
        grid on;
    
        %% my S1/S2 detection algorithm
    
        assigned_states = runSpringerSegmentationAlgorithm(y, springer_options.audio_Fs, B_matrix, pi_vector, total_obs_distribution, true);
        [peak_times_S1{i}, peak_times_S2{i}] = get_true_peaks_from_states(y, assigned_states, fs_ds);
    
        %% old code based on peak detection
    
        % matrix_S1 = assigned_states == 1;
        % matrix_S2 = assigned_states == 3;
        % S1_state = y .* matrix_S1; 
        % S2_state = y .* matrix_S2; 
        % peak_times_S1{i} = return_peaks(S1_state, fs_ds);
        % peak_times_S2{i} = return_peaks(S2_state, fs_ds);
    
        ylims = ylim;
        hold on
        plot(peak_times_S1{i}, repmat(ylims(2)*0.8, size(peak_times_S1{i})), 'r*', 'MarkerSize', 10, 'DisplayName', 'S1 Estimated');
        plot(peak_times_S2{i}, repmat(ylims(2)*0.6, size(peak_times_S2{i})), 'g*', 'MarkerSize', 10, 'DisplayName', 'S2 Estimated');
        hold on;
        % Plot S1 and S2 markers (from original waveform)
        ylims = ylim;
        plot(s1_times_GT{i}, repmat(ylims(2)*0.8, size(s1_times_GT{i})), 'ro', 'MarkerSize', 10, 'DisplayName', 'S1 GT');
        plot(s2_times_GT{i}, repmat(ylims(2)*0.6, size(s2_times_GT{i})), 'go', 'MarkerSize', 10, 'DisplayName', 'S2 GT');
        legend('Location', 'southeast')
        filename = sprintf('figure_%d.png', i);
        title(['filename: ', fname])
        % saveas(gcf, filename)       % Save as PNG
        % sound(y, fs_ds);
        close all
    
    end
end