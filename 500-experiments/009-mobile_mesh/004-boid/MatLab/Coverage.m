table = csvread('gpscoords.csv');
tableSize = size(table);
n = tableSize(1); % zeilen
m = tableSize(2); % spalten
t = 0; %zeit
id = 0; %id vom knoten

%start: hier greift start.sh per sed rein! bei änderungen beachten!
fieldInRadius = zeros(750,750);
fieldMidRadius = zeros(750,750);
fieldOutRadius = zeros(750,750);

fieldDummy = zeros(750,750);
fieldResult = zeros(750,750);
fieldSize = size(fieldMidRadius);
gravitation = [400,400];
knoten = 9;
xrange = 65;
%ende

%todo: make radiant depeding on xrange!
%IMPORTANT: inRadius < midRadius < outRadius has to be true!
inRadius = 100;
midRadius = 200;
outRadius = 350;

%initialize knot-counting variables
knotsInRadius=0;
knotsMidRadius=0;
knotsOutRadius=0;

%initialize coverage-measuring variables
tobeCovered=0;
covered=0;
coverage=0;

%output
absInRadius = 0;
absMidRadius = 0;
absOutRadius = 0;

covInRadius = 0;
covMidRadius = 0;
covOutRadius = 0;

coordMatrix = [];
distMatrix = [];

%initialize fields
for I=1:fieldSize(1);
	for J=1:fieldSize(2);
		within = norm(gravitation - [I,J]);
		if ( within < inRadius )
			fieldInRadius(I,J) = 1;
			fieldMidRadius(I,J) = 1;
			fieldOutRadius(I,J) = 1;
		elseif ( within < midRadius )
			fieldMidRadius(I,J) = 1;
			fieldOutRadius(I,J) = 1;
		elseif ( within < outRadius )
			fieldOutRadius(I,J) = 1;
		end
	end
end

for I=1:n;
	%setup variables
	t = table(I,1);
	id = table(I,2);
	pos = [ table(I,3), table(I,4) ];
	
	coordMatrix = [coordMatrix;[id,pos]];
	
	%setup upper and lower bounds for searching through the field
	%for performance improvement
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
	
	
	%compute distances to gravitation
	distance = norm(gravitation - pos);
	if( distance < inRadius )
		knotsInRadius = knotsInRadius + 1;
		knotsMidRadius = knotsMidRadius + 1;
		knotsOutRadius = knotsOutRadius + 1;	
	elseif ( distance < midRadius)
		knotsMidRadius = knotsMidRadius + 1;
		knotsOutRadius = knotsOutRadius + 1;
	elseif ( distance < outRadius )
		knotsOutRadius = knotsOutRadius + 1;
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
		%absInRadius = [absInRadius,knotsInRadius];
		%absMidRadius = [absMidRadius,knotsMidRadius];
		%absOutRadius = [absOutRadius,knotsOutRadius];
		
		%covInRadius = [covInRadius, coverage];
		%covMidRadius = [covMidRadius, coverage];
		%covOutRadius = [covOutRadius, coverage];
		
	elseif not ( table(I,1) == table(I+1,1) )
		
		%compute distances and possible crashes
		coordMatrix = sortrows(coordMatrix, 1);
		cmsize = size(coordMatrix);
		dvector = t;
		dMatrixDummy = [];
		
		for CMX=1:cmsize(1)
			for CMY=1:cmsize(1)
				dvector = [dvector, norm([coordMatrix(CMX,2),coordMatrix(CMX,3)] - [coordMatrix(CMY,2),coordMatrix(CMY,3)])];
			end
			dMatrixDummy = [dMatrixDummy;dvector];
			dvector = t;
		end
		distMatrix = [distMatrix;dMatrixDummy];
		
		%relative coverage computation
		fieldCoverage = fieldResult .* fieldInRadius;
		covered = size(find(fieldCoverage));
		tobecovered = size(find(fieldInRadius));
		coverage = covered(1) / tobecovered(1);
		covInRadius = [covInRadius, coverage];
		
		fieldCoverage = fieldResult .* fieldMidRadius;
		covered = size(find(fieldCoverage));
		tobecovered = size(find(fieldMidRadius));
		coverage = covered(1) / tobecovered(1);
		covMidRadius = [covMidRadius, coverage];

		fieldCoverage = fieldResult .* fieldOutRadius;
		covered = size(find(fieldCoverage));
		tobecovered = size(find(fieldOutRadius));
		coverage = covered(1) / tobecovered(1);
		covOutRadius = [covOutRadius, coverage];		
		
		%compute absolute knots in midRadius
		absInRadius = [absInRadius,knotsInRadius];
		absMidRadius = [absMidRadius,knotsMidRadius];
		absOutRadius = [absOutRadius,knotsOutRadius];

		
		%re-initialize everything
		coordMatrix = [];
		knotsInRadius=0;
		knotsMidRadius=0;
		knotsOutRadius=0;
		
		coverage = 0;
		
		tobeCovered = 0;
		covered = 0;
		
		
	end
end

%output area

plot(absInRadius);
title('Absolute Anzahl von Knoten im Radius von 100m');
xlabel('Zeit t');
ylabel('Anzahl der Knoten');
saveas(gcf, 'KnotsInRadius.jpg');

plot(absMidRadius);
title('Absolute Anzahl von Knoten im Radius von 200m');
xlabel('Zeit t');
ylabel('Anzahl der Knoten');
saveas(gcf, 'KnotsMidRadius.jpg');

plot(absOutRadius);
title('Absolute Anzahl von Knoten im Radius von 350m');
xlabel('Zeit t');
ylabel('Anzahl der Knoten');
saveas(gcf, 'KnotsOutRadius.jpg');


plot(absInRadius);
hold on;
plot(absInRadius);
hold on;
plot(absInRadius);
hold off
title('Absolute Anzahl von Knoten in allen Radien');
legend('Radius 100m','Radius 200m','Radius 350m');
xlabel('Zeit t');
ylabel('Anzahl der Knoten');
saveas(gcf, 'KnotsAllRadius.jpg');


plot(covInRadius);
hold on;
plot(covMidRadius);
hold on;
plot(covOutRadius);
hold off
title('Relative Abdeckung durch die Knoten in allen Radien');
legend('Radius 100m','Radius 200m','Radius 350m');
xlabel('Zeit t');
ylabel('% - Abdeckung');
saveas(gcf, 'RelCovAllRadius.jpg');



plot(covInRadius);
title('Relative Abdeckung vom Radius 100m');
xlabel('Zeit t');
ylabel('% - Abdeckung');
saveas(gcf, 'RelCovInRadius.jpg');

plot(covMidRadius);
title('Relative Abdeckung vom Radius 200m');
xlabel('Zeit t');
ylabel('% - Abdeckung');
saveas(gcf, 'RelCovMidRadius.jpg');

plot(covOutRadius);
title('Relative Abdeckung vom Radius 350m');
xlabel('Zeit t');
ylabel('% - Abdeckung');
saveas(gcf, 'RelCovOutRadius.jpg');

csvwrite('RelCovInRadius.csv', covInRadius);
csvwrite('RelCovMidRadius.csv', covMidRadius);
csvwrite('RelCovOutRadius.csv', covOutRadius);
csvwrite('KnotsInRadius.csv', absInRadius);
csvwrite('KnotsMidRadius.csv', absMidRadius);
csvwrite('KnotsOutRadius.csv', absOutRadius);

csvwrite('AllDistances.csv', distMatrix);

