function s_compute_anglefromcurvatureradius

% Compute the angle threshold from the minimum radius of curvature in a
% particular step size. Using the formula in Tournier et al. (2012).
%
% (C) Hiromasa Takemura, CiNet/Stanford VISTA Team, 2015

% Set step size (in mm)
stepsize = 0.2;

% Input for the minimum radius of curvature 
mradiuscurv = [0.1:0.05:2];

% Compute the angle threshold in degree
theta = 2*asind(stepsize./(2*mradiuscurv));

% Make a plot
figure
plot(mradiuscurv, theta);

xlabel('Minimum radius of curvature (mm)');
ylabel('Angle threshold (deg)');
