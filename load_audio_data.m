function [audioData, labels, fileNames, fs, Normal_timestamps] = load_audio_data(basePath, categories)

    audioData = {};
    labels = {};
    fileNames = {};
    
    % Loop through each category
    for i = 1:length(categories)
        folder = fullfile(basePath, categories{i});
        files = dir(fullfile(folder, '*.wav'));
        
        for j = 1:length(files)
            filePath = fullfile(folder, files(j).name);
            
            % Read the audio
            [y, fs] = audioread(filePath);
    
            [~, nameOnly, ~] = fileparts(files(j).name);
    
            audioData{end+1} = y;
            labels{end+1} = categories{i};
            fileNames{end+1} = nameOnly;
            
            % Display progress
            fprintf('Loaded: %s (%s)\n', files(j).name, categories{i});
        end
    end

    timestampFile = fullfile(basePath, 'Normal_timestamps.csv');
    Normal_timestamps = readtable(timestampFile); 
    Normal_timestamps.fname = erase(Normal_timestamps.fname, ["set_a/normal__", ".wav"]);
end



