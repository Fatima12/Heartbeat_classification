clear all
clc
close all

%% load all data

basePath = pwd + "/Data"; % Path to the main data folder
categories = {'normal', 'murmur', 'artifact'}; % Categories
[audioData, labels, fileNames, fs, Normal_timestamps] = load_audio_data(basePath, categories);

%% Pre-Processing
%% Signal processing: filter + downsample + denoise

n_downsample = 44; % downsampled to 1k Hz
[downsampledData, y_len_orig_sec] = downsample_func(audioData, fs, n_downsample);

%% Filtering: Denoise by filter 

low_cutoff = 25; 
high_cutoff = 200;
fs_ds = fs / n_downsample;
y_denoised = denoise_by_filtering(downsampledData, fs_ds, low_cutoff, high_cutoff);

%% Load the trained parameter matrices for Springer's HSMM model.
% The parameters were trained using Springer's HSMM model, shared by the
% author

springer_options = default_Springer_HSMM_options;
load('B_matrix.mat');
load('pi_vector.mat');
load('total_obs_distribution.mat');

%% S1 and S2 in normal data for whom GT is available
[peak_times_S1, peak_times_S2] = find_S1_S2(Normal_timestamps, fileNames, audioData, y_denoised, springer_options, ...
                                    B_matrix, pi_vector, total_obs_distribution, fs, fs_ds);
% Estimated peaks
peak_times_S1;
peak_times_S2;

%% S1 and S2 in normal + murmur data

[peak_times_S1_alldata, peak_times_S2_alldata, assigned_states_alldata, tot_murmur_normal] = S1_S2_normal_murmur(labels, y_denoised, fs_ds, springer_options, ...
                                             B_matrix, pi_vector, total_obs_distribution);

%% Extracting features based on S1 and S2

Time_all_features = extract_features(peak_times_S1_alldata, peak_times_S2_alldata, y_len_orig_sec);

%% also add freq domain features

Freq_all_features = extract_freq_dom_features(y_denoised(1:tot_murmur_normal), assigned_states_alldata(1:tot_murmur_normal).', fs_ds);

%% fix NaNs/negatives (if any)
[any_nan_T, any_negative_T, any_nan_F, any_negative_F] = test_nan_new(Time_all_features, Freq_all_features);

%% add the dummy -1 for the artifacts

T_all_features = [Time_all_features, Freq_all_features];
T = artifact_features(labels, T_all_features);

%% appending filename and labels

Final_table = append_filename_label(fileNames, labels, T);

%% write table to csv for importing to jupyter notebook

writetable(Final_table, 's1s2_features.csv');

%% 

