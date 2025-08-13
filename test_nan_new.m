function [any_nan_T, any_negative_T, any_nan_F, any_negative_F] = test_nan_new(Time_all_features, Freq_all_features)

    any_nan_T = any(any(ismissing(Time_all_features)));
    any_negative_T = any(any(table2array(Time_all_features) < 0));
    
    any_nan_F = any(any(ismissing(Freq_all_features)));
    any_negative_F = any(any(table2array(Freq_all_features) < 0));

end