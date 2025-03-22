function [S, Prog, Fnum] = RSbSBE(cfg, classifer, x_t, x_v, y_t, y_v)
    % Random Subset based Sequential Backward Elimination
   
    % number of classes and features
    n_classes = max(y_t);
    n_feature = size(x_t, 2);
    
    % control parameters
    ctrl.Lc = 0.2; 
    ctrl.cfg = cfg;
    ctrl.E = 50;           % initial expected value
    ctrl.nc = n_classes;    % number of classes
    ctrl.tfs = n_feature;  % total feature size
    ctrl.N = n_feature;    % number of remaining features 
    ctrl.cs_on = true;
    ctrl.cs_param = 50;
    ctrl.cs_min =  0.01;   % minimum cs contribution rate
    ctrl.cs_rate = 0;
    ctrl.sub_idx = 0;      % subtraction idx
    ctrl.sub_rate = 0.05;  % subtraction rate
    ctrl.sub_f = [];       % subtracted features
   
    % global stopping criteria
    ctrl.Gc = round(cfg.n * 0.01 * n_feature);
    
    % Class-specific classification accuracies across the entire execution 
    ctrl.CTP = zeros(n_classes, 1); % cumulated true positive
    ctrl.CFN = zeros(n_classes, 1); % cumulated false negative
   
    % feature normalisation
    x_t = normalise(x_t);
    x_v = normalise(x_v);     

    % feature selection progress
    Prog = [];
    Fnum = [];
    
    max_step = 10000;
    max_iter = 100;
    check_iter = 20;

    step = 1;
    P_s = []; % performance of step   
    F = x_t;  % full feature set
    while(step <= max_step)  
        % local stop 
        ctrl.Lc = ctrl.Lc * 1.1;

        % rearrange remaining features
        F_t = rearrange(ctrl.tfs, ctrl.sub_f);

        % number of remaining features
        ctrl.N = size(F_t, 1);        

        % ready feature relevance score
        R_f = zeros(ctrl.N, 1);

        % check global criterion Cg
        if ctrl.N <= ctrl.Gc
            break;
        end                

        % subset parameters
        [S_n, S_s] = subsets(ctrl.N);

        % feature selection interations in the step             
        fprintf("step %2.0d iter :   ", step);
        for iter = 1:max_iter    
            % evaluate subsets            
            [ctrl, R_f, P_i] = evaluation(ctrl, x_t, y_t, x_v, y_v, F_t, R_f, S_n, S_s);

            % step performance
            P_s(iter) = P_i/S_n;

            % display progress
            fprintf('\b\b\b%3.0f', iter); 
            pause(0.1);            

            if iter < check_iter
                continue;
            end

            % check local stop
            Lc = std(P_s);
            if (Lc >= ctrl.Lc) && (iter < max_iter)
                continue;
            end

            % udpate statistics
            Prog(step) = mean(P_s);
            Fnum(step) = ctrl.N;

            % local stop satisfied, apply counter score
            [ctrl, R_f] = counter_score(ctrl, F_t, R_f, x_t, y_t);

            % subtraction
            ctrl = subtraction(ctrl, F_t, R_f);  
            fprintf(" - feat %3.0f, score %3.2f[%3.2f][%3.2f], cs %3.2f\n", ...
                    ctrl.N, mean(P_s), Lc, ctrl.Lc, ctrl.cs_rate);

            % step completes            
            break;            
        end        
        step = step+1;
    end
    S = F_t(:,2);
end




