%
% ACI detector
%
function stats = detect_aci(ydumppart, ph, airTimeCol, ktime_diff_n_samples)
        thr_clock_err = 10e5;
        % not received by commander due to aci (seq) %seimo158 -
        % commander105
        not_recv = setdiff(ydumppart{3}(:,11), ydumppart{1}(:,11));
        
        crc_recv = ydumppart{1}((ydumppart{1}(:,2) == 1),11);

        if ( ~isempty(not_recv) )
            %not received pakets
            det_res_not_recv = zeros(size(not_recv,1),2);
            for ii=1:size(not_recv,1)
                tmp = ydumppart{3}(ydumppart{3}(:,11) == not_recv(ii),[7 airTimeCol]); 
                start_p = tmp(1); %start von phan
                end_p = tmp(1) + tmp(2);

                matched_intv = find((ph(:,3) <= start_p & ph(:,4) > start_p - thr_clock_err) | (ph(:,3) <= end_p & ph(:,4) > end_p - thr_clock_err) | (ph(:,3) >= start_p - thr_clock_err & ph(:,4) <= end_p + thr_clock_err));

                if (~isempty(matched_intv))
                    det_res_not_recv(ii,:) = [not_recv(ii) matched_intv(1)];
                else
                    % ACI detector failed
                    det_res_not_recv(ii,:) = [not_recv(ii) -1];
                end
            end
        end

        if ( ~isempty(not_recv) )
            %error paket 
            det_crc_res = zeros(size(crc_recv,1),2);
            for ii=1:size(crc_recv,1)
                tmp = ydumppart{3}(ydumppart{3}(:,11) == crc_recv(ii),[7 airTimeCol]); 
                start_p = tmp(1) + tmp(2);
                end_p = start_p + ktime_diff_n_samples;

                matched_intv = find((ph(:,3) <= start_p & ph(:,4) > start_p - thr_clock_err) | (ph(:,3) <= end_p & ph(:,4) > end_p - thr_clock_err) | (ph(:,3) >= start_p - thr_clock_err & ph(:,4) <= end_p + thr_clock_err));

                if (~isempty(matched_intv))
                    det_crc_res(ii,:) = [crc_recv(ii) matched_intv(1)];
                else
                    % ACI detector failed                
                    det_crc_res(ii,:) = [crc_recv(ii) -1];
                end
            end
        end
        
        det_res = [ det_res_not_recv ; det_crc_res ];
        
        %Problem: ACI-Pakete, die nichts kaputt machen werden auch erkannt.
        % detection rate: false positive: detector hat was gesehen wo nichts ist
        sended_pak = ydumppart{3}(:,[7 airTimeCol]);
        sended_pak(:,2) = sended_pak(:,1) + sended_pak(:,2);
        
        no_tx = reshape([0; reshape(sended_pak', size(sended_pak,1) * size(sended_pak,2), 1); 1e20],2,size(sended_pak,1)+1)';
        
        wrong_det = 0;
        for ii=1:size(ph,1)
            ph_pak = ph(ii,:);
            matched_intv = find((no_tx(:,1) <= ph_pak(3)) & (no_tx(:,2) > ph_pak(3)));
            
            if (~isempty(matched_intv))
                % wrong detection
                wrong_det = wrong_det + 1;
            end
        end
        
        %ALL
        % false positive rate: detector says yes but there is nothing
        all_false_pos_rate = wrong_det / size(ph,1)
        
        
        % detection rate: true positive: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, wie gut konnte der Detektor dies erkennen
        if ( ~isempty(det_res) )
            failed_total = size(det_res,1);
            all_true_pos_rate = size(det_res(det_res(:,2) > -1),1) / failed_total
        else
            all_true_pos_rate = 0;
        end
     
        % detection rate: false negative: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, hat der Detektor dies nicht erkannt
        if ( ~isempty(det_res) )
            failed_total = size(det_res,1);
            all_false_neg_rate = size(det_res(det_res(:,2) == -1),1) / failed_total
        else
            all_false_neg_rate = 0;
        end


        %MISSED
        % false positive rate: detector says yes but there is nothing
        missed_false_pos_rate = wrong_det / size(ph,1);
        
        
        % detection rate: true positive: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, wie gut konnte der Detektor dies erkennen
        failed_total = size(det_res_not_recv,1);
        missed_true_pos_rate = size(det_res_not_recv(det_res_not_recv(:,2) > -1),1) / failed_total
     
        % detection rate: false negative: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, hat der Detektor dies nicht erkannt
        failed_total = size(det_res_not_recv,1);
        missed_false_neg_rate = size(det_res_not_recv(det_res_not_recv(:,2) == -1),1) / failed_total


        %CRC
        % false positive rate: detector says yes but there is nothing
        crc_false_pos_rate = wrong_det / size(ph,1);
        
        
        % detection rate: true positive: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, wie gut konnte der Detektor dies erkennen
        crc_failed_total = size(det_crc_res,1);
        crc_true_pos_rate = size(det_crc_res(det_crc_res(:,2) > -1),1) / crc_failed_total
     
        % detection rate: false negative: unter Voraussetzung, dass Paket aufgrund von ACI
        % verloren gegangen ist, hat der Detektor dies nicht erkannt
        crc_failed_total = size(det_crc_res,1);
        crc_false_neg_rate = size(det_crc_res(det_crc_res(:,2) == -1),1) / crc_failed_total
      
        
        stats = zeros(4,3); %all, missed, crc, phy
        
        stats(1,:) = [ all_false_pos_rate all_true_pos_rate all_false_neg_rate];
        stats(2,:) = [ missed_false_pos_rate missed_true_pos_rate missed_false_neg_rate];
        stats(3,:) = [ crc_false_pos_rate crc_true_pos_rate crc_false_neg_rate];
        stats(4,:) = [ all_false_pos_rate 1 0];
        
        

end
