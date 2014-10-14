function unic_reject_and_pa_retries(show_config, result)

unic_reject_schemes_str = {'no_reject','reject'};
plot_cols=['r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y';'r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y'];
plot_sign=['x';'+';'o';'*';'.'];

reject_paretries_cfgs = unique(show_config(:,[3 5]),'rows')

unicreject_paretries_labels = {};

for rc=1:size(reject_paretries_cfgs,1)
  unicreject_paretries_labels = union(unicreject_paretries_labels, strcat(unic_reject_schemes_str(reject_paretries_cfgs(rc,1)+1),' - paretries ',num2str(reject_paretries_cfgs(rc,2)) ), 'stable');
end

h1 = figure;

for sc=1:size(reject_paretries_cfgs,1)
    cur_sc=reject_paretries_cfgs(sc,:)

    r=result(show_config(ismember(show_config(:,[3 5]),cur_sc,'rows'),end),[2 3]);
    size(r)

    scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(2)),plot_sign(cur_sc(1)+1)); %end

    hold on;
end

title('Packet count vs avg delay');
xlabel('#Packet');
ylabel('Avg. delay (ms)');
legend(findobj(gca,'Tag','Box'),unicreject_paretries_labels,'location', 'southwest');
grid on;
xlim([0 max(result(:,2))*1.05]);
ylim([0 max(result(:,3))*1.05]);

saveas(h1, 'txscheduling.png' ,'png');
saveas(h1, 'txscheduling.eps' ,'epsc');

end