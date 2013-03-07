function time_analyze(pktfile)

ydump = load(pktfile);

if (isempty(ydump))
    ydump = zeros(2,11);
end


size(ydump)
unique(ydump(:,5))
ydump = ydump((ydump(:,5) == 69) & ((ydump(:,1) == 0)),:);
size(ydump)

ktimereg = ydump(:,7);
ktimereg = ktimereg(:) - ktimereg(1)
mactimereg = ydump(:,12);
mactimereg = mactimereg(:) - mactimereg(1)
systimereg = ydump(:,13);
systimereg = systimereg(:) - systimereg(1)

seq = ydump(:,11)

%4095
for i = 2:size(seq)
  if ( seq(i) < seq(i-1) )
    seq(i) = seq(i) + 4096;
  end
end


plot(seq,ktimereg);
figure;
plot(seq,mactimereg);
figure;
plot(seq,systimereg);

figure;
plot(mactimereg,systimereg);
figure;
plot(mactimereg,ktimereg);


end