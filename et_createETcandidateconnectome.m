function et_createETcandidateconnectome(feinput, numconcatenate, fname)

% Create Ensemble Tractography candidate connectome by combining the fascicles from multiple SPC
% optimized connectome having higher fascicle weights.
% 
% Reference:
% Takemura, H., Wandell, B.A. & Pestilli, F. (in prep) Ensemble
% Tractography.
% 
% INPUT:
% feinput: The name (or full path) to fe structure .mat file to put into
%          ET candidate connectomes. 
% numconcatenate: This variable defines how many fascicles from each
%                 connectome shold be included into ET candidate connectomes. 
%                 1 x N matrix.
% fname: File name for output file. 
%
% (C) Hiromasa Takemura, Stanford VISTA Lab
% 
%
% EXAMPLE:
% feinput = {'S1_STN96_LH_Occipital_SPC_0p25_fe.mat',
% 'S1_STN96_LH_Occipital_SPC_0p5_fe.mat',
% 'S1_STN96_LH_Occipital_SPC_1_fe.mat.mat',
% 'S1_STN96_LH_Occipital_SPC_2_fe.mat'}
%  numconcatenate = [40000 40000 40000 40000];
% fname = 'S1_STN96_LH_Occipital_ET_cand.mat';
% et_createETcandidateconnectome(feinput, numconcatenate, fname);

% Argument checking

if length(feinput) == length(numconcatenate)
 error('Matrix size of feinput and numnconcatenate should be identical.');
end

% Load fe structure
for i = 1:length(feinput)
    load(feinput{i});
    % Load fg structure
    fg{i} = feGet(fe,'fibers acpc');
    % Load fascicle weight in optimized connectomes
    fweight{i} = feGet(fe,'fiber weights');
    
    % Sort the order of fascicles based on fascicle weights
    [fgsorted{i}, fgid{i}] = sort(fweight{i},'descend');     
        clear fe    
end

% Create fg structure
fg_etccand = fgCreate;

% Set name for connectome file to save
fg_etccand.name = fname;

% Concatenate connectomes
for i = 1:length(feinput)
    if i == 1
       fg_etcrand.fibers(1:numconcatenate(i)) = fg{1}.fibers(fgid{1}(1:numconcatenate(1)));       
    else
       fg_etcrand.fibers(1+sum(numconcatenate(1:(i-1))):sum(numconcatenate(1:i))) = fg{i}.fibers(fgid{i}(1:numconcatenate(i)));       
        
    end
end

% Save filens
fgWrite(fgnew);
