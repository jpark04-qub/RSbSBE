function [ctrl, R_f, P_i] = evaluation(ctrl, x_t, y_t, x_v, y_v, F_t, R_f, S_n, S_s)
    % shuffle remaining feature set
    F_t = shuffle(F_t); 

    % iteration performance score
    P_i = 0;

    % subset evaluation
    idx1 = 1;
    for i = 1:S_n
        % get subset S_i
        idx2 = min((idx1-1+S_s), ctrl.N);  
        S_i = F_t(idx1:idx2, 2);
        fid = F_t(idx1:idx2, 1);
        
        idx1 = idx1 + S_s;
    
        % train classifier and get prediction
        M = classifier(ctrl.cfg, x_t(:, S_i), y_t);
        H = predict(M, x_v(:, S_i));
                     
        % calculate relevance score 
        [ctrl, R_f, P] = relevance_score(ctrl, R_f, fid, H, y_v);               
    
        % update performance of iteration
        P_i = P_i + P;
    end