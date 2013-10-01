table = csvread('AllDistances.csv');
tableSize = size(table);
n = tableSize(1); % zeilen
m = tableSize(2); % spalten

links = csvread('linktables.csv');
linkSize = size(links);

t = 0; %zeit
id = 0; %id vom knoten

% start: hier greift start.sh per sed rein!
knoten = 9;
% ende

crashes = 0;
crash = [];

%bounds for determining if a link is engaged or not
linkUpperbound = 250;
distanceUpperbound = 85;


%plot histogram about how the distances are distributed
A = table(:,2:m);
A(A==0)=NaN;
A(A>500)=NaN;
N=[0:15:250];
hist(A(:),N);
saveas(gcf, 'DistanceDistribution.jpg');

%determine if Link is established or not
distanceTimeVektor = table(:,1);
distanceLinks = table(:,2:m);
distanceLinks(distanceLinks > distanceUpperbound)=0;
distanceLinks(distanceLinks>0)=1;
distanceLinks = [distanceTimeVektor, distanceLinks];


%build linkmetric matrix
metrikLinks = [];
linkTimeVector = [];
dummyMatrix = zeros(knoten, knoten);

for I=1:linkSize(1)
	from = links(I,2);
	to = links(I,3);
	metrik = links(I,4);
	
	if ( metrik < linkUpperbound )
		dummyMatrix(from,to) = 1;
	end
	
	if ( I == linkSize(1) )
	
	elseif not (links(I,1) == links(I+1,1))
		%generate time-vector
		linkTimeVector = links(I,1)*ones(knoten,1);
		
		%put the data together so it fits the distanceMatrix
		dummyMatrix = [linkTimeVector,dummyMatrix];
		metrikLinks = [metrikLinks;dummyMatrix];
		
		%re-initialize
		dummyMatrix = zeros(knoten, knoten);
		
	end
end

% find links that had been in linktable but not in distanceTable
distanceLinks(1:size(distanceLinks,1)) = distanceLinks(1:size(distanceLinks,1))*2;
diffLinks = distanceLinks - metrikLinks;

faults = 0;
faultseries = [];
distLinks = 0;
distLinkseries = [];
metrikLinksD = 0;
metrikLinkseries = [];

for I=1:size(diffLinks,1)
	for J=2:size(diffLinks,2)
		if( distanceLinks(I,J) > 0 )
			distLinks = distLinks+1;
		end
		if ( diffLinks(I,J) < 0 )
			faults = faults+1;
		end
		if ( metrikLinks(I,J) > 0 )
			metrikLinksD = metrikLinksD+1;
		end
	end
	
	if ( I == size(diffLinks,1) )
	
	elseif not ( diffLinks(I,1) == diffLinks(I+1,1) )	
		faultseries = [faultseries, faults];
		distLinkseries = [distLinkseries, distLinks];
		metrikLinkseries = [metrikLinkseries, metrikLinksD];
		faults = 0;		
		metrikLinksD = 0;
		distLinks = 0;
	end
end

% find crashes
for I=1:n
	for J=2:m
	
		if ( table(I,J) > 0 )
			if ( table(I,J) < 5 )
				crashes = crashes+1;
			end
		end	
		
	end
	
	if ( I == n )
	
	elseif not ( table(I,1) == table(I+1,1))
		
		crash = [crash,crashes];
		crashes = 0;
		
	end
end

%output area
out1 = plot(crash);
saveas(out1, 'Crashes.jpg');

out2 = plot(faultseries);
saveas(out2, 'WrongLinks.jpg');
out3 = plot(metrikLinkseries);
saveas(out3, 'metrikLinkseries.jpg');
out4 = plot(distLinkseries);
saveas(out4, 'distLinkseries.jpg');