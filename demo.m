%% Phase unwrapping via hierarchical and balanced residue partitioning
%
% Please cite the article
% Deprem, Z., Onat, E. Phase unwrapping via hierarchical and balanced residue partitioning. Signal, Image and Video Processing, 18, 2895–2902 (2024). https://doi.org/10.1007/s11760-023-02958-5
%
%
% Dr. Zeynel Deprem
% Dr. Emrah Onat (eonat87@yahoo.com)
% 


%% Demo Code of the HBP Phase Unwrapping Algorithm

clear all
close all
clc

%% Display

disp('--- HBP Phase Unwrapping Algorithm ---');


%% Input Images
% 1 - P00 - ifsar.512x512
% 2 - P00 - head.256x256
% 3 - P00 - knee.256x256
% 4 - PCS - longs.152x458 GT
% 5 - PCS - isola.157x458 GT
% 6 - P0S - shear.257x257
% 7 - P0S - spiral.257x257
% 8 - P00 - noise.257x257
% 9 - P00 - peaks.101x101
% 10 -P0S - noisypeaks.101x101
% 11 -P00 - volcano.1591x561
% 12 -P0S - gaussele.100x100
% 13 -P0S - gaussmask.150x100
% 14 -P0S - gaussmask2.150x100
% 15 -P00 - numphant.150x100

I = 'isola';
fid = fopen('isola.157x458.phase','r','b'); 
G = fread(fid, 157*458, 'uchar'); 
G = reshape(G,157,458);
fclose(fid); 
G = 2*pi*G/max(max(abs(G)))-pi;

I = 'shear';
fid = fopen('shear.257x257.phase','r','b'); 
G = fread(fid, 257*257, 'uchar'); 
G = reshape(G,257,257);
fclose(fid);
G = 2*pi*G/max(max(abs(G)))-pi;

phaseimage = G;

figure;
imagesc(phaseimage);title('Input Phase Image');


%% HBP Phase Unwrapping Algorithm

PUAlg = 'HBP';

tic;
[resmap, BCmap, unwrappedmap] = HBP(phaseimage);
duration = toc;
resnumber = length(find(resmap));
BClength = sum(sum(BCmap));
unwrappedmap = unwrappedmap-min(min(unwrappedmap)); unwrappedmap = unwrappedmap/max(max(unwrappedmap)); 
        
figure
subplot(321);imagesc(phaseimage);title(['Input Phase Image, #Input = ' I]);
subplot(322);imagesc(resmap);title(['Residue Map, #Res = ' num2str(resnumber)]);
subplot(323);imagesc(BCmap);title(['Branch-Cut Map, length = ' num2str(BClength)]);
subplot(325);imagesc(unwrappedmap);title('Unwrapped Map');
subplot(326);mesh(unwrappedmap);title(['Unwrapped Map, PU Algo = ' PUAlg]);

%% Duration

Duration = toc;disp(['Duration of the whole process:'  num2str(Duration) ' sn']);


