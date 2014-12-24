function s_identifyLHILF(feFileToLoad, fname, dtFile)

% This script identify the ILF (in Left hemisphere) from fe structure using AFQ code.
% This script assumes that AFQ ROIs are already determined through AFQ
% pipelines. See http://white.stanford.edu/newlm/index.php/AFQ
%
% INPUT:
% feFileToLoad: a string of full path to .mat file containing fe structure
% fname: The string of filename for output fiber file (.pdb or .mat format)
% dtFile: A full path to dt6.mat file of the subject
%
% feFileToLoad = {'S1_STN96_LH_ILF_SPC_0p25_fe.mat','S1_STN96_LH_ILF_SPC_2_fe.mat'};
% fname = {'LH_ILF_SPC_0p25.pdb','LH_ILF_SPC_2.pdb'}
% dtFile = '/data//S1/S1_STN96_data/diffusion_dt6/dt6.mat';

% (C) Hiromasa Takemura, Stanford VISTA Lab 2014

for i =  1:length(feFileToLoad)
    % Load fe structure
    fprintf('Loading Connectome ...\n')    
    load(feFileToLoad{i});
    
    % Load fascicle weights
    fweight = feGet(fe,'fiber weights');
    fweight(fweight > 0) = 1;
    
    % Remove zero-weight fascicles and make new fe structure without zero
    % fascicles
    fprintf('Removing zero-weight fibers ...\n') 
    [feculled, removedFibers] = feConnectomeReduceFibers(fe, logical(fweight));

    % Get fascicle coordinates information
    fg = feGet(feculled,'fibers acpc');

    % Run AFQ Segmentation based on Mori ROI atlase in AFQ toolbox
    fprintf('Segmenting the Tract from Connectome ...\n')
    fg_classified = AFQ_SegmentFiberGroups(dtFile, fg);
    
    fgnew = fg_classified;
    
    % Select Left ILF: No 13 in AFQ fascicle index
    fgnew.fibers = fg_classified.fibers(fg_classified.subgroup == 13);
    
    % Exclude topological outlier
    fprintf('Excluding outliers from Fasciculus ...\n')
    [fgsegment, keepFascicle3] = mbaComputeFibersOutliers(fgnew,3,3,25);
    
    % Save file
    fgsegment.name = fname{i};
    fgWrite(fgsegment);
    
end