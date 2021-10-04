t = 0:1/512:2 - 1/512;
channels = ["Fz" "FC1" "FCz" "FC2" "C1" "Cz" "C2"];


N = size(accepted_info.name, 1);

figure('Name','Correct')
tiledlayout(ceil(N/3), 3)
for k = 1:N
    for i=3:3
        nexttile
        plot(t, squeeze(accepted_info.correct_averages(k, i, :)))
        title(accepted_info.name(k) + ' ' + channels(i) + ...
              ' ' + accepted_info.acc(k))
    end
end


figure('Name','Incorrect')
tiledlayout(ceil(N/3), 3)
for k = 1:N
    for i=3:3
        nexttile
        plot(t, squeeze(accepted_info.error_averages(k, i, :)))
        title(accepted_info.name(k) + ' ' + channels(i) + ...
              ' ' + accepted_info.acc(k))
    end
end


figure('Name','Difference')
tiledlayout(ceil(N/3), 3)
for k = 1:N
    for i=3:3
        nexttile
        plot(t, squeeze(accepted_info.error_averages(k, i, :) ...
                        - accepted_info.correct_averages(k, i, :)))
        title(accepted_info.name(k) + ' ' + ...
              channels(i) + ' ' + accepted_info.acc(k))
    end
end