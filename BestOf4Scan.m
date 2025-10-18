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

function [maskr,bc_length]=BestOf4Scan(r)
% This function computes the branch cuts with 4 different scanning
% orientation and then select the one whith minimum branch length(norm)

% For the sake of efficiency, only the area where residues are available is
% selected and processed. The following lines are for this purpose.
[I,J]=find(r);res=r(min(I):max(I),min(J):max(J));% take only the enclosing box covering all residues.
nr=sum(sum(abs(res)));
flag_unbalanced=2;

if nr>2 %if number of residues is greater than 2
MyBCSQ1=MyResidueScan(res,0);n1=sum(sum(abs(MyBCSQ1)));% scan vertical
MyBCSQ2=MyResidueScan(res',0);MyBCSQ2=MyBCSQ2';n2=sum(sum(abs(MyBCSQ2)));% scan horizantal
MyBCDG1=MyResidueScan(res,1);n3=sum(sum(abs(MyBCDG1)));% scan zigzag 45 deg.
MyBCDG2=MyResidueScan(fliplr(res),1);MyBCDG2=fliplr(MyBCDG2);n4=sum(sum(abs(MyBCDG2)));% scan zigzag -45 deg.

mask=MyBCSQ1;n=n1;
    if n2<n 
     mask=MyBCSQ2;n=n2;
    end
    if n3<n 
     mask=MyBCDG1;n=n3;
    end
    if n4<n 
     mask=MyBCDG2;n=n4;
    end

else % if number of residues is smaller than 2 
mask=zeros(size(res));
[I2,J2]=find(res);
    if nr==1
    mask(I2(1),J2(1))=flag_unbalanced; % Since there is only one residue mark it as unbalanced.
    else % nr==2
        mask=connect_points([I2(1) J2(1)], [I2(2) J2(2)],mask);% if the number of residues is 2 just connect them
        if res(I2(1),J2(1))==res(I2(2),J2(2)) % if both residues have the same polarity
        mask(I2(1),J2(1))=flag_unbalanced;mask(I2(2),J2(2))=flag_unbalanced;    
        end
    end
end

maskr=zeros(size(r));
maskr(min(I):max(I),min(J):max(J))=mask;

end
