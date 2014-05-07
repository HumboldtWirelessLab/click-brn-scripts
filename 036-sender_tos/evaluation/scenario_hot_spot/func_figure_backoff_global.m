function [handler_figure] = func_figure_backoff_global(figure_number,vector_x,matrix,str_title,str_x,str_y,vector_legend,str_legend_title)
    handler_figure = figure(figure_number);
    set(handler_figure,'units','normalized','outerposition',[0 0 1 1])   % Figure maximieren auf ganzen Bildschirm
    hold all
        hplots = zeros(1,size(matrix,1));
        counter = 0;
        for i = 1:1:size(matrix,1) 
            pos = find(matrix(i,:) == 0); %,1);
            if (isempty(pos))
                pos_size_max = size(matrix,2);
            else
                first_time = 0;
                for t = 1:1:size(pos,2) %search for first double zeros in pos
                    for p = 2:1:size(pos,2)
                        if ((pos(1,t) + 1) == pos(1,p) && first_time == 0)
                            pos_size_max = t-1;
                            first_time = 1;
                        end
                    end
                end
                if (first_time == 0)
                    pos_size_max = size(matrix,2);
                end
            end
            if (pos_size_max > 0)
                if (counter < 7)
                    hplots(1,i) = plot(vector_x(1,1:1:pos_size_max),matrix(i,1:1:pos_size_max),'-x','LineWidth',2);
                    counter = counter + 1;
                elseif (counter >= 7)
                    hplots(1,i) = plot(vector_x(1,1:1:pos_size_max),matrix(i,1:1:pos_size_max),'--','LineWidth',2);
                    counter = counter + 1;
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
        legend_txt  = cell(1,size(vector_legend,2));
        for i=1:1:size(vector_legend,2)
            string = num2str(vector_legend(1,i));
            legend_txt(1,i) = {string};
        end
        handler_legend = legend(hplots,legend_txt,'Location','NorthEastOutside');
        set(get(handler_legend,'title'),'String',{str_legend_title}) 
        set(handler_legend,'FontSize',12)
        set(get(handler_legend,'title'),'FontSize',13,'FontWeight','bold');
     hold off
end
