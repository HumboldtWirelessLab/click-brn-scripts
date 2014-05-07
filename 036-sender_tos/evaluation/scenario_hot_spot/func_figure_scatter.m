function [handler_figure] = func_figure_scatter(figure_number,matrix_packet_counter,matrix_rssi,vector_legend,str_title,str_xlabel,str_ylabel,str_legend_title)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
    hplots = zeros(1,size(matrix_packet_counter,1));
    counter = 0;
    for i = 1:1:size(matrix_packet_counter,1)
        if (counter < 7)
            hplots(1,i) = scatter(matrix_packet_counter(i,:),matrix_rssi(i,:),'LineWidth',2);
            counter = counter + 1;
        elseif (counter >= 7)
            hplots(1,i) = scatter(matrix_packet_counter(i,:),matrix_rssi(i,:),'filled','LineWidth',2);
            counter = counter + 1;
        end
    end
    grid on
     title(str_title,'FontSize',14,'FontWeight','bold');
    xlabel(str_xlabel);
    ylabel(str_ylabel);
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
    set(get(handler_legend,'title'),'FontSize',13,'FontWeight','bold');
    xmax = max(max(matrix_packet_counter)) + 1;
    xlim([0 xmax])
    ymax = max(max(matrix_rssi)) + 1;
    ylim([0 ymax])
    hold off
end

