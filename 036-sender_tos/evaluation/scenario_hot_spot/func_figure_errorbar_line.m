function [handler_figure] = func_figure_errorbar_line(figure_number,vector_x,matrix_2D_y,matrix_2D_std,vector_legend,str_title,str_legend_title,str_label_y,str_label_x)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
    counter = 0;
     hplots = zeros(1,size(matrix_2D_y,1)); % per experiment
     for i = 1:1:size(matrix_2D_y,1) % per experiment
        pos = find(matrix_2D_y(i,:) == 0,1);
        if (isempty(pos))
            pos_size_max = size(matrix_2D_y,2);
        else
            pos_size_max = pos-1;
        end
        if (pos_size_max > 0)
            if (counter < 7)
                hplots(1,i) = errorbar(vector_x(1,1:1:pos_size_max),matrix_2D_y(i,1:1:pos_size_max),matrix_2D_std(i,1:1:pos_size_max),'-x','LineWidth',2);
                counter = counter + 1;
            elseif (counter >= 7)
                hplots(1,i) = errorbar(vector_x(1,1:1:pos_size_max),matrix_2D_y(i,1:1:pos_size_max),matrix_2D_std(i,1:1:pos_size_max),'--','LineWidth',2);
                counter = counter + 1;
            end
        end
     end
    grid on
    title(str_title,'FontSize',14,'FontWeight','bold');
    xlabel(str_label_x);
        ylabel(str_label_y);
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16);
            ymax = max(max(matrix_2D_y));
            ymax = ymax + max(max(matrix_2D_std)) + 1;
            ylim([0 ymax])
      hplots_pos = find(hplots ~= 0,1);
      if(~isempty(hplots_pos) && size(vector_legend,2) >= size(matrix_2D_y,1))
            legend_txt  = cell(1,size(matrix_2D_y,1));
            for i=1:1:size(matrix_2D_y,1)
                string = num2str(vector_legend(1,i));
                legend_txt(1,i) = {string};
            end
            handler_legend = legend(hplots,legend_txt,'Location','NorthEastOutside');
            set(get(handler_legend,'title'),'String',{str_legend_title}) 
            set(handler_legend,'FontSize',12)
            set(get(handler_legend,'title'),'FontSize',13,'FontWeight','bold');
      end
     hold off
end

