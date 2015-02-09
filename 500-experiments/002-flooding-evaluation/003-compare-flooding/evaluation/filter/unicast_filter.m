size(show_configs)

show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) ~= 0,:);
show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 2,:);

show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 7,:); 
%show_configs=show_configs(show_configs(:,CONFIG_UNICAST_UCASTPEERMETRIC) == 0,:);

show_configs=show_configs(show_configs(:,CONFIG_MACRETRIES) == 7,:);
show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 5,:);

show_configs=show_configs(show_configs(:,CONFIG_USEASS) == 1,:);
show_configs=show_configs(show_configs(:,CONFIG_FRESP) == 1,:);
show_configs=show_configs(show_configs(:,CONFIG_PIGGYBACK) == 10,:);

show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 4,:);    %TODO: warum hat 4 so ein hohes delay?
show_configs=show_configs(show_configs(:,CONFIG_MAXDELAY) == 50,:);    %TODO: warum hat 4 so ein hohes delay?

size(show_configs)