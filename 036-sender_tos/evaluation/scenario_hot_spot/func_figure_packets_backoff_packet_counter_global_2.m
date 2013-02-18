function [handler_figure] = func_figure_packets_backoff_packet_counter_global_2(figure_number,vector_x,matrix,str_title,str_label_x,str_label_y,vector_legend,str_legend_title)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplots = plot(vector_x,matrix,'-x','LineWidth',2);
        grid on
        title(str_title,'FontSize',14,'FontWeight','bold');
        xlabel(str_label_x);
        ylabel(str_label_y);
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 

        legend_txt  = cell(1,size(vector_legend,2));
        for i=1:1:size(vector_legend,2)
            string = num2str(vector_legend(1,i));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplots,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{str_legend_title}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13);
        xlim([0 (max(vector_x)+1)])
     hold off
end

