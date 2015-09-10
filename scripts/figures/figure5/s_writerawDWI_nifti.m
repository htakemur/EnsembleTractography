function s_writedSigMeasured_nifti(feFileToLoad, outname, numb0image, crossvalidate)
% 
% Write nifti files of measured diffusion signal from fe structure
% 
% INPUT:
% feFileToLoad: The full path to a mat file including fe structure
% outname: The nifti file name for output
% numb0image: The number of b0 image in original diffusion measurement. In the case of STN96, this number should be 10.
% crossvalidate: 1, write measured diffusion signal on dataset 1 (used for tractography)
%                2, write measured diffusion signal on dataset 2 (used for cross-validation)
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA team, 2015

for i = 1:length(feFileToLoad)

load(feFileToLoad{1});

% Set volume size
volSiz  = feGet(fe,'volumesize')-[0 0 0 numb0image]; % numb0image = number of b0 image;

% Set xform
xform   = feGet(fe,'xform img 2 acpc');

% Load coordinate
coords  = feGet(fe,'roicoords')-1;

% Load diffusion signal
% crossvalidate = 1; Diffusion dataset 1 (used for tractography)
% crossvalidate = 2; Diffusion dataset 2 (used for cross-validation)
if crossvalidate == 1,
dSig = feGet(fe,'dsigdemeanedvox');
dSigImg = feValues2volume(dSig, coords, volSiz);
elseif crossvalidate == 2,
dSig = feGetRep(fe,'dsigdemeanedvox');
dSigImg = feValues2volume(dSig, coords, volSiz);
end

pSigImgB = nan(size(dSigImg));
pSigImgB(~isnan(dSigImg)) = dSigImg(~isnan(dSigImg));

% Create nifti structure
niP  = niftiCreate('data',pSigImgB,... …
'qto_xyz',xform,...
'fname',outname{1},...
'data_type',class(pSigImgB));

% Save nifti
niftiWrite(niP);
end


