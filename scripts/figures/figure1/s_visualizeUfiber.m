function s_visualizeUfiber(fgfile, t1file, figName)

% Visualize U-fiber in occipital cortex defined by several different tractography parameters.
% Script used for the visualization of the U-fiber in Figure 1, in 
% Takemura, H., Caiafa, C., Wandell, B. A & Pestilli, F. Ensemble Tractography.
%
% This script requires MBA toolbox by Franco Pestilli
% https://github.com/francopestilli/mba/
% 
% INPUT:
% fgfile: A full path to .pdb or .mat file containing fg structure of the
%         U-fiber
% t1file: A full path to t1 weighted image in nifti format (e.g. t1.nii.gz)
% figName: File name used for figure file to be saved.

% (C) Hiromasa Takemura, Stanford VISTA team 2014

% load U-fiber
    ufiber = fgRead(fgfile);

% Load T1 weighted image of the subject
t1 = niftiRead(t1file);

% Display the fascicles with some colors and dispaly a coplue of brain
% slices

fh = figure;
hold on

% Display sagittal slice of T1 weighted image
mbaDisplayBrainSlice(t1,[-8 0 0]);

% Display U-fiber 
[fh, lightHandle] = mbaDisplayConnectome(ufiber.fibers,fh,[.5 .5 .9],'single');
delete(lightHandle);

% Visualization settings
set(gca,'ylim',[-80 -5],'xlim',[-60 60],'zlim',[-30 70])
view(-50,-20)
camlight('left')

saveFig(gcf,figName)
end
%------------------------%
function saveFig(h,figName)
fprintf('[%s] saving figure... \n%s\n',mfilename,figName);
if ~exist(fileparts(figName),'dir'),mkdir(fileparts(figName));end

eval( sprintf('print(%s,  ''-djpeg'',''-r500'' , ''-noui'', ''%s'');', num2str(h),figName));

end