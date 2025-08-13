function Final_table = append_filename_label(fileNames, labels, All_features)

    % Make sure fileNames and labels are column vectors
    fileNames_col = fileNames(:); % Convert to N x 1
    labels_col = labels(:);       % Convert to N x 1
    
    % Convert to table
    fileNames_table = cell2table(fileNames_col, 'VariableNames', {'filename'});
    labels_table = cell2table(labels_col, 'VariableNames', {'label'});
    
    % Concatenate with the features table
    Final_table = [All_features, fileNames_table, labels_table];

end