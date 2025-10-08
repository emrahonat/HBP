%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article below
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 

function wph=wrap_phase(ph)
%wph=atan2(sin(ph),cos(ph));%the fastest one :)
wph=mod(ph+pi,2*pi)-pi;% from some papers (to get value between -pi <= phase <pi)
%wph=wrapToPi(ph);
end
