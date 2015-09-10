function [fbdensity_comparison] = s_comparefascicledensity_2cond(fascicledensity, testVol, fname);

% This script compares the fascicle density across two different connectome model.
% %
% % The script will reproduce analysis used in the Figure 4c, in 
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
% 
% INPUT:
% fascicledensity: A full path to .nii.gz file storing fascicle density (see et_writefascicledensity.m)
% testVol: White matter mask used for tractography (.nii.gz format).
% fname: File name for saving the output (.mat format)
% 
% fbdensity_comparison: A Nx2 matrix storing the fascicle density across 2 connectome models within white matter mask
% 
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab, 2015

vol = niftiRead(testVol);

 fb1 = niftiRead(fascicledensity{1});
 fb2 = niftiRead(fascicledensity{2});
 fbsize = size(fb1.data);
 
 fbcount = 1;
 
 for k=1:fbsize(1)
     for j=1:fbsize(2)
         for p=1:fbsize(3)
         if vol.data(k,j,p) == 1,
         fbdensity_comparison(fbcount,1) = fb1.data(k,j,p);
         fbdensity_comparison(fbcount,2) = fb2.data(k,j,p);
         fbcount = fbcount + 1;
         end
         end
     end
 end



% Save file
if notDefined('fname'),
    return
else
save(fname, 'fbdensity_comparison');
end

