%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article below
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 

%%

function [L, H,SepEf]=balanced_map_partition(r)
if (~isempty(r)) % if the matrix is empty then do not partition
    
[M,N]=size(r);

balance=sum(r,2);

d=M;dmin=M;
sm=0;
for i=1:M % find the row which partition the matrix in two balanced parts as equally as possible
    sm=sm+balance(i);delta=round(abs(i-M/2));
    if sm==0 && delta<dmin
    d=i;dmin=delta;
    end
end

    if d<M
    L=r(1:d,:);H=r(d+1:end,:);
    else
    L=r;H=[]; % if no balanced partition is possible return the same matrix   
    end

% minimum residue enclosing box of L matrix  
minL=0;
if (~isempty(L))
abL=abs(L);
rsum=sum(abL,2);% absolute sum of each row
csum=sum(abL,1);% absolute sum of each column   
rngx=find(csum); %columns which have nonzero entries
rngy=find(rsum); %rows which have non-zero entries
    if (~isempty(rngx))
    minL=(rngx(end)-rngx(1)+1)*(rngy(end)-rngy(1)+1);
    end
end

% minimum residue enclosing box of H matrix  
minH=0;
if (~isempty(H))
abH=abs(H);
rsum=sum(abH,2);% absolute sum of each row
csum=sum(abH,1);% absolute sum of each column   
rngx=find(csum);%columns which have nonzero entries
rngy=find(rsum); %rows which have non-zero entries
    if (~isempty(rngx))
    minH=(rngx(end)-rngx(1)+1)*(rngy(end)-rngy(1)+1);
    end
end
% seperation efficiency
SepEf=(minL+minH)/(N*M);
else
    L=r;H=[];SepEf=1;
end

end
