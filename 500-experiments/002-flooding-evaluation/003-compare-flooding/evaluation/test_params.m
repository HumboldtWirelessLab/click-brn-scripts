function figurehandle = test_params(show_config, result, params, show_param)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
plot_cols = ['r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y';'r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y';'r';'m';'k';'b';'c';'y'];
plot_sign = ['*';'+';'o';'x';'<';'s';'d';'>';'^'];

config_info

show_param_str = {'config', '#Packet' , 'Avg. delay (ms)' , '#Max Delay per Hop' , 'Reach'};
show_param_filestr = {'config', 'cntpacket' , 'avgdelay' , 'maxdelayperhop', 'reach' };

show_cfgs = unique(show_config(:,params),'rows');

size(show_cfgs)
size(show_config)

show_cfgs_labels = {};

for rc=1:size(show_cfgs,1)
  show_cfgs_labels = union(show_cfgs_labels, strcat( params_name(params(1)),' (',num2str(show_cfgs(rc,1)),')  - ',params_name(params(2)),' (',num2str(show_cfgs(rc,2)), ')' ), 'stable');
end

figurehandle = figure;

sum_size=0;

max_x = min(result(:,show_param(1)));
max_y = min(result(:,show_param(2)));
min_x = max(result(:,show_param(1)));
min_y = max(result(:,show_param(2)));

for sc=1:size(show_cfgs,1)
    cur_sc=show_cfgs(sc,:)
    
    config_ids = show_config(ismember(show_config(:,params),cur_sc,'rows'),end)
    %ismember(result(:,1),config_ids,'rows')
    
    r=result(ismember(result(:,1),config_ids,'rows'),show_param);
    
    max_x = max([max_x max(r(:,1))]);
    max_y = max([max_y max(r(:,2))]);
    min_x = min([min_x min(r(:,1))]);
    min_y = min([min_y min(r(:,2))]);
    
    sum_size=sum_size+size(r);

    col_index = cur_sc(2)+2;
    
    if ( col_index > 32 )
        col_index = 1;
    end
    
    sign_index = cur_sc(1)+2;
    
    if ( sign_index > 8 )
        sign_index = 1;
    end
    
    scatter(r(:,1),r(:,2),20,plot_cols(col_index),plot_sign(sign_index)); %end

    hold on;
end

%sum_size

title(strcat(show_param_str(show_param(1)),' vs. ', show_param_str(show_param(2))));
xlabel(show_param_str(show_param(1)));
ylabel(show_param_str(show_param(2)));

legend(findobj(gca,'Tag','Box'),show_cfgs_labels,'location', 'northeast');
grid on;
xlim([min_x*0.95 max_x*1.05]);
ylim([min_y*0.95 max_y*1.05]);

pngfile=char(strcat(show_param_filestr(show_param(1)),'_vs_', show_param_filestr(show_param(2)),'.png'));
epsfile=char(strcat(show_param_filestr(show_param(1)),'_vs_', show_param_filestr(show_param(2)),'.png'));

saveas(figurehandle, pngfile, 'png');
saveas(figurehandle, epsfile, 'epsc');

end

