size(show_configs)

show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 3,:);

%remove random and take worst .... use "take best" finally
show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 5,:);
show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 8,:);

show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 4,:);
show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 0,:);

%show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 7,:);
%show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 4,:);

%"fix cs" and "force resp" make no sense
show_configs=show_configs(show_configs(:,CONFIG_FRESP) == 0,:);
show_configs=show_configs(show_configs(:,CONFIG_FIXCS) == 0,:);
show_configs=show_configs(show_configs(:,CONFIG_USEASS) == 0,:);

%use 25ms delay
show_configs=show_configs(show_configs(:,CONFIG_MAXDELAY) == 50,:);

%reject on empty cs to avoid tx on bcast if cs if empty
show_configs=show_configs(show_configs(:,CONFIG_UNICAST_REJECTONEMPTYCS) == 1,:);

%disable txabort feature
show_configs=show_configs(show_configs(:,CONFIG_TXABORT) == 0,:);
%better results but not standard
%show_configs=show_configs(show_configs(:,CONFIG_TXABORT) == 31,:);

show_configs=show_configs(show_configs(:,CONFIG_OVERLAY) == 1,:);

%show_configs
size(show_configs)
