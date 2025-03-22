function r = rearrange(tfs, sub_f)
    % F : n samples x m features
    % sf: feature id to be subtracted

    % feature id 1 to m
    indices = 1:tfs;

    % subtract features
    indices(:, sub_f) = 0;
    indices = find(indices ~= 0);

    % rearrange remaining features
    idx = randperm(size(indices, 2));
    indices = indices(:, idx);
    
    % set rearrange output 
    idx = (1:size(indices, 2))';
    r = [idx indices'];
end