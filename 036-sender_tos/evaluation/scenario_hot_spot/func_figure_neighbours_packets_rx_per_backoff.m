function [handler_figure] = func_figure_neighbours_packets_rx_per_backoff(figure_number,vector_no_neighbours_unique,matrix_backoff_no_packets_rx_avg, vector_backoff_window_sizes_unique)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hplot = plot(vector_no_neighbours_unique,matrix_backoff_no_packets_rx_avg);
    grid on
    xlabel('\bf Anzahl 802.11-Nachbarstationen');
        ylabel('\bf Anzahl empfangener Pakete im Mittel');
        set(hplot,'LineWidth',2)
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 

        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        legend_txt  = cell(1,size(vector_backoff_window_sizes_unique,1));
        for i=1:1:size(vector_backoff_window_sizes_unique,1)
            string = num2str(vector_backoff_window_sizes_unique(i,1));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplot,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{'\bf Backoff-Fenstergröße'}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13);
end

