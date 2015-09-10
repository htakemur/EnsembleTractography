function s_run_LiFE_multiway(fgFileName, feFileName)

% This script runs LiFE (the version commited by C.Caiafa, using multi-way vector decomposition) on
% connectomes.
% This script will requires the latest version of LifE code, which has not released yet. 
% 
% INPUT:
% fgFileName: fg file storing connectome to test
% feFileName: filename to store fe structure of the optimized connectome
% 

% Set path to DWI data 
dataRootPath  = fullfile('/EnsembleTractography_opendata','data','STN96','S1','S1_STN96_data');
subject = 'S1';
dwiFile       = deblank(ls(fullfile(dataRootPath,subject,'diffusion_data','*run01*.nii.gz')));
dwiFileRepeat = deblank(ls(fullfile(dataRootPath,subject,'diffusion_data','*run02*.nii.gz')));
t1File        = deblank(fullfile(dataRootPath,subject,'anatomy',  't1.nii.gz'));
N = 360;

% Building LiFE  (construct tensor representations)
tic

for i = 1:length(feFileName)
fe = feConnectomeInit_New(dwiFile,fgFileName{i},feFileName{i},[],dwiFileRepeat,t1File,N,[1,0],0);
disp(' ')
disp(['Time for model construction NEW LiFE_BD PROB','(N=',num2str(N),'=',num2str(toc)]);

% Fit the LiFE model with TENSOR (Optimization)
tic
opt       = solopt;
opt.maxit = 500;
opt.use_tolo = 1;
fit = feFitModel_test_niter(fe.life.M,feGet(fe,'dsigdemeaned'),'bbnnls',opt);
fe  = feSet(fe,'fit',fit);
disp(' ')

% Save Results
disp('SAVING RESULTS...')
save(feFileName{i},'fe','-v7.3');
clear fe

end



rmpath(genpath(new_LiFE_path))
