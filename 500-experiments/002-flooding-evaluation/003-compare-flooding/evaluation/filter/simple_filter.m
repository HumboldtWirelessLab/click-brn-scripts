size(show_configs)

show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 0,:);
show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 0,:);
show_configs=show_configs(show_configs(:,CONFIG_UNICAST_UCASTPEERMETRIC) == 0,:);

show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 1,:);

show_configs=show_configs(show_configs(:,CONFIG_MAXDELAY) == 50,:);

%1 oder 2
%2-max delay
show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 2,:);

size(show_configs)