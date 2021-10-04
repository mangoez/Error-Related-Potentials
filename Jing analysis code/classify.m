%% Sort data and downsample
all_trials = [y_trials1];
all_boo = double([boo1])';
all_trials = reshape(all_trials, size(all_trials, 1), size(all_trials, 2) * size(all_trials, 3));
all_trials = all_trials(:, 1:6:end);

n = [(1-sum(all_boo)), sum(all_boo)];
cv = cvpartition(all_boo, 'KFold', 5, 'Stratify', true); % Nonstratified partition


%% Cross validation
numFolds = cv.NumTestSets;
cmatrix = zeros(2, 2);

for i = 1:numFolds
    all_boo_test = all_boo(cv.test(i));
    all_trial_test = all_trials(cv.test(i));
    
    all_boo_train = all_boo(cv.training(i));
    all_trial_train = all_trials(cv.training(i));
    
    mdl = fitcsvm(all_trial_train, all_boo_train,'KernelFunction','rbf');
    [label, score] = predict(mdl, all_trial_test);
    
    cmatrix = cmatrix + confusionmat(all_boo_test, label);
end


