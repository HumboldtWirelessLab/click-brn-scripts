function [ ] = get_dijkstra( pdr_path, output_path, mode, s)
%CALC_MST Berechnet den minimalen Spannbaum eines Netzwerkes und gibt ihn
%als Kreise aus
%   pdr_path - Dateipfad der PDR
%   output_path - Dateipfad der Ausgabedatei
%   mode - Genutzter Modus zum erhalten eines ungerichteten Graphen (0 - max,
%   1 - min, 2 - mean)

    H = load(pdr_path,'-ASCII');

    switch mode
      case 0
        H=max(H,H');
      case 1
      	H=min(H,H');
      case 2
      	H=(H+H')/2;
    end

    H(find(H(:) > 200)) = inf;
    H(find(H(:) == 0)) = inf;

    nonodes = size(H,1);

    ac_node = s;
    H(1:nonodes+1:end) = 0; %clear main diag

    pre_nodes = zeros(nonodes,1) + ac_node;
    route_len = H(:,1);

    changes = 1;

    while (changes == 1)
        changes = 0;

        route_len_mat = repmat(route_len, 1, nonodes);

        route_len_mat = route_len_mat + H;

        route_min = min(route_len_mat)';

        better_routes = find((route_min-route_len) < 0);
        better_routes_val = route_min(better_routes);

        for l=1:size(better_routes,1)
             lhop=min(find(route_len_mat(:,better_routes(l)) == better_routes_val(l)));
             route_len(better_routes(l)) = better_routes_val(l);
             pre_nodes(better_routes(l)) = lhop;
        end
        if ( size(better_routes,1) > 0 )
             changes = 1;
        end
        %changes = changes + 1;
    end

    P = [pre_nodes'; [1:nonodes] ]';
    P = P(P(:,2) ~= ac_node,:);

    csvwrite(output_path, P);

end

