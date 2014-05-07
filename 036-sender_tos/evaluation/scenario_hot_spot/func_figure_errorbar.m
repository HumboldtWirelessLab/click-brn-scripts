function [handler_figure] = func_figure_errorbar(figure_number,vector_x,matrix_2D_mean,matrix_2D_std,str_title, str_label_x, str_label_y)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplots = zeros(1,size(matrix_2D_mean,1)); % per experiment
        counter = 0;
        for i = 1:1:size(matrix_2D_mean,1) % per experiment
            pos = find(matrix_2D_mean(i,:) == 0,1);
            if (isempty(pos))
                pos_size_max = size(matrix_2D_mean,2);
            else
                pos_size_max = pos-1;
            end
            if (pos_size_max > 0)
                if (counter < 7)
                    hplots(1,i) = errorbar(vector_x(1,i),matrix_2D_mean(i,1:1:pos_size_max),matrix_2D_std(i,1:1:pos_size_max),'xr','LineWidth',2);
                    counter = counter + 1;
                elseif (counter >= 7)
                    hplots(1,i) = errorbar(vector_x(1,i),matrix_2D_mean(i,1:1:pos_size_max),matrix_2D_std(i,1:1:pos_size_max),'xr','LineWidth',2);
                    counter = counter + 1;
                end
            end
        end
        grid on
        title(str_title,'FontSize',14,'FontWeight','bold');
        xlabel(str_label_x)
        ylabel(str_label_y)
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        ymax = max(max(matrix_2D_mean));
        ymax = ymax + max(max(matrix_2D_std)) + 1;
        ylim([0 ymax])
        xmax = max(vector_x) + 1;
        xlim([0 xmax]) 
     hold off
end

