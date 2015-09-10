function s_makerrmseplot(FileToLoad)

% Plot the median Rrmse averaged across subjects in each connectome models
% The median of Rrmse is computed by the other script
% (s_checkmodelaccuracy_includeallwmvoxel.m).
%
% % The script will reproduce analysis used in the Figure 5b, in
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
%
% INPUT:
% FileToLoad: A full path to .mat files storing the median Rrmse (see
% s_checkmodelaccuracy_includeallwmvoxel.m)
%
% (C) Hiromasa Takemura, CiNet HHS/Stanford Vista Lab, 2015

% Load files
for i = 1:length(FileToLoad)
    load(FileToLoad{i});
    rrmse_all(:,i)= rrmse_median;
end

% Compute mean, standard deviation and standard error
rrmse_all_mean = mean(rrmse_all, 2);
rrmse_all_std = std(rrmse_all,0,2);
rrmse_all_ser = rrmse_all_std./length(FileToLoad);

% Set font size and limit of yaxis
fontSiz = 16;
h1.ylim(1) = 0.707;
h1.ylim(2) = 1;

% Set ticks
ytick = [0.75 0.8 0.85 0.9 0.95 1];

% Plot it
bar(rrmse_all_mean);

hold on
set(gca,'XTickLabel',{'0.25','0.5','1','2','4','ETC'},'fontsize',fontSiz');

set(gca,'tickdir','out', ...
    'box','off', ...
    'ylim',h1.ylim)

% Draw error bar
errorbar(rrmse_all_mean,rrmse_all_ser,'r','linestyle','none','LineWidth',2);
ylabel('Median RRMSE','fontsize',16);
xlabel('Connectome Models','fontsize',16');

