function s_optimizedconnectomesize_plot(feFileToLoad)
%
% Plot optimized connectome size among several connectome models in multiple subjects
% 
%
% % The script will reproduce analysis used in the Figure 4, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT:
% feFileToLoad: N x M matrix of a full path to .mat file storing fe structure (N: a number of connectome models to test; M: a number of subjects);
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

% Compute optimized connectoms size
for i = 1:size(feFileToLoad,1)
    for k = 1:size(feFileToLoad,2)
    optconnectomesize(i,k) = s_optimizedconnectomesize(feFileToLoad{i,k});
    end
end

% Compute the mean, standard deviation and standard error
optcon_all_mean = mean(optconnectomesize, 2);
optcon_all_std = std(optconnectomesize,0,2);
optcon_all_ser = optcon_all_std./sqrt(size(feFileToLoad,2));

% Set font size 
fontSiz = 16;

% Set the limit of Y axis
h1.ylim(1) = 0;
h1.ylim(2) = 25000;

% Set the tick of Y axis
ytick = [0 5000 10000 15000 20000 25000];

% Plot it
bar(optcon_all_mean);

hold on

% Example of X axis label (describing the type of connectome model)
set(gca,'XTickLabel',{'0.25','0.5','1','2','4','ETC'},'fontsize',fontSiz');

    set(gca,'tickdir','out', ...
        'box','off', ...
        'ylim',h1.ylim)

    errorbar(optcon_all_mean,optcon_all_ser,'r','linestyle','none','LineWidth',2);
    ylabel('Optimized Connectome Size','fontsize',16);
    xlabel('Connectome Models','fontsize',16');  

