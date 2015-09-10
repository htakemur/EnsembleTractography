function optconnectomesize = s_optimizedconnectomesize(feFileToLoad, fname)

% This scripts calculates the number of fascicles supported by LiFE (optimized connectome size).
% 
% % The script will reproduce analysis used in the Figure 4, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT: 
% feFileToLoad: A full path to .mat file storing fe structe (defined as string)
% fname: A .mat file name for saving optimized connectome size
% 
% OUTPUT:
% optconnectomesize: A number of fascicles supported by LiFE in each connectome model
% 
% EXAMPLE:
% feFileToLoad = {'S1_SPC_curv0p25_fe.mat', 'S1_SPC_curv0p5_fe.mat', 'S1_SPC_curv1_fe.mat', 'S1_SPC_curv2_fe.mat', 'S1_ETC_fe.mat');
% fname = 'S1_optconnectomesize_5models.mat';
% optconnectomesize =  s_optimizedconnectomesize(feFileToLoad, fname);
%
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

for i = 1:length(feFileToLoad)

       % Load .mat file storing fe sturcture
       load(feFileToLoad{i});

       % Get fascicle weights
       fweight = feGet(fe, 'fiber weights');

       % Count the number of fascicles taking non-zero weight in LiFE model
       optconnectomesize(i) = length(find(fweight>0));
    clear fe fweight
    end
end

% Save file
if notDefined('fname'),
    return
else
save(fname, 'optconnectomesize');
end
