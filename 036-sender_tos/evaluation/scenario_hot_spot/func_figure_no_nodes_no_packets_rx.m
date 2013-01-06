function [handler_figure] = func_figure_no_nodes_no_packets_rx(figure_number,matrix,str_label_y,vector_packet_sizes)
    handler_figure = figure(figure_number);

    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplot = zeros(1,size(matrix,1));
        for i=1:1:size(matrix,1)
            if (strfind(str_label_y,'[KB]'))
                kB = 1000; %[Byte]
                for t=1:1:size(matrix,2)
                    matrix(i,t,2) = (matrix(i,t,2) * vector_packet_sizes(i,1)) / kB;
                end
            end
            hplot(1,i) =  plot(matrix(i,:,1),matrix(i,:,2),'-x');
        end
        grid on
        xlabel('\bf Anzahl von 802.11-Nachbarstationen');
        ylabel(str_label_y);
        set(hplot,'LineWidth',2)
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        legend_txt  = cell(1,size(vector_packet_sizes,1));
        for i=1:1:size(vector_packet_sizes,1)
            string = num2str(vector_packet_sizes(i,1));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplot,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{'\bf Paketgröße [Byte]'}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13);
        x_ticks_max = max(matrix(1,:,1));
        x_ticks_min = 0;
        Ticks_x = x_ticks_min:1:x_ticks_max;
        set(gca, 'XTickMode', 'manual', 'XTick', Ticks_x, 'xlim', [x_ticks_min,x_ticks_max + 0.5]);
        hold off


end

