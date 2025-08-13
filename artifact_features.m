function T = artifact_features(labels, T)

    % Number of artifact rows to add
    n_missing = length(labels) - height(T);
    
    % Only do this if n_missing > 0
    if n_missing > 0
        % Create a table of -1s
        T_artifacts = array2table(-1 * ones(n_missing, width(T)), ...
                                   'VariableNames', T.Properties.VariableNames);
    
        % Append to original table
        T = [T; T_artifacts];
    end

end