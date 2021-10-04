function [error_avg correct_avg bad acc] = process_data(name, session)
    %% Subject info
    subjStr=name;

    %% Load data
    % path='Users/mangoez/Desktop/Projects/ErrP/data/Data_for_Po/';
    path = '';
    y1=load(path+subjStr+session+'.mat');
    data_ses1=y1.ans;

    %% Find onset
    r_trig=18;
    triggers1=findOnset(data_ses1(r_trig,:),1,0.99);
    ends1 = find(y1.ans(18, :) == -1);
   
    %% Session 
    n_sec = 9;
    y_ans1 = [];
    y_decode1 = [];
    y_corr1 = [];
    for i=1:size(triggers1, 2)
        ind = triggers1(i);
        y_ans1 = [y_ans1 y1.ans(18, ind)];
        y_decode1 = [y_decode1 y1.ans(20, ind+(512*n_sec))];
        y_corr1 = [y_corr1 y1.ans(21, ind)];
    end
%     figure;
%     plot(data_ses1(r_trig,:));hold on
%     shifted = data_ses1(20,:);
%     shifted = [shifted((512*n_sec):end) zeros(1, (512*n_sec))];
%     size(shifted)
%     plot(shifted);

    count = 1;
    y_trials1 = zeros(size(ends1, 2), 10, 512*2);
    for i=1:size(ends1, 2)
        y_trials1(count, :, :) = y1.ans(8:17, ends1(i):ends1(i)+(512*2)-1);
        count = count + 1;
    end


    %% Label trials
    boo1 = (abs(y_ans1 - y_decode1) > 0);

    %% Plot
    channels = ["Fz" "FC1" "FCz" "FC2" "C1" "Cz" "C2"];

    boo_plot1 = (abs(y_ans1 - y_decode1) > 0);
  
    all_trials_plot = y_trials1;
    all_boo_plot = double(boo_plot1);

    correct_avg = zeros(10, 512*2);
    error_avg = zeros(10, 512*2);
    error_cnt = 0;
    correct_cnt = 0;

    for i=1:size(all_trials_plot, 1)
        boo = all_boo_plot(i);
        if boo
            error_avg = error_avg + squeeze(all_trials_plot(i, :, :));
            error_cnt = error_cnt + 1;
        else
            correct_avg = correct_avg + squeeze(all_trials_plot(i, :, :));
            correct_cnt = correct_cnt + 1;
        end
    end

    %% Outputs
    error_avg = error_avg / error_cnt;
    correct_avg = correct_avg / correct_cnt;
    bad = [];
    acc = (correct_cnt/(error_cnt+correct_cnt));

    if ((acc < 0.6) || (acc == 1))
        bad = 1;
    end
end