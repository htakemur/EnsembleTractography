function s_makeplotfasciclecurvature_onesubj(FileToLoad)

% Plot the distribution of mean curvature radius of fascicles in each connectome models.
% The script will reproduce the Figure 3, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% This script assumes to compare the distribution among 6 different connectomes. 
%
% INPUT: 
% FileToLoad: .mat file storing fascicle curvature distribution in each connecome model 
% 		(see s_comparecurvdistribution_spline.m)
%
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015


load(FileToLoad);
Curvhist_can_all(1:161,:) = Curvhist_can(1:161,:);
Curvhist_opt_all(1:161,:) = Curvhist_opt(1:161,:);

% set bin
x = [0:0.25:39.75];

% Plot the curvature distribution in candidate connectome
plot(x,Curvhist_can_all(1:160,1),x,Curvhist_can_all(1:160,2),x,Curvhist_can_all(1:160,3),x,Curvhist_can_all(1:160,4),x,Curvhist_can_all(1:160,5),x,Curvhist_can_all(1:160,6));

% set the label of axis
ylabel('Number of fascicles','fontsize',16);
xlabel('Mean Radius of Curvature','fontsize',16);

figure(2)
% Plot the curvature distribution in optimized connectome
plot(x,Curvhist_opt_all(1:160,1),x,Curvhist_opt_all(1:160,2),x,Curvhist_opt_all(1:160,3),x,Curvhist_opt_all(1:160,4),x,Curvhist_opt_all(1:160,5),x,Curvhist_opt_all(1:160,6));

% set the label of axis
ylabel('Number of fascicles','fontsize',16);
xlabel('Mean Radius of Curvature','fontsize',16);
