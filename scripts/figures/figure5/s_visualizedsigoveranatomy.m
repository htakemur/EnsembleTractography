function s_visualizedsigoveranatomy(dSigNifti,figName, t1file, diffusiondir, slicecoords)
% 
% Visualize the predicted/measured diffusion signal over T1 weighted image
% This script requires MBA toolbox (F. Pestilli; https://github.com/francopestilli/mba)
% 
% % The script will reproduce analysis used in the Figure 5c, in
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT:
% dSigNifti: A full path to nifti files storing measured/predicted diffusion signal
% figName: A image file to save 
% t1file: A full path to T1-weighted nifti file
% diffusiondir: A number(index) of diffusion-gradient direction to visualize 
% slice: A matrix indicates the slice of the image to visuazlize (e.g. [0 -60 0], Sagittal/Coronal/Axial in ACPC)
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015


% Load T1 file
t1 = niftiRead(t1file);

% Resample T1 at the resolution of Diffusion MRI data 
t1resamp = mrAnatResampleToNifti(t1file, dSigNifti{1});

% 
for i = 1:length(dSigNifti)

dSig = niftiRead(dSigNifti{i});

dSigSingledir = dSig;

% Set the gradient direction to visualize signal
dSigSingledir.data = dSig.data(:,:,:,diffusiondir);
dSigSingledir.data(dSigSingledir.data == 0) = NaN;
dSigSingledir.ndim = 3;
dSigSingledir.dim = [dSig.dim(1) dSig.dim(2) dSig.dim(3)];
dSigSingledir.pixdim = [dSig.pixdim(1) dSig.pixdim(2) dSig.pixdim(3)];

% Overlay diffusion signal on T1 weighted
mbaDisplayOverlay(t1resamp, dSigSingledir, slicecoords,[],'jet');
h = colorbar;

% Set the limit of visualization
set(h, 'ylim',[-150 150]);

% Save file, and close window
saveFig(gcf,figName{i});
close all

end

end
%------------------------%
function saveFig(h,figName)
fprintf('[%s] saving figure... \n%s\n',mfilename,figName);
if ~exist(fileparts(figName),'dir'),mkdir(fileparts(figName));end

eval( sprintf('print(%s,  ''-djpeg'',''-r500'' , ''-noui'', ''%s'');', num2str(h),figName));

end
