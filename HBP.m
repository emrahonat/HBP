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
function [residue_charge, branch_cuts, Unwrapped_3D_Image] = HBP(interferogram)

interferogram=double(interferogram); 
interferogram = interferogram/(max(max(interferogram))/2)-1;
interferogram = interferogram*pi;

%% Residues
[res,dy,dx]=residues(interferogram); % Residue extraction 
nres = length(find(res));

residue_charge = res;

%% Branch-Cuts
[MyBC,MyBCi,MyBCparts] = MyBranchCut(res); % Branch-Cuts Generation
nMyBC = sum(sum(MyBC));

branch_cuts = MyBC;

%% Floodfill
MyU = UnwrapByFloodFill(interferogram,MyBC,100,100); % FloodFill implementation

MyBC(res==-1) = -2; 
MyBC(res==1) = 2;

MyU = MyU-min(min(MyU)); 
MyU = MyU/max(max(MyU)); 

Unwrapped_3D_Image = MyU;


%% End of Function
Duration = toc;disp(['Duration of HBP (Matlab) Algorithm:'  num2str(Duration) ' sn']);

end