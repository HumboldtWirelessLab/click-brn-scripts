table = csvread('gpscoords.csv');
tableSize = size(table);
n = tableSize(1); % zeilen
m = tableSize(2); % spalten
t = 0; %zeit
id = 0; %id vom knoten

%start: hier greift start.sh per sed rein! bei änderungen beachten!
field = zeros(750,750);
fieldDummy = zeros(750,750);
fieldResult = zeros(750,750);
fieldSize = size(field);
gravitation = [400,400];
%ende

radius = 150;
xrange = 65;

knotenInRadius=0;

tobeCovered=0;
covered=0;
abdeckung=0;

%output
absInRadius = 0;
relCoverage = 0;

%initialize field
for I=1:fieldSize(1);
	for J=1:fieldSize(2);
		if ( norm(gravitation - [I,J]) < radius )
			field(I,J) = 1;
		end
	end
end

csvwrite('field.csv', field);

for I=1:n;
	%setup variables
	id = table(I,2);
	pos = [ table(I,3), table(I,4) ];
	xUpper = pos(1) - xrange;
	if ( xUpper < 1 )
		xUpper = 1;
	end
	xLower = pos(1) + xrange;
	if (xLower > fieldSize(1))
		xLower = fieldSize(1);
	end
	yUpper = pos(2) - xrange;
	if (yUpper < 1)
		yUpper = 1;
	end
	yLower = pos(2) + xrange;
	if( yLower > fieldSize(2))
		yLower = fieldSize(2);
	end
	
	
	%compute distance to gravitation
	if (norm(gravitation - pos) < radius)
		knotenInRadius = knotenInRadius + 1;
	end
	
	% compute field for relative coverage
	for I2=xUpper:xLower;
		for J=yUpper:yLower;
			if ( norm(pos - [I2,J]) < xrange )
					fieldDummy(I2,J) = 1;
			end
		end
	end
	
	fieldResult = fieldDummy + fieldResult;

	if ( I == n )
		absInRadius = [absInRadius,knotenInRadius];
		relCoverage = [relCoverage, abdeckung];
	elseif not ( table(I,1) == table(I+1,1) )
		fieldCoverage = fieldResult .* field;
		covered = size(find(fieldCoverage));
		tobecovered = size(find(field));
		abdeckung = covered(1) / tobecovered(1);
		
		absInRadius = [absInRadius,knotenInRadius];
		knotenInRadius = 0;
		
		relCoverage = [relCoverage, abdeckung];
		abdeckung = 0;
		tobeCovered = 0;
		covered = 0;
	end
end

out1 = plot(absInRadius);
saveas(out1, 'KnotenInRadius.jpg');
out2 = plot(relCoverage);
saveas(out2, 'RelativeAbdeckung.jpg');
csvwrite('RelAbdeckung.csv', relCoverage);
csvwrite('InRadius.csv', absInRadius);