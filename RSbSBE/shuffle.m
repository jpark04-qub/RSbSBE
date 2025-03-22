function F_t = shuffle(F_t)
    idx = randperm(size(F_t, 1));
    F_t = F_t(idx, :);
end