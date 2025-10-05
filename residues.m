%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article below
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 

function [r,dy,dx]=residues(P)
% This function locates the residues in wrapped phase map.
%
% The residues are computed according to reference
% "Dennis C. Ghiglia and Louis A. Romero, Minimum Lp-norm two-dimensional Phase Unwrapping,OSA,1999"
%
% r : is the residue map
% dy: is the vertical   (row index) diference or gradient
% dx: is the horizantal (column index) diference or gradient

[M,N] = size(P);
dy=zeros(M,N);dx=zeros(M,N);r=zeros(M,N);
for i=1:M-1
    for j=1:N
    dy(i,j)=wrap_phase(P(i+1,j)-P(i,j));%gradient in y direction
    end
end
    
for i=1:M
    for j=1:N-1
    dx(i,j)=wrap_phase(P(i,j+1)-P(i,j));%gradient in x direction
    end
end

%residue computation 
for i=1:M-1
    for j=1:N-1
        r(i,j)=round((dy(i,j)-dx(i,j)-dy(i,j+1)+dx(i+1,j))/(2*pi)); %counter clockwise summation    
    end
end
display(['MyBC: # of positive residues :' num2str(length(r(r==1)))])
display(['MyBC: # of negative residues :' num2str(length(r(r==-1)))])

end
