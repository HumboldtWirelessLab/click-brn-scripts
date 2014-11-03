function [ ] = get_dijkstra( pdr_path, output_path, mode )
%CALC_MST Berechnet den minimalen Spannbaum eines Netzwerkes und gibt ihn
%als Kreise aus
%   pdr_path - Dateipfad der PDR
%   output_path - Dateipfad der Ausgabedatei
%   mode - Genutzter Modus zum erhalten eines ungerichteten Graphen (0 - max,
%   1 - min, 2 - mean)

    H = load(pdr_path);

    switch mode
      case 0
        H=max(H,H');
      case 1
      	H=min(H,H');
      case 2
      	H=(H+H')/2;
    end

    H(find(H(:) > 200)) = 10000000;

    nonodes = size(H,1);

    ac_node = 1;

    P = [];

    for i=1:nonodes
      if (i ~= ac_node)
         [shortestPath, totalCost] = dijkstra(H, ac_node, i)
         %size(shortestPath)
         for s=1:size(shortestPath,2)-1
            P = [ P ; [ shortestPath(s) shortestPath(s+1) ]];
         end
      end
    end

    P
    csvwrite(output_path, P);
end

