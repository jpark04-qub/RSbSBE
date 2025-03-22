function [x] = normalise(x)
    % mean std normalisation

    n = size(x, 1);

    for k = 1:n                         
        m = mean(x(k, :));
        s = std(x(k, :));
        x(k, :) = (x(k, :)-m)./s;    
   
        if all(isnan(x(k, :)))        
            fprint("Normalise nan\n"); 
        end
    end    
end