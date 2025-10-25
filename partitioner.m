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

function [mask,old_parts] = partitioner(r,L)

	old_parts=0;
	mask=zeros(size(r));
	
	for l=1:L 
		
		parts=old_parts;
		old_parts=[];
		
		for p=parts
		
			[I,J]=find(mask==p);rp=r(I(1):I(end),J(1):J(end));%select the submatrix corresponding to the part
			
			if(sum(sum(abs(rp)))>2)
				[rp1,rp2,upd]=Efficient_map_partition(rp);
			else
				rp1=rp;rp2=[];upd=1;
			end
		
			p1=10*p+1;p2=10*p+2;%labeling for new partitions
			dmy1=p1*ones(size(rp1));dmy2=p2*ones(size(rp2)); 
			
			if(isempty(dmy1)||isempty(dmy2))
				old_parts=[old_parts,p];
			else
				old_parts=[old_parts,p1,p2];
				if upd
					mask(mask==p)=[dmy1;dmy2];
				else
					mask(mask==p)=[dmy1 dmy2];
				end   
			end        
		end

	end

end
