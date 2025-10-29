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

function [ OUT,I,J ] = zigzag_scan( A )
% zigzag scanning of a matrix.

% A is the input matrix of any size
% OUT is the zigzag scanned matrix values.
% I and J are the vectors containing the vertical and horizantal
% indexes of  original matrix A.
% As an example,
% A =  [1	2	6	7
%		3	5	8	11
%		4	9	10	12];
% [OUT , I, J] = zigzag_scan(A)
% OUT=
%	1     2     3     4     5     6     7     8     9    10    11    12

	OUT=[];I=[];J=[];
	[M,N]=size(A);
	ln=0;
	
	for r=1:M
		ln=ln+1;
		y1=max(1,r-N+1);x1=min(N,r);
		i=r:-1:y1;j=1:x1;L=length(i);
		% v=[];
		% for k=1:L
		%  v=[v A(i(k),j(k))] ;  
		% end
		v=A(sub2ind([M,N],i,j));
		odd=mod(ln,2);
		if(odd==0)
			v=v(end:-1:1);i=i(end:-1:1);j=j(end:-1:1);
		end
		OUT=[OUT v];I=[I i];J=[J j];
	end

	for c=2:N
		ln=ln+1;
		y2=max(c+M-N,1);x2=min(N,M+c-1);
		i=M:-1:y2;j=c:x2;L=length(i);
		% v=[];
		% for k=1:L
		%  v=[v A(i(k),j(k))];   
		% end
		v=A(sub2ind([M,N],i,j));
		odd=mod(ln,2);
		if(odd==0)
			v=v(end:-1:1);i=i(end:-1:1);j=j(end:-1:1);
		end
		OUT=[OUT v];I=[I i];J=[J j];
	end

end
