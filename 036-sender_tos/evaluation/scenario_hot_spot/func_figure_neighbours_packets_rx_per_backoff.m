function [handler_figure] = func_figure_neighbours_packets_rx_per_backoff(figure_number,vector_no_neighbours_unique,matrix_backoff_no_packets_rx_avg, vector_backoff_window_sizes_unique,str_title)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
    hplots = zeros(1,size(matrix_backoff_no_packets_rx_avg,2));
    pos = find(vector_no_neighbours_unique == 0,1);
    if (isempty(pos))
        pos_size_max = size(vector_no_neighbours_unique,2);
     else
        pos_size_max = pos-1;
    end
    for j=1:1:size(matrix_backoff_no_packets_rx_avg,2)
        hplots(1,j) = plot(vector_no_neighbours_unique(1,1:1:pos_size_max),matrix_backoff_no_packets_rx_avg(1:1:pos_size_max,j),'-x');
    end
    grid on
    title(str_title,'FontSize',14,'FontWeight','bold');
    xlabel('\bf Anzahl 802.11-Nachbarstationen');
        ylabel('\bf Anzahl empfangener Pakete im Mittel');
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 

        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        
        legend_txt  = cell(1,size(vector_backoff_window_sizes_unique,2));
        for i=1:1:size(vector_backoff_window_sizes_unique,2)
            string = num2str(vector_backoff_window_sizes_unique(1,i));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplots,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{'\bf Backoff-Fenstergröße'}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13);
     hold off
end

