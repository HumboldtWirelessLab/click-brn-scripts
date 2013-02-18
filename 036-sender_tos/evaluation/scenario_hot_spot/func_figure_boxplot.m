function [handler_figure] = func_figure_boxplot(figure_number,matrix_2D_y,str_title,str_label_y,str_label_x)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplots = boxplot(matrix_2D_y);
        grid on
        title(str_title,'FontSize',14,'FontWeight','bold');
        xlabel(str_label_x);
        ylabel(str_label_y);
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16);
        xLimits = get(gca,'XLim');  %# Get the range of the x axis
        yLimits = get(gca,'YLim');  %# Get the range of the y axis
        xmin = 0;
        xmax = xLimits(1,2);
        ymin = 0;
        ymax = yLimits(1,2);
        axis([xmin xmax ymin ymax])
        set(hplots,'LineWidth',2)
     hold off
end

