function s_plot_distributionoffascicledensity_2condition(filetoLoad)

% Plot the histogram of fascicle density in two connectome models, averaged across subjects
%
% %
% % The script will reproduce analysis used in the Figure 4c, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% INPUT:
% filetoLoad: A full path to .mat file produced by s_comparefascicledensity_2cond.m
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

for i = 1:length(filetoLoad)
    
    % Load fles
    load(filetoLoad{i});
    
    % Set bin
    bins = [0:1:1000];
    
    % Compute the histogram for first connectome model (e.g. SPC 2mm)
    hist_SPC(:,i) = hist(fbdensity(:,1),bins);

    % Compute the histogram for second connectome model (e.g. ETC)
    hist_ETC(:,i) = hist(fbdensity(:,2),bins);
end

SPC_all_mean  = mean(hist_SPC,2);
ETC_all_mean  = mean(hist_ETC,2);

% set bin for a plot
x = [0:1:60];

% plot it 
plot(x, SPC_all_mean(1:61), x, ETC_all_mean(1:61));
xlabel('Number of voxels','fontsize',16);
ylabel('Number of fascicles per voxel','fontsize',16);





