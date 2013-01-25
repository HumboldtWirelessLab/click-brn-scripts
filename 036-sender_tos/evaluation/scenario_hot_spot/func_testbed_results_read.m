function [matrix] = func_testbed_results_read(file_txt,no_column_max)
    line ='%d';
    for i=1:1:no_column_max-1
        line = sprintf('%s,%s',line,'%d');
    end
    fid = fopen(file_txt);% öffne Datei
         matrix_txt = textscan(fid,line);% lies Datei ein
    fclose(fid);% schließe Datei
    matrix = cell2mat(matrix_txt);
end
