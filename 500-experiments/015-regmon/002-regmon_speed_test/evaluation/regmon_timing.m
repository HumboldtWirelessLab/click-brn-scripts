function regmon_timing(regmon_data_file)

regmon_data = load(regmon_data_file);

regmon_data = sort(regmon_data, 1, 'ascend');
intervals = sort(unique(regmon_data(:,1)));

% bar-plot intervals vs. cycle count mean
% cycle count MUST be the 5th column!
cc_means  = [];

for i = 1:size(intervals, 1)
    cc_means = [cc_means, mean(regmon_data(find(regmon_data(:,1) == intervals(i)), 5))/intervals(i)];
end

figure;
bar(intervals, cc_means);
xlabel('interval in usec');
ylabel('cycle counts per usec (mean)');

print('cycle_duration.png','-dpng');

% bar-plot intervals vs. nanosec-difference-mean
% nanoseconds MUST be the 9th column!

ns_diff_means = [];

for i = 1:size(intervals, 1)
    ns_diff_means = [ns_diff_means, mean(diff(regmon_data(find(regmon_data(:,1) == intervals(i)), 9))/intervals(i))];
end

figure;
bar(intervals, ns_diff_means);
xlabel('interval in usec');
ylabel('nsec difference mean');


% scatter-plot cycle count mean vs nanosecond difference mean

ns_diff_means = [];
cc_means  = [];

for i = 1:size(intervals, 1)
    ns_diff_means = [ns_diff_means, mean(diff(regmon_data(find(regmon_data(:,1) == intervals(i)), 9)))];
end

for i = 1:size(intervals, 1)
    cc_means = [cc_means, mean(regmon_data(find(regmon_data(:,1) == intervals(i)), 5))];
end

figure;
scatter(cc_means, ns_diff_means);
xlabel('cycle count mean');
ylabel('nsec difference mean');

end
