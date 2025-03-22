function ctrl = subtraction(ctrl, F_t, R_f)
    % F_f - remaining features
    % R_f - relevance score

    % number of features to be subtracted
    n_subtract = round(ctrl.N*ctrl.sub_rate);
    if n_subtract == 0
        n_subtract = 1; % subtract at least 1 
    end

    % irrelevant feature list
    [W, I] = sort(R_f, 'ascend');  

    % choose features to subtract
    for i = 1:n_subtract
        f = find(F_t(:, 1) == I(i));
        ctrl.sub_f(ctrl.sub_idx + i) = F_t(f, 2);          
    end 
    
    % update parameters
    ctrl.sub_idx = ctrl.sub_idx + n_subtract;           
    ctrl.N = ctrl.N - n_subtract;            
end