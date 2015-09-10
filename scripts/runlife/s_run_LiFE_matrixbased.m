function s_run_LiFE_matrixbased(fg,feSaveName, testVol, saveDir, maxVolDist, diffusionModelParams)
%
% Preprocess a connectome (fg) to be constrained within a
% region of interest and within the cortex.
% 
% This version of scripts use the initial release of LiFE (Pestilli et al., 2014 Nat Methods).
% We plan to release the faster code using vector decomposition in a future release. 
%
% INPUT:
% fg: fg structure of candidate connectome
% feSaveName: filename to store fe structure of the optimized connectome
% testVol: a full path to .mat ROI file of white matter mask
% projectDir: a path to the folder saving output file
% maxVolDist: Max distance in mm from the ROI edges to clip connectomes
% (default: 2mm)
% diffusionModelParams: varargin in feConnectomeInit.m
%
% Hiromasa Takemura (C) 2014 Stanford VISTA team.

if notDefined('diffusionModelParams'),   diffusionModelParams=[1 0];end
if notDefined('maxVolDist'),  maxVolDist = 2;end

% Overwrite files
clobber = 1;

%% Handling parallel processing
poolwasopen=1; % if a matlabpool was open already we do not open nor close one
if (matlabpool('size') == 0), matlabpool open; poolwasopen=0; end


%% DWI data
dataRootPath  = fullfile('/EnsembleTractography_opendata','data','STN96','S1','S1_STN96_data');
subfolders    = fullfile('diffusion_dt6','1st');
baseDir       = fullfile(dataRootPath,subfolders);
dtFile        = fullfile(baseDir,'dt6.mat');
dwiFile       = fullfile(dataRootPath,'diffusion_raw','run01_aligned_trilin.nii.gz');
dwiFileRepeat = fullfile(dataRootPath,'diffusion_raw','run02_aligned_trilin.nii.gz');
t1File        = fullfile(dataRootPath,'t1','t1.nii.gz');

% Load the ROI defining the volume we will use to test the connectome.
volRoi = dtiReadRoi(testVol);
fprintf('Processing: \n %s \n ==================================== \n\n',feSaveName)

%% Set up file names
feSaveDir         = fullfile(saveDir,'fe_structures');

if ~(exist(fullfile(feSaveDir,[feSaveName,feSaveName,'.mat']),'file') == 2) || clobber
    fgSaveName        = fullfile(saveDir,'fg',feSaveName);
    mapSaveNameGlobal = fullfile(saveDir,'maps',sprintf('%s_rRMSE_glob',feSaveName));
    mapSaveNameVoxels = fullfile(saveDir,'maps',sprintf('%s_rRMSE_vxwise',feSaveName));
    
    % Create the necessary folders if they were not there already
    foldersToCheck = {mapSaveNameGlobal,mapSaveNameVoxels,fgSaveName,fullfile(feSaveDir,'tem.mat')};
    checkFolders(foldersToCheck);
    
    %% Clip the connectome to be constrained within the volumeRoi.
    tic, fprintf('Clipping Connectome fibers that leave the volume ROI...\n');
    fg = feClipFibersToVolume(fg,volRoi.coords,maxVolDist);
    fprintf('process completed in %2.3fhours\n',toc/60/60);
    
    %% Build a model of the connectome.
    fe = feConnectomeInit(dwiFile,dtFile,fg,feSaveName,feSaveDir,dwiFileRepeat,t1File,diffusionModelParams);
    
    %% Fit the model with global weights.
    M = feGet(fe,'Mfiber');
    dsig = feGet(fe,'dsig demeaned');
    fefit  = feFitModel(M,dsig,'bbnnls');
    
    fe    = feSet(fe,'fit',fefit);
    feConnectomeSave(fe,feSaveName)
    
    clear fe
    fprintf('DONE processing: \n%s\n ======================================== \n\n',feSaveName)
else
    fprintf('FOUND FILE NOT PROCESSING: \n%s\n ======================================== \n\n\n',feSaveName)
end

% Handling paralle processing.
if ~poolwasopen, matlabpool close; end

end 

%-----------------------%
function fold = checkFolders(foldersToCheck)
% Make sure the folders exist otherwise create them:
for ff = 1:length(foldersToCheck)
    [fold,fil,ext] = fileparts(foldersToCheck{ff});
    if ~( exist(fold,'dir') == 7)
        mkdir(fold)
    end
end
end
