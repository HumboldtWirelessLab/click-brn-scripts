function [handler_figure] = func_figure_backoff_packet_global(figure_number,vector_x,matrix,str_title,str_x,str_y)%,vector_legend)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplots = zeros(1,size(matrix,1)); 
        counter = 0;
        for i = 1:1:size(matrix,1) 
            pos = find(matrix(i,:) == 0,1);
            if (isempty(pos))
                pos_size_max = size(matrix,2);
            else
                pos_size_max = pos-1;
            end
            if (pos_size_max > 0)
                if (counter < 7)
                    hplots(1,i) = plot(vector_x(1,1:1:pos_size_max),matrix(i,1:1:pos_size_max),'-x','LineWidth',2);
                    counter = counter + 1;
                elseif (counter >= 7)
                    hplots(1,i) = plot(vector_x(1,1:1:pos_size_max),matrix(i,1:1:pos_size_max),'--','LineWidth',2);
                    counter = counter+ 1;
                end
            end
        end
        grid on
        title(str_title,'FontSize',14,'FontWeight','bold');
        xlabel(str_x);
        ylabel(str_y);
        h_xlabel = get(gca,'XLabel');
        set(h_xlabel,'FontSize',16); 
        h_ylabel = get(gca,'YLabel');
        set(h_ylabel,'FontSize',16); 
        ymax = max(max(matrix)) + 1;
        ylim([0 ymax])
        xmax = max(vector_x) + 1;
        xlim([0 xmax])
     hold off
end

