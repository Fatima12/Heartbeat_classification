function y_denoised = denoise_by_filtering(downsampledData, fs_ds, low_cutoff, high_cutoff)
    
    y_denoised = cell(size(downsampledData));
    for i = 1:length(downsampledData)
        y = downsampledData{1, i}; % data file
        y_denoised{i} = denoise_filter(y, fs_ds, low_cutoff, high_cutoff); %denoise
        close all
    end

end