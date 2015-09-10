function s_whitemattercoverage_plot(FileToLoad)

% Plot the white matter coverage in each connectome models averaged across subjects
% 
% % The script will reproduce analysis used in the Figure 4, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT:
% FileToLoad: A full path to .mat file storing white matter coverage proportion in each subject 
%  		(see s_comparewmcoverage.m)
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

% Load files
for i = 1:length(FileToLoad)
    load(FileToLoad{i});
 propvox_all(:,i)= propvoxelcovered;
end

% Compute mean, standard deviation, standard error
propvox_all_mean = mean(propvox_all, 2);
propvox_all_std = std(propvox_all,0,2);
propvox_all_ser = propvox_all_std./sqrt(10);

% Set font size
fontSiz = 16;

% Set the limit of Y axis
h1.ylim(1) = 0.8;
h1.ylim(2) = 1;

% Set the tick of Y axis
ytick = [0.8 0.85 0.9 0.95 1];

% Plot it
bar(propvox_all_mean);

hold on

% Example label on each connectome model
set(gca,'XTickLabel',{'0.25','0.5','1','2','4','ETC'},'fontsize',fontSiz');

    set(gca,'tickdir','out', ...
        'box','off', ...
        'ylim',h1.ylim)

% Put error bar
errorbar(propvox_all_mean,propvox_all_ser,'r','linestyle','none','LineWidth',2);

% Put labels
ylabel('White matter coverage','fontsize',16);
xlabel('Connectome Models','fontsize',16');  

