function s_comparecurvdistribution

% Compare length distribution of each optimized connectomes.
% Script used for the visualization of the U-fiber in Figure 2, in
% Takemura, H., Wandell, B. A & Pestilli, F. Ensemble Tractography.
%
% Hiromasa Takemura (c) Stanford VISTA team, 2014

% Set the folder name where .mat file including fe sturecure is stored.
connectomeFolder = '/data/STN96/S1/fe/LH_Occipital/';

% Filename for connectome model files to compare in one subject.
% In this case, four SPCs with different curvature threshold (0.25, 0.5, 1,
% and 2 mm) and ETC across them.
% (To compare the distribution in mean, you can just simply load data from
% every hemisphere and simply average results out)
feFileToLoad{1} = 'S1_STN96_LH_Occipital_SPC_0p25_fe.mat';
feFileToLoad{2} = 'S1_STN96_LH_Occipital_SPC_0p5_fe.mat';
feFileToLoad{3} = 'S1_STN96_LH_Occipital_SPC_1_fe.mat';
feFileToLoad{4} = 'S1_STN96_LH_Occipital_SPC_2_fe.mat';
feFileToLoad{5} = 'S1_STN96_LH_Occipital_ETC_fe.mat';

for i = 1:length(feFileToLoad)    
    % Load fe structure
    load(fullfile(connectomeFolder, feFileToLoad{i}));
    
    % Load fascicles
    fg = feGet(fe,'fibers acpc');
    
    %  Keep the fascicles having non-zero weight in LiFE
    % (To compute the distribution in candidate connectomes,
    % you should skip this step)
    fweight = feGet(fe,'fiber weights');
    fweight(fweight > 0) = 1;
    fgkeep = fgExtract(fg, transpose(logical(fweight)), 'keep');
    
    % Compute radius of curvature averaged along single fascicles
    [Cnorm, Curv, Mu, Sigma] = dtiComputeFiberRadiusofCurvatureDistribution(fgkeep,0);
    
    % Remove inf and nan
    Curv = Curv(~isnan(Curv));
    Curv = Curv(~isinf(Curv));
    Curv_can = Curv_can(~isnan(Curv_can));
    Curv_can = Curv_can(~isinf(Curv_can));
    
    % Compute histogram for drawing disribution
    Lengthhist(:,i) = hist(Curv, 0:0.25:20);
    clear fg fe Cnorm Curv   
end

% Set bing
x = [0:0.25:19.75];

% Plot distributions in five connectome models
plot(x,Lengthhist(1:80,1),x,Lengthhist(1:80,2),x,Lengthhist(1:80,3),x,Lengthhist(1:80,4),x,Lengthhist(1:80,5));

% Set the label of axis
ylabel('Number of streamlines','fontsize',16);
xlabel('Mean radius of curvature (mm)','fontsize',16');