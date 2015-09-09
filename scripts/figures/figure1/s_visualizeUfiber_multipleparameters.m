function s_visualizeUfiber_multipleparameters(fgfile, t1file, figName, color)

% Visualize U-fiber originated by several different tractography parameters.
% Script used for the visualization of the U-fiber in Figure 1, in 
% Takemura, H., Caiafa, C., Wandell, B. A & Pestilli, F. Ensemble Tractography.
%
% This script requires MBA toolbox by Franco Pestilli
% https://github.com/francopestilli/mba/
% 
% INPUT:
% fgfile: A string of full path to .pdb or .mat file containing fg
%         structure of the U-fiber
% t1file: A full path to t1 weighted image in nifti format (e.g. t1.nii.gz)
% figName: File name used for figure file to be saved.
% color: Color setting for individual fascicle groups. The matrix size
%          should be identical to the size of fgfile. Each column should be
%          N x 3 matrix, which will be used in mbaDisplayConnectome.m
%
% Example:
% fgfile =
% {'Ufiber_ETC_from0p25.pdb','Ufiber_ETC_from0p5.pdb','Ufiber_ETC_from1.pdb'}
% t1file = '/t1/t1.nii.gz';
% figName = 'S1_Ufiber_ETC_Separatecolor.jpg';
% color = {[.5 .5 .9],[.5 .9 .5],[.9 .5 .5]};
% (C) Hiromasa Takemura, Stanford VISTA team 2014

% load U-fiber
for i =1:length(fgfile)
    ufiber{i} = fgRead(fgfile);
end

% Load T1 weighted image of the subject
t1 = niftiRead(t1file);

% Display the fascicles with some colors and dispaly a coplue of brain
% slices

fh = figure;
hold on

% Display sagittal slice of T1 weighted image
mbaDisplayBrainSlice(t1,[-8 0 0]);

% Display U-fiber
for i =1:length(fgfile)
[fh, lightHandle] = mbaDisplayConnectome(ufiber{i}.fibers,fh,color{i},'single');
delete(lightHandle);
end

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