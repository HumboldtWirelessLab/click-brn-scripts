%RSSI_Max = 60
%Convert % to RSSI
%Subtract 95 from RSSI to derive dBm
%Notice that this gives a dBm range of �35dBm at 100% and �95dBm at 0%.

%Notice: for Madwifi: RSSI is actually equals to SNR (see:
%madwifi-project.org/wiki/UserDocs/RSSI)


function y = convert_rssi_to_dbm_atheros(x,noise)

RSSI_MAX = 60;

x = min(x, RSSI_MAX);

y = x + noise;

end
