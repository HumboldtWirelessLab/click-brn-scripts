function [handler_figure] = func_figure_scatter(figure_number,matrix_rssi_packet_counter)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hplot = scatter(matrix_rssi_packet_counter(:,1),matrix_rssi_packet_counter(:,2));
    grid on
    xlabel('\bf Anzahl von Paketen');
    ylabel('\bf RSSI');

    set(hplot,'LineWidth',2)
    h_xlabel = get(gca,'XLabel');
    set(h_xlabel,'FontSize',16); 
    h_ylabel = get(gca,'YLabel');
    set(h_ylabel,'FontSize',16); 
    v_test = matrix_rssi_packet_counter(:,2);
    y_ticks_max = max(v_test);
    y_ticks_max_2 = y_ticks_max + mod(y_ticks_max,10);
    if (y_ticks_max_2 == y_ticks_max)
        y_ticks_max = y_ticks_max_2 + 10;
    else
        y_ticks_max = y_ticks_max_2;
    end
    y_ticks_min = 0;
    Ticks_y = y_ticks_min:10:y_ticks_max;
    %set(gca, 'YTick',YTicks)
    set(gca, 'YTickMode', 'manual', 'YTick', Ticks_y, 'ylim', [y_ticks_min,y_ticks_max + 0.5]);
    
    x_ticks_max = max(matrix_rssi_packet_counter(:,1));
    x_ticks_min = min(matrix_rssi_packet_counter(:,1));
    x_ticks_min = x_ticks_min - (10 - mod(x_ticks_min,10));
    Ticks_x = x_ticks_min:1:x_ticks_max;
    set(gca, 'XTickMode', 'manual', 'XTick', Ticks_x, 'xlim', [x_ticks_min,x_ticks_max + 0.5]);
end

