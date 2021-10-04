Files = dir(fullfile('','*.mat'));


% total_info = [];
% total_info.name = strings([size(Files, 1), 1]);
% total_info.error_averages = zeros(size(Files, 1), 10, 2*512);
% total_info.correct_averages = zeros(size(Files, 1), 10, 2*512);
% total_info.acc = zeros(size(Files, 1), 1);
% total_bad = [];
% total_bad.index = zeros(size(Files, 1), 1);

accepted_info = [];
accepted_info.name = strings([size(Files, 1)-sum((total_bad.index > 0)), 1]);
accepted_info.error_averages = zeros(size(Files, 1)-sum((total_bad.index > 0)), 10, 2*512);
accepted_info.correct_averages = zeros(size(Files, 1)-sum((total_bad.index > 0)), 10, 2*512);
accepted_info.acc = zeros(size(Files, 1)-sum((total_bad.index > 0)), 1);

count = 1;
for i=1:size(Files, 1)
    N = size(Files(i).name, 2);
    name = Files(i).name(1:8);
    suffix = Files(i).name(9:N-4);
    
    [error_avg, correct_avg, bad, acc] = process_data(string(name), string(suffix));
    total_info.name(i) = strcat(name, suffix);
    total_info.error_averages(i, :, :) = error_avg;
    total_info.correct_averages(i, :, :) = correct_avg;
    total_info.acc(i) = acc;

    if bad
        total_bad.index(i) = i;
    else
        accepted_info.name(count) = strcat(name, suffix);
        accepted_info.error_averages(count, :, :) = error_avg;
        accepted_info.correct_averages(count, :, :) = correct_avg;
        accepted_info.acc(count) = acc;
        count = count + 1;
    end
end

