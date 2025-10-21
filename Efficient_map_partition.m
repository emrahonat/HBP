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

function [r1,r2,upd] = Efficient_map_partition(r)
	
	[M,N]=size(r);
	
	[U,D,sefUD]=balanced_map_partition(r);
	[L,R,sefLR]=balanced_map_partition(r');
	
	L=L';
	R=R';
	
	r1=U;
	r2=D;
	upd=1;

	if sefLR<sefUD || ((sefLR==sefUD) && M<N)
		r1=L;
		r2=R;
		upd=0;   
	end

end
