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

function [mask] = MyResidueScan(r,zgz)
	
	[M,N]=size(r);mask=zeros(M,N);
	flag_unbalanced=2;
	
	if zgz % if scanning is zigzag 
		[y, I1 ,J1]=zigzag_scan(r);
		I=I1(y~=0);J=J1(y~=0);% take the indexes corresponding the nonzero entries(residues)
	else    % if scanning is vertical(horizantal)
		I=[];J=[];
		for j=1:N
			odd=mod(j,2);frbw = find(r(:,j));n=length(frbw);
			if (odd==0) 
				frbw = frbw(end:-1:1);
			end
			I=[I;frbw];J=[J ;j*ones(n,1)];
		end    
	end   

	L=length(I);
	l=1;balance=0;k=1;
	
	while l<L
		mask=connect_points([I(l) J(l)],[I(l+1) J(l+1)],mask);%connect the residues sequentially. 
		balance=balance+sum(r(I(l),J(l))+r(I(l+1),J(l+1)));
		if balance
			l=l+1;
		else
			l=l+2; % if balnace upto current index is zero then disjoin the current balanced segment and start to a new one.
			k=l; %the starting point of remaining uconnected  residues in rest of scanned list.
		end
	end

	% Precoution for unbalanced partitions(matrices)
	for l=k:L
		mask(I(l),J(l))=flag_unbalanced; % mark the position of connected but unbalanced residues as 2 (different than 1's and =0's) for later processing
	end

end
