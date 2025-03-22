function [ctrl, R_f, P] = relevance_score(ctrl, R_f, fid, H, y_v)
    % H - hypothesis (prediction)
    
    % true positive = correct prediction
    % false negative = wrong prediction
    TP = zeros(ctrl.nc, 1);    
    FN = zeros(ctrl.nc, 1);                
    for j = 1:length(y_v)        
        if(y_v(j) == H(j))            
            TP(y_v(j)) = TP(y_v(j))+1;       
        else
            FN(y_v(j)) = FN(y_v(j))+1;        
        end
    end

    % ppdate cumulative class-specific accuracies   
    ctrl.CTP = ctrl.CTP+TP;   
    ctrl.CFN = ctrl.CFN+FN;        

    % subset performance score (UAR)     
    P = mean((TP./(TP+FN)) * 100);                       

    % relevance score of features in the subset
    R_f(fid) = R_f(fid) + P - ctrl.E; 

    % update expected value of the UAR performance criterion
    ctrl.E = mean((ctrl.CTP./(ctrl.CTP+ctrl.CFN)) * 100);  
end