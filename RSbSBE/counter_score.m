function [ctrl, R_f] = counter_score(ctrl, F_t, R_f, x_t, y_t)
    if ~ctrl.cs_on
        return;
    end

    rate = (ctrl.N/ctrl.tfs);
    rate = max(rate, ctrl.cs_min); 
    ctrl.cs_rate = rate;

    f = F_t(:, 2);
    
    [fid, IG] = MI(x_t(:, f), y_t, 3);
    alpha = (max(R_f) * rate) * 1.0;            
    %alpha = rate;
    for i = 1:length(fid)      
        I_f = IG(i)/IG(1);
        R_f(F_t(fid(i), 1)) = R_f(F_t(fid(i), 1)) + (alpha * I_f);
    end    
end