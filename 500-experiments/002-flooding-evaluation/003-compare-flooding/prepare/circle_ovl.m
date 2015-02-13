function circle_ovl( pdr_path, output_path, limit )
%circle_ovl Calculates a circle_overlay for the given pair of PDR and
%placment
%   pdr_path - Path to the PDR-file
%   placement_path - Path to placement-file

pdr=load(pdr_path,'-ASCII');
plm=[];
n=length(pdr);
no_permutation=50000;

%{
if (min(max(pdr'))<limit)
   disp('Graph is not connected')
   return
end
%}

%f_plm=fopen(placement_path,'r');
%while ~feof(f_plm)
%    fscanf(f_plm,'%s',1);
%    A = fscanf(f_plm,'%d %d %d',3);
%    if (isempty(A))
%        break
%    end
%    plm=[plm;[A(1) A(2)]];
%end

%K=convhull(plm(:,1),plm(:,2));
%plot(plm(:,1),plm(:,2),'r*',plm(K,1),plm(K,2),'b-')

comps=UnionFind(n);
round=0;
akt=zeros(n,1);
col=hsv(10);

P = [];
P_PDR = [];


%hold off;
while ~comps.connected()
   if round==0
       x=ceil(rand*n);
   else
       pos=1:n;
       pos=pos(akt==0);
       if isempty(pos)
           break;
       end
       x=pos(ceil(rand*length(pos)));
   end
   akt(x)=1;
   round=round+1;
   aakt=zeros(n,1);
   agg=x;
   while true
       %TODO: Prüfen, welche Variante besser ist!
       %pos_l=(pdr(:,x)>limit).*(1-aakt).*(1-akt);
       pos_l=(pdr(:,x)>limit).*(1-aakt);
       pos=1:n;
       pos=pos(pos_l==1);
       if isempty(pos)
           break
       end
       p=pos(ceil(rand*length(pos)));
       aakt(p)=1;
       if min(min(pdr([agg p],[agg p])+eye(length(agg)+1)*100))>limit
           agg=[agg p];
           comps.union(x,p);
           akt(p)=1;
       end
   end
   %disp(agg)
   k=length(agg);
   %ps=perms(agg);
   if (k<10)
       ps=[agg(1)*ones(factorial(k-1),1) perms(agg(2:k))];
   else
       f=@(x)(agg(randperm(k)));
       ps=ones(no_permutation,k);
       for i=1:no_permutation
           ps(i,:)=f(0);
       end
   end
   ps=[ps ps(:,1)];
   vals=prod((pdr(ps(:,1:k)+n*(ps(:,2:(k+1))-1))),2);
   val=max(vals);
   %disp(val);
   opt=ps(vals==val,:);
   opt=opt(1,:);
   %plot(plm(opt,1),plm(opt,2),'Color',col(ceil(rand*10),:));
   %hold on;
   if (k>1)
    for k_i = 0:(k-1)
       P = [ P ; [ opt(k_i+1) opt(mod((k_i+1),k) + 1)]]; 
       P_PDR = [ P_PDR ; [ opt(k_i+1) opt(mod((k_i+1),k) + 1) pdr(opt(k_i+1),opt(mod((k_i+1),k) + 1)) pdr(opt(mod((k_i+1),k)+ 1),opt(k_i+1))]];
    end
    opt(k+1)=-1;
    %disp(opt)
   end
end

while ~comps.connected()
   par=arrayfun(@comps.getParent,1:n);
   u_par=unique(par);
   i=u_par(ceil(rand*length(u_par)));
   pos=1:n;
   vals=pdr(pos(par==i),pos(par~=i));
   val=max(max(vals));
   ins=pos(par==i);
   out=pos(par~=i);
   if (size(vals,2)>1)
      b_i=ins(max(vals')==val);
   else
      b_i=ins(vals==val);
   end
   b_i=b_i(1);
   b_j=out(vals(ins==b_i,:)==val);
   %b_j=out(vals(:,ins==b_i)==val);
   b_j=b_j(1);
   
   pair=[b_i b_j];
   P = [ P ; [ pair(1) pair(2) ]];
   P = [ P ; [ pair(2) pair(1) ]];
   P_PDR = [ P_PDR ; [ pair(1) pair(2) pdr(pair(1),pair(2)) pdr(pair(2),pair(1))]];
   P_PDR = [ P_PDR ; [ pair(2) pair(1) pdr(pair(1),pair(2)) pdr(pair(2),pair(1))]];

   disp([pair -1])
   %plot(plm(pair,1),plm(pair,2),'r--');
   comps.union(b_i,b_j);
end

%hold off;
%plot(plm(:,1),plm(:,2),'b*')
%axis equal
%hold off;
%{
hold off;
plot(plm(:,1),plm(:,2),'b*')
hold on;
K=convhull(plm(agg,1),plm(agg,2));
plot(plm(agg,1),plm(agg,2),'r*',plm(agg(K),1),plm(agg(K),2),'r-')
plot(plm(x,1),plm(x,2),'g*')
hold off;
%}


test_m = zeros(size(pdr,1),size(pdr,1));

for i = 1:size(P,1)
  test_m(P(i,1),P(i,2)) = 1;
  if ( pdr(P(i,1),P(i,2)) < 50 )
      disp('Fehler')
  end
end

size(test_m)
%csvwrite('t', test_m);

partitions(test_m)

P
csvwrite(output_path, P);

end

