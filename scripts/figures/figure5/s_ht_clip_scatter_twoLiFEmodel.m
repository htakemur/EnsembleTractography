function s_ht_clip_scatter_twoLiFEmodel(feFileToLoad)

% Make a scatter plot of Rrmse across two connectome models
%
% % The script will reproduce analysis used in the Figure 5a, in
%
% Takemura, H., Caiafa, C., Wandell, B.A., Pestilli, F. Ensemble Tractography (in revision)
%
% INPUT:
% feFileToLoad: A full path to two mat files storing fe structure in two connectome models
%
% (C) Hiromasa Takemura, CiNet HHS/Stanford VISTA Lab 2015

% Load 1st connectome model
disp('loading 1st LiFE structure...')
load(feFileToLoad{1});
coords_first  = feGet(fe,'roi coords');
mapsize_first = feGet(fe, 'map size');
rmseall_first  =  feGetRep(fe, 'vox rmse ratio');

clear fe

% Load 2nd connectome model
disp('loading 2nd LiFE structure...')
load(feFileToLoad{2});
coords_second  = feGet(fe,'roi coords');
mapsize_second = feGet(fe, 'map size');
rmseall_second  = feGetRep(fe, 'vox rmse ratio');

clear fe

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute the common voxel across models
[coords_union, ia, ib] = intersect(coords_first, coords_second, 'rows');

rmse_first = rmseall_first(ia);
rmse_second = rmseall_second(ib);

%% Make a scatter plot
figNameRmse =  sprintf(['Test_rmse_SCATTER']);
fhRmseMap = mrvNewGraphWin(figNameRmse);

% Set font size, max/min of x-y axis
fontSiz = 16;
maxsca = 1.1;
minsca = 0.5;
[ymap_pre,xx]  = hist3([rmse_first;rmse_second]',{[(minsca-1):0.025:(maxsca+1)], [(minsca-1):0.025:(maxsca+1)]});
[ymap_prep,x]  = hist3([rmse_first;rmse_second]',{[minsca:0.0125:maxsca], [minsca:0.0125:maxsca]});

sizeymap = size(ymap_prep);
ymap = ymap_prep(2:((sizeymap(1)-1)), 2:((sizeymap(2)-1)));

sh = imagesc(flipud(log10(ymap)));
cm = colormap(hot); view(0,90);
axis('square')

set(gca,'ydir','reverse');
hold on
ylabel('SPC 2mm','fontsize',fontSiz)
xlabel('ETC','fontsize',fontSiz)
cb = colorbar;
tck = get(cb,'ytick');

set(cb,'yTick',[min(tck)  mean(tck) max(tck)], ...
    'yTickLabel',round(1*10.^[min(tck),...
    mean(tck), ...
    max(tck)])/1, ...
    'tickdir','out','ticklen',[.025 .05],'box','on', ...
    'fontsize',fontSiz','visible','on')

end


