function [n, s] = subsets(N)
    % N - number of remaining features
    % n - number of subsets
    % s - subset size

    % subset size
    s = round(sqrt(N));
    n = ceil(N / s);
end