%% General information:
% Sampling rate: 512Hz.
% 15 targets.
% 
% Experiment:
% 4 sessions * 7 tests in each session.
% 15 trials in each test.
% Also recorded 2*60s idle in data_idle. First one is when subject looking
%   at a solid black screen. Second is when subject has eyes closed.
% As well as a single frequency test data_single. Frequencies used are 5 to
%   19 Hz with 1 Hz interval (5:1:19). This is also the order of the
%   targets, as target 1 at 5 Hz, 2 at 6 Hz, etc.
% 
% Data: (rows)
%   1: time
%   2-7: Channels 1-6 SSVEP PO3, POz, PO4, O1, Oz, O2
%   8-17: Channels 7-16 ErrP Fz, FCz, Cz, FC1, FC2, C1, C2, CPZ, F1, F2
%   18: trigger signal received through UDP. positive numbers are integers
%       labeling the onset of the trials with magnitude equals to trial
%       index. -1 labels the end of a trial.
%   19: processed trigger data. shows 1 when stimulation is on and 0 when
%       off.
%   20: decoder output (index of the target. if this matches with trial
%       index then it is a correct detection.)
%   21: correlation between the data and the template of the decoded
%       output.
% 
% This is subject 6, so check the 6th row in tests.
% The value in tests is the test index.
% The used frequencies in these tests can be found in genFreqCand. You can
%   call this function with test index as input to get the sequence of
%   frequency pairs for the targets. Again listed in the order from target
%   1 to target 15.

%% Get tasks indices
tests=genTestSequence();

%% Subject info
subjStr="XG_07Sep";
% subjStr = '';
subj=6;

%% Load data
% path='Users/mangoez/Desktop/Projects/ErrP/data/Data_for_Po/';
path = '';

y1=load(path+subjStr+'_ses3.mat');
data_ses1=y1.ans;

y2=load(path+subjStr+'_ses4.mat');
data_ses2=y2.ans;

% y3=load(path+subjStr+'_ses3.mat');
% data_ses3=y3.ans;
% 
% y4=load(path+subjStr+'_ses4.mat');
% data_ses4=y4.ans;

%% Load idle and single
% idle=load(path+subjStr+'_idle.mat');
% data_idle=idle.ans;

% % single: 5:19 Hz
% single=load(path+subjStr+'_single.mat');
% data_single=single.ans;

%% Find onset
r_trig=18;

triggers1=findOnset(data_ses1(r_trig,:),1,0.99);
triggers2=findOnset(data_ses2(r_trig,:),1,0.99);
% % triggers3=findOnset(data_ses3(r_trig,:),1,0.99);
% % triggers4=findOnset(data_ses4(r_trig,:),1,0.99);
% 
% % triggers_idle=findOnset(data_idle(r_trig,:),1,0.99);
% % triggers_single=findOnset(data_single(r_trig,:),1,0.99);
% 
% % triggers1=triggers1(2:106); % XG_03Aug
% % There was a mistake at the start, so need to remove the first trigger
% % signal.
% 
% % close all
% 
% %% Cut data into pieces
% Fs=512;
% dataLength=5;   %s
% offset=0.14;    %s
% offset_idx=round(offset*Fs);
% restLength=3;
% idleLength=60;
% NOTrigs=size(triggers1,2);
% NOTrials=15;
% 
% NOChannels=16;
% 
% % idle1=data_idle(1:NOChannels+1,triggers_idle(1):triggers_idle(1)+Fs*idleLength-1);
% % idle2=data_idle(1:NOChannels+1,triggers_idle(2):triggers_idle(2)+Fs*idleLength-1);
% 
% % for i=1:15
% %     str=sprintf('single_%s',num2str(i));
% %     temp=genvarname(str);
% %     eval([temp '=data_single(1:NOChannels+1,triggers_single(i):triggers_single(i)+Fs*dataLength-1);'])
% % end
% 
% for ses=1:2
%     test_pre=0;
%     for trig=1:NOTrigs
%         testIdx=ceil(trig/NOTrials);
%         trial=trig-(testIdx-1)*NOTrials;
%         test=tests(subj,testIdx+7*(ses-1));
% 
%         dataStr=sprintf('data_ses%s',num2str(ses));
%         datatemp=eval(dataStr);
%         trigStr=sprintf('triggers%s',num2str(ses));
%         trigtemp=eval(trigStr);
%         str=sprintf('y_S%s_T%s_%s',num2str(ses),num2str(test),num2str(trial));
%         temp=genvarname(str);
%         eval([temp '=datatemp(1:NOChannels+1,(trigtemp(trig)+offset_idx):(trigtemp(trig)+offset_idx+Fs*dataLength-1));']);
% 
% 
% %         % rest period (3s before each trial)
% %         restdataStr=sprintf('data_ses%s',num2str(ses));
% %         restdatatemp=eval(restdataStr);
% %         reststr=sprintf('rest_S%s_T%s_%s',num2str(ses),num2str(test),num2str(trial));
% %         resttemp=genvarname(reststr);
% %         eval([resttemp '=restdatatemp(1:7,(trigtemp(trig)-Fs*restLength):(trigtemp(trig)-1));']);
%     end
% end
% 
ends1 = find(y1.ans(18, :) == -1);
ends2 = find(y2.ans(18, :) == -1);
% % ends3 = find(y3.ans(18, :) == -1);
% % ends4 = find(y4.ans(18, :) == -1);

%% Session 1
y_ans1 = [];
y_decode1 = [];
y_corr1 = [];
for i=1:size(triggers1, 2)
    ind = triggers1(i);
    y_ans1 = [y_ans1 y1.ans(18, ind)];
    y_decode1 = [y_decode1 y1.ans(20, ind+(512*6))];
    y_corr1 = [y_corr1 y1.ans(21, ind)];
end

count = 1;
y_trials1 = zeros(30, 10, 512*2);
for i=1:size(ends1, 2)
    y_trials1(count, :, :) = y1.ans(8:17, ends1(i):ends1(i)+(512*2)-1);
    count = count + 1;
end

%% Session 2
y_ans2 = [];
y_decode2 = [];
y_corr2 = [];
for i=1:size(triggers2, 2)
    ind = triggers2(i);
    y_ans2 = [y_ans2 y2.ans(18, ind)];
    y_decode2 = [y_decode2 y2.ans(20, ind+(512*6))];
    y_corr2 = [y_corr2 y2.ans(21, ind)];
end

count = 1;
y_trials2 = zeros(30, 10, 512*2);
for i=1:size(ends2, 2)
    y_trials2(count, :, :) = y2.ans(8:17, ends2(i):ends2(i)+(512*2)-1);
    count = count + 1;
end

% %% Session 3
% y_ans3 = [];
% y_decode3 = [];
% y_corr3 = [];
% for i=1:size(triggers3, 2)
%     ind = triggers3(i);
%     y_ans3 = [y_ans3 y3.ans(18, ind)];
%     y_decode3 = [y_decode3 y3.ans(20, ind+(512*5))];
%     y_corr3 = [y_corr3 y3.ans(21, ind)];
% end
% 
% count = 1;
% y_trials3 = zeros(105, 10, 512*2);
% for i=1:size(ends3, 2)
%     y_trials3(count, :, :) = y3.ans(8:17, ends3(i):ends3(i)+(512*2)-1);
%     count = count + 1;
% end
% 
% %% Session 4
% y_ans4 = [];
% y_decode4 = [];
% y_corr4 = [];
% for i=1:size(triggers4, 2)
%     ind = triggers4(i);
%     y_ans4 = [y_ans4 y4.ans(18, ind)];
%     y_decode4 = [y_decode4 y4.ans(20, ind+(512*5))];
%     y_corr4 = [y_corr4 y4.ans(21, ind)];
% end
% 
% count = 1;
% y_trials4 = zeros(105, 10, 512*2);
% for i=1:size(ends4, 2)
%     y_trials4(count, :, :) = y4.ans(8:17, ends4(i):ends4(i)+(512*2)-1);
%     count = count + 1;
% end

%% Label trials
boo1 = (abs(y_ans1 - y_decode1) > 0);
boo2 = (abs(y_ans2 - y_decode2) > 0);
% boo3 = (abs(y_ans3 - y_decode3) > 0);
% boo4 = (abs(y_ans4 - y_decode4) > 0);

%% Plot
channels = ["Fz" "FC1" "FCz" "FC2" "C1" "Cz" "C2"];

boo_plot1 = (abs(y_ans1 - y_decode1) > 0);
boo_plot2 = (abs(y_ans2 - y_decode2) > 0);
% boo_plot3 = (abs(y_ans3 - y_decode3) > 0);
% boo_plot4 = (abs(y_ans4 - y_decode4) > 0);

all_trials_plot = [y_trials2];
all_boo_plot = double([boo_plot1 boo_plot2])';

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

error_avg = error_avg / error_cnt;
correct_avg = correct_avg / correct_cnt;
t = 0:1/512:2 - 1/512;

for i=2:4
    figure(i)
    tiledlayout(3,1)
    
    % Top plot
    nexttile
    plot(t, correct_avg(i, :))
    title('Average ' + channels(i) + ' correct trials')

    % Bottom plot
    nexttile
    plot(t, error_avg(i, :))
    title('Average ' + channels(i) + ' error trials')
    
    nexttile
    plot(t, error_avg(i, :) - correct_avg(i, :))
    title('Average difference ' + channels(i) + ' error trials')
end


