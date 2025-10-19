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

function Mo=connect_points(d1,d2,M)
% This function connects the points d1 and d2 in a mask matrix M
% Where the connection is obtained by marking the cells between the points(the shortest path connecting two points on discrete map). 
% The Marking is obtained by setting M as 1 at a cell.
Mo=M;
dx=1;dy=1;
if d2(1) < d1(1) 
    dy=0;
end
if d2(2) < d1(2) 
    dx=0;
end

i=d1(1); j=d1(2);
Mo(i,j)=1;
while(i~=d2(1) || j ~= d2(2)) % do until both target indexes are reached 
i=dy*min(i+1,d2(1)) + (1-dy)*max(i-1,d2(1));%depending on relative position of d2 either increase or decrease
j=dx*min(j+1,d2(2)) + (1-dx)*max(j-1,d2(2));
Mo(i,j)=1;
end

end
