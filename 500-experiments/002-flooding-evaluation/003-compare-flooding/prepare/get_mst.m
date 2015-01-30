function [ ] = get_mst( pdr_path, output_path, mode, s )
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

    nonodes = size(H,1);
    max_edge = max(max(H));
    edgedel = max_edge + 1;

    edgedel = 0;

    H(find(H(:) == 0)) = edgedel;  

    H_mst = zeros(nonodes,nonodes) + edgedel; %max value but it is like delete the edge;

    zerocol = zeros(nonodes,1) + edgedel; %max value but it is like delete the edge
    zerorow = zerocol';

    nodescol = zerocol;
    nodesrow = zerorow;

    ac_node = s;

    in_mst = [ac_node];

    P = [];

    while ( size(in_mst,2) ~= nonodes )

      %copy node and links to mst
      H_mst(ac_node,:) = H(ac_node,:);
      H_mst(:,ac_node) = H(:,ac_node);

      H_mst(ac_node,in_mst) = edgedel;
      H_mst(in_mst,ac_node) = edgedel;

      %delete node in orig. graph
      H(ac_node,:) = nodesrow;
      H(:,ac_node) = nodescol;

      m = min(find(H_mst(:) == max(max(H_mst))))
      ac_node = ceil(m/nonodes)  %we have to start with 0

      find(in_mst(:) == ac_node)
      size(find(in_mst(:) == ac_node))
      size(find(in_mst(:) == ac_node),1)

      if (size(find(in_mst(:) == ac_node),1) == 1)
        con_node = ac_node;
        ac_node = mod(m-1, nonodes)+1;               % matlab start with index 1
      else
        con_node = mod(m-1, nonodes)+1;               % matlab start with index 1
      end

      P = [ P ; [ con_node ac_node ]];
      in_mst = [ in_mst ac_node ];

    end

    P
    size(P)
    csvwrite(output_path, P);
end

