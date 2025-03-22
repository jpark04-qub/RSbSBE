function M = classifier(cfg, x, y)
    type = cfg.classifier;

    switch type
        case 'knn'
            M = fitcknn(x, y, 'NumNeighbors', cfg.k);
        case 'svm'
            M = fitcsvm(x, y, 'boxconstraint', 0.1);
        otherwise
            error("invalid calssifier type");
    end 
end
