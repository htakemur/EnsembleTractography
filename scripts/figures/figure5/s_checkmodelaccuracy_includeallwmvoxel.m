function [rrmse_median] = s_checkmodelaccuracy_includeallwmvoxel(feFileToLoad,fname)

% Compute the median of Ratio of root mean squared error (Rrmse) across white matter voxel in Volume of
% interest. If the connectome does not cover the voxel, we assign Inf to the voxel.
% 
% % The script will reproduce analysis used in the Figure 5, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT: 
% feFileToLoad: a full path to .mat files storing fe structure 
% fname: a file name for output (.mat format)
% 
% OUTPUT:
% rrmse_median: median of Rrmse across white matter voxels in each connectome model
% 
% Example:
% feFileToLoad = {'S1_SPC_curv0p25_fe.mat','S1_SPC_curv0p5_fe.mat','S1_SPC_curv1_fe.mat',...
%                'S1_SPC_curv2_fe.mat','S1_SPC_curv4_fe.mat','S1_ETC_fe.mat'};
% fname = 'S1_5models_rrmsemediancomparison.mat';
% s_checkmodelaccuracy_includeallwmvoxel(feFileToLoad,fname)
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

for i = 1:length(feFileToLoad)
load(feFileToLoad{i});

% Load Ratio of RMSE
rmseall{i} = feGetRep(fe, 'voxrmseratio');
coords{i}  = feGet(fe,'roi coords');
mapsize{i} = feGet(fe, 'map size');   
end

% Compute the number of union voxels
[union_coords{1}] = union(coords{1},coords{2},'rows');
for kk=3:(length(feFileToLoad))
[union_coords{kk-1}] = union(union_coords{kk-2},coords{kk},'rows');
end

% Compute maximum voxel size across all connectome models
maxvoxsize = length(union_coords{(length(feFileToLoad)-1)});

% Compute the median of Rrmse
for k = 1:length(feFileToLoad)
    rrmsefixed(1:length(coords{k}),k) = rmseall{k};
    rrmsefixed((length(coords{k})+1):maxvoxsize,k) = Inf;    
    rrmse_median(k) = nanmedian(rrmsefixed(:,k)); 

end

% Save it 
% Save file
if notDefined('fname'),
    return
else
save(fname,'rrmse_median');
end
