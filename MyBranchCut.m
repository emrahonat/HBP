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

function [mask,maski,maskp] = MyBranchCut(resi)

	maski=Local_Branch_Cut(resi,1);% initial branch cuts for noise related residues which are usually paired and close to each other
	%maski=zeros(size(resi));
	r=(1-maski).*resi; % mask the initial processed residues. Take only remaining ones


	flag_unbalanced=2;

	L=round(log2(length(find(r))));
	display(['Partitioning Level  : ' num2str(L)]);

	if L>=1

		[mask,parts]=partitioner(r,L);%partition residue map down to L levels.

		maskp=mask; % keep labeled partions
		for p=parts
			[I,J]=find(mask==p);rp=r(I(1):I(end),J(1):J(end));%select the submatrix corresponding to the part
			if sum(sum(abs(rp))) % if matrix contains any residue then process
				rp=BestOf4Scan(rp);% connect the residues in balanced groups with serial scanning
			end
			mask(mask==p)=rp; % the corresponding part is processed hence, replaced with result of scanning
		end
		mask=max(maski,mask);% merge ('OR' operation) the processed region with the initial mask (result of Local Branch Cut)

		% post processing for possible unblanced partition (By construction, it can only be the last partition)

		[I,J]=find(mask==flag_unbalanced); % check for connected but an balanced residue group
		[M ,N]=size(resi);K=length(I);
		if (K)
			i1=I(K);j1=J(K);
			mindis=max(M,N);pi=i1;pj=j1;bi=i1;bj=j1;
			for l=1:K
				i=I(l);j=J(l);mask(i,j)=1;% restore 2's to 1 (mask should contain only 1's and 0's)
				if i-1 <= mindis
					pi=i;pj=j;bi=1;bj=j;
					mindis=i-1;
				end
			if M-i <= mindis
				pi=i;pj=j;bi=M;bj=j;
				mindis=M-i;
			end
			if j-1 <= mindis
				pi=i;pj=j;bi=i;bj=1;
				mindis=j-1;
			end
			if N-j <= mindis
				pi=i;pj=j;bi=i;bj=N;
			end          
			end %for l
			mask=connect_points([pi pj], [bi bj],mask);  %connect one residue  of the unbalanced segment to the neraeast border.
		end %if K

	else %if L>=1
		mask=maski;maskp=ones(size(maski));
	end %if L>=1

end
