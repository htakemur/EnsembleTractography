function s_visualizeILF(fgfile, t1file, figName)

% Visualize ILF defined by several different tractography parameters.
% Script used for the visualization of the ILF in Figure 1, in 
% Takemura, H., Caiafa, C., Wandell, B. A & Pestilli, F. Ensemble Tractography.
%
% This script requires MBA toolbox by Franco Pestilli
% https://github.com/francopestilli/mba/
% 
% INPUT:
% fgfile: A full path to .pdb or .mat file containing fg structure of the ILF
% t1file: A full path to t1 weighted image in nifti format (e.g. t1.nii.gz)
% figName: File name used for figure file to be saved.

% (C) Hiromasa Takemura, Stanford VISTA team 2014

% load ILF
    ilf = fgRead(fgfile);

% Load T1 weighted image of the subject
t1 = niftiRead(t1file);

% Display the fascicles with some colors and dispaly a coplue of brain
% slices

fh = figure;
hold on

% Display sagittal slice of T1 weighted image
mbaDisplayBrainSlice(t1,[-25 0 0]);

% Display ILF 
[fh, lightHandle] = mbaDisplayConnectome(ilf.fibers,fh,[.9 .5 .9],'single');
delete(lightHandle);

% Visualization settings
view(-70,20)
camlight('right')
set(gca,'ylim',[-90 60],'xlim',[-60 45],'zlim',[-30 80])

saveFig(gcf,figName)
end
%------------------------%
function saveFig(h,figName)
fprintf('[%s] saving figure... \n%s\n',mfilename,figName);
if ~exist(fileparts(figName),'dir'),mkdir(fileparts(figName));end

eval( sprintf('print(%s,  ''-djpeg'',''-r500'' , ''-noui'', ''%s'');', num2str(h),figName));

end