function s_writedSigPrediction_nifti(feFileToLoad, outname, numb0image)

% The function write a nifti file of predicted diffusion signal from the fe structure 
% 
% INPUT:
% feFileToLoad: The full path to a mat file including fe structure
% outname: The nifti file name for output
% numb0image: The number of b0 image in original diffusion measurement. In the case of STN96, this number should be 10.
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA team, 2015

for i = 1:length(feFileToLoad)

% Load fe files
load(feFileToLoad{i});

% Load volume size
volSiz  = feGet(fe,'volumesize')-[0 0 0 numb0image]; % numb0image = number of b0 image;

% Load xform
xform   = feGet(fe,'xform img 2 acpc');

% Load coordinate
coords  = feGet(fe,'roicoords')-1;

% Load predicted diffusion signal in LiFE
pSig    = feGet(fe,'psigfvox');

% Replace predicted signal in volume coordinate
pSigImg = feValues2volume(pSig,coords,volSiz);
pSigImgB = nan(size(pSigImg));
pSigImgB(~isnan(pSigImg)) = pSigImg(~isnan(pSigImg));

% Create nifti structure
niP  = niftiCreate('data',pSigImgB,... …
'qto_xyz',xform,...
'fname',outname{i},...
'data_type',class(pSigImgB));

% Write nifti
niftiWrite(niP);

end
