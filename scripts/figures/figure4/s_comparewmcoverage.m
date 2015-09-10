function [totalwmmask, voxelcovered, propvoxelcovered] = s_comparewmcoverage(fascicledensity, testVol, fname,fdthreshold)

% This scripts computes the statistics of white matter coverage for each connectome model.
% The nifti file storing fascicle density should be pepared by using et_writefascicledensity.m
%
% % The script will reproduce analysis used in the Figure 4, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
%
% INPUT:
% fascicledensity: A full path to .nii.gz file storing fascicle density (see et_writefascicledensity.m)
% testVol: White matter mask used for tractography (.nii.gz format).
% fname: File name for saving the output (.mat format)
% fdthreshold: The threshold for counting the white matter coverage; if the white matter voxel has higher fascicle density 
% 	       than threshold, the code counts the voxel as covered by connectome model. Default = 0.9999999999.
%
% OUTPUT:
% totalwmmask: A number of voxels in white matter mask
% voxelcovered: A number of voxel covered by connectome model
% propvoxelcovered: A proportion of voxels in white matter mask covered by connectome model
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

if notDefined('fdthreshold'),
fdthreshold = [0.9999999999];
else
end

% Load white matter mask
vol = niftiRead(testVol);

% Count white matter coverage
for ii=1:length(fdthreshold)
for i = 1:length(fascicledensity)

 % Load fascicle density
 fb = niftiRead(fascicledensity{i});
 fbsize = size(fb.data);
 
 fbcount = 0;
 
 for k=1:fbsize(1)
     for j=1:fbsize(2)
         for p=1:fbsize(3)
         if vol.data(k,j,p) == 1,
	     % If the fascicle density in the voxel is above threshold, we count the voxel
             if fb.data(k,j,p) > fdthreshold(ii)
             fbcount = fbcount + 1;
             else
             end
         end
         end
     end
 end

% Compute the white matter coverage
totalwmmask(i,ii) = length(find(vol.data));
voxelcovered(i,ii) = fbcount;
propvoxelcovered(i,ii) = voxelcovered(i,ii)./totalwmmask(i,ii);

clear fbcount fb fbsize
end
end

% Save file
if notDefined('fname'),
    return
else
save(fname, 'totalwmmask','voxelcovered','propvoxelcovered');
end

