% tx duration in musec
function y = tx_time(bitrate, shortPA, mac_sz_bytes)
    
    y = zeros(size(bitrate,1), 1);

    for ii=1:size(bitrate,1)
        bits = (mac_sz_bytes(ii) + 4) * 8; % add CRC

        switch (bitrate(ii))
            case 1
                y(ii) = 144 + 48 + bits/bitrate(ii);
            case 2
                y(ii) = 72 + 24 + bits/bitrate(ii);
            case {5.5, 11}
                y(ii) = 72 + 24 + ceil(bits/bitrate(ii));
            case {6, 9, 12, 18, 24, 36, 48, 54}
                y(ii) = 16+4+ceil(bits/(bitrate(ii)*4))*4;
            otherwise
                disp(strcat('Wrong bitrate: ', num2str(bitrate(ii))));
                y(ii) = 0;
        end

        if (shortPA(ii))
            y(ii) = y(ii) + 72 + 24;
        end
    end
end