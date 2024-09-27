%  Initialization script for FilterDesign.mlx
OnSolution = true;
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
audioread = @(x) NewAudioRead(x);
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests","PreFiles","PreFilterDesign.mat"));
varargout={Signal,SamplingFreq};
end
