function [handler_figure] = func_figure_backoff_packets_rx_per_neighbour(figure_number,vector_backoff_window_sizes_unique,matrix_backoff_no_packets_rx_avg,vector_no_neighbours_unique,str_title)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        pos = find(vector_no_neighbours_unique == 0,1);
        if (isempty(pos))
            hplots = zeros(1,size(vector_no_neighbours_unique,2));
            pos_size_max = size(vector_no_neighbours_unique,2);
        else
            hplots = zeros(1,pos-1);
            pos_size_max = pos-1;
        end
        for i = 1:1:pos_size_max
            hplots(1,i) = plot(vector_backoff_window_sizes_unique(:),matrix_backoff_no_packets_rx_avg(i,:),'LineWidth',2);           
        end
        grid on
        title(str_title,'FontSize',14,'FontWeight','bold');
        xlabel('\bf{Backoff-Fenstergröße}');
        ylabel('\bf{Anzahl empfangener Pakete im Mittel}');
        %set(hplots,'LineWidth',2)
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 

        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        legend_txt  = cell(1,pos_size_max);
        for i=1:1:pos_size_max
            string = num2str(vector_no_neighbours_unique(1,i));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplots,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{'\bf{Anzahl von 802.11-Nachbarstationen}'}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13);
    hold off
end

