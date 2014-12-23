function et_writefascicledensity(feFileToLoad, fname, b0file)

% Load fe file and the export the file including fascicle density per
% voxel.
% Reference:
% Takemura, H., Wandell, B.A. & Pestilli, F. (in prep) Ensemble
% Tractography.
%
% INPUT:
% feFileToLoad: A full path to .mat file including fe structure
% fname: The name of output file (.nii.gz format)
% b0file: A full path to nifti files storing MRI data in the identical size
%          and resolution of diffusion data. Typically preprocessed B0 image.
%
% Example:
% feFileToLoad = 'S1_STN96_LH_Frontal_SPC_1_fe.mat';
% fname = 'S1_STN96_LH_Frontal_SPC_1_fiberdensity.nii.gz';
% b0file = '/EnsembleTractography_opendata/data/STN96/S1/S1_STN96_data/diffusion_raw/b0_run01.nii.gz';
%
% (C) Hiromasa Takemura, Stanford VISTA Lab
%

% Load fe structure
load(feFileToLoad);

% Compute fascicle density of optimized conneceome by retaining non-zero
% weight fascicles
fg = feGet(fe,'fibers acpc');
fweight = feGet(fe,'fiber weights');
fweight(fweight > 0) = 1;
fgkeep = fgExtract(fg, transpose(logical(fweight)), 'keep');

% Load b0 image
im = niftiRead(b0file);

% Create an image of fiber density where each voxel counts the number of
% fiber endpoints
fd = dtiComputeFiberDensityNoGUI(fgkeep,im.qto_xyz,size(im.data),0,1,1);

% Now build a nifti image that is coregistered to the B0 image
fdImg = im;
fdImg.data = fd;
fdImg.fname = fname;

% Write the nifti image
niftiWrite(fdImg);
