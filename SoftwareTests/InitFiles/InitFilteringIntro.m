%  Initialization script for FilteringIntro.mlx
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
audioread = @(x) NewAudioRead();
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests\InitFiles\InitFilteringIntro.mat"));
varargout={Signal,SamplingFrequency};
end
