function floodstats_info(filename)

NUM=1;

TXNODE=2;
RXNODE=3;
SRCNODE=4;
PACKETSIZE=5;


PACKETCOUNT=11;
FLOODINGID=12;
NOFWD=13;

NOSENT=14;   % <<----- number of sent copies (MAC)

FWD=15;
RESP=16;
FORRESP=17;
RXACKED=18;
RCVCNT=19;


FWDDONE=20;
FWDSUCC=21;
FINRESP=22;
TIME=23;     % <<------ RX time of the first pkt of the flooding

SIM=24;
UNICASTSTRATEGY=25;
PLACEMENT=26;
UNICAST_PRESELECTION_STRATEGY=27;
UNICAST_REJECTONEMPTYCS=28;
UNICAST_UCASTPEERMETRIC=29;
FLOODING_NET_RETRIES=30;


ALGORITHMID=31;
EXTRAINFO=32;
UNICASTSTRATEG=33;

COLLISIONS=34;
MACRETRIES=35;
NBMETRIC=36;
PIGGYBACK=37;
FRESP=38;
USEASS=39;
MAXDELAY=40;

SEED=41;
TXABORT=42;
FIXCS=43;

plot = 1;
s1 = 3;
s2 = 18;

data=load(filename);
size(data)

% UNICASTSTRATEGY
% UNICAST_PRESELECTION_STRATEGY
% UNICAST_REJECTONEMPTYCS
% UNICAST_UCASTPEERMETRIC
% FLOODING_NET_RETRIES
% ALGORITHMID (simple/mpr/prob)
% EXTRAINFO (Algo, e.g. probab)
% MACRETRIES
% NBMETRIC

data=[ data';zeros(1,size(data,1)) ]';

%PARAMETER
%        1                           2                       3                         4                       5                6        7          8        9         10      11     12        13     14     15
params=[UNICASTSTRATEGY UNICAST_PRESELECTION_STRATEGY UNICAST_REJECTONEMPTYCS UNICAST_UCASTPEERMETRIC FLOODING_NET_RETRIES ALGORITHMID EXTRAINFO  MACRETRIES NBMETRIC PIGGYBACK FRESP USEASS MAXDELAY TXABORT FIXCS];

params_value=unique(data(:,params),'rows')

params_value
size(params_value)

for r = 1:size(params_value,1)
    
    p=params_value(r,:);
       
    simids=data(strmatch(p,data(:,params)),NUM);
    size(unique(simids))

end

end