
if (~exist('basedir'))
  basedir=''
else
  basedir
end

if (~exist('index'))
  index=load(strcat(basedir,'result_flooding_info_index.dat'),'-ASCII');
  summary=load(strcat(basedir,'result_flooding.dat'),'-ASCII');
  times=load(strcat(basedir,'result_flowtime.dat'),'-ASCII');
end

plot_cols=['r';'m';'k';'b';'c';'g';'y';'r';'m';'k';'b';'c';'y'];
scheduling_schemes_str = {'neighbours cnt','max delay','prio'};

INDEX=1;

%index
SCHEDULING=26;

%flowtime
AVG_TIME=15;

%sum
CNT_TX_PKT=8;

schedule_configs=unique(index(:,SCHEDULING));

result=[];
scheme_labels = {};

for sc=1:size(schedule_configs,1)
    cur_sc=schedule_configs(sc);
    c_inds=unique(index(find(index(:,SCHEDULING)==cur_sc),INDEX));
    
    for c=1:size(c_inds,1)
        t=times(find(index(:,INDEX)==c_inds(c)),AVG_TIME);
        p=summary(find(index(:,INDEX)==c_inds(c)),CNT_TX_PKT);
        
        result=[result; [sc p t]];
    end

end

%result

figure;

for sc=1:size(schedule_configs,1)
    cur_sc=schedule_configs(sc);
    scheme_labels = union(scheme_labels, strcat(scheduling_schemes_str(cur_sc)), 'stable');

    r=result(find(result(:,1) == cur_sc),[2 3]);
    
    scatter(r(:,1),r(:,2),20,plot_cols(cur_sc));
    hold on;
end

title('Packet count vs avg delay');
xlabel('#Packet');
ylabel('Avg. delay (ms)');
legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'northeast');
grid on;
xlim([0 max(result(:,2))*1.05]);
ylim([0 max(result(:,3))*1.05]);
