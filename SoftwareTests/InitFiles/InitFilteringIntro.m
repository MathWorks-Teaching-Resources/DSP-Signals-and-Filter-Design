%  Initialization script for FilteringIntro.mlx
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
audioplayer = @(x) disp("Create audio player");
play = @(x) disp("Playing audio");
stop = @(x) disp("Stop audio player");
audioread = @(x) NewAudioRead();
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests\InitFiles\InitFilteringIntro.mat"));
varargout={Signal,SamplingFrequency};
end
