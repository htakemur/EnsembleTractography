function s_comparewmcoverage
% Compare white matter coverage of each optimized connectomes.
% Script used for the visualization in Figure 3b in
% Takemura, H., Wandell, B. A & Pestilli, F. Ensemble Tractography.
%
% This example script test the computation in single hemisphere.
% Group average analysis just requires for repeatingly run the same
% analysis for multiple hemispheres.
%
% Hiromasa Takemura (c) Stanford VISTA team, 2014

% .nii.gz file containing fascicle density in five connectome models
% These files are computed by et_writefascicledensity.m
fiberdensity{1} = 'LH_Occipital_SPC_0p25_fascicledensity.nii.gz';
fiberdensity{2} = 'LH_Occipital_SPC_0p5_fascicledensity.nii.gz';
fiberdensity{3} = 'LH_Occipital_SPC_1_fascicledensity.nii.gz';
fiberdensity{4} = 'LH_Occipital_SPC_2_fascicledensity.nii.gz';
fiberdensity{5} = 'LH_Occipital_ETC_fascicledensity.nii.gz';

% File name to store the key variable in this analysis into .mat file
savefile = 'S1_LH_Occipital_wmcoverage_5models.mat';

% White matter volume files correspond to the white matter regions used for
% LiFE analysis, but resampled into dwi resolution
testVol     = '/ROIs/WMROIs/LH_Occipital_WM_resampletodwi.nii.gz';
vol = niftiRead(testVol);

% This code make a binary decision whether voxel is covered by fascicle or
% not, by thresholding in fascicle density. In this case (fdthreshold =
% 0.99999), the script decides that the voxel is covered by fascicle if the
% fascicle density in the voxel is more than 1.
fdthreshold = [0.9999999999];

for ii=1:length(fdthreshold)
    for i = 1:length(fiberdensity)
        
        fb = niftiRead(fiberdensity{i});
        fbsize = size(fb.data);
        fbcount = 0;
        
        for k=1:fbsize(1)
            for j=1:fbsize(2)
                for p=1:fbsize(3)
                    if vol.data(k,j,p) == 1,
                        if fb.data(k,j,p) > fdthreshold(ii)
                            fbcount = fbcount + 1;
                        else
                        end
                    end
                end
            end
        end
        
        % Number of voxels in white matter mask
        totalwmmask(i,ii) = length(find(vol.data));
        % Number of voxels covered by fascicles supported by LiFE
        voxelcovered(i,ii) = fbcount;
        % Proportion of the white matter coverage
        propvoxelcovered(i,ii) = voxelcovered(i,ii)./totalwmmask(i,ii);
        
        clear fbcount fb fbsize
    end
end
save(savefile, 'totalwmmask','voxelcovered','propvoxelcovered');