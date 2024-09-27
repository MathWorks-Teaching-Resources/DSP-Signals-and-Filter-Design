%  Initialization script for FilteringIntro.mlx
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
stop = @(x) disp("Stop audio player");
audioread = @(x) NewAudioRead(x);
audioplayer = @(x,y) NewAudioPlayer(x,y);
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests","PreFiles","PreFilteringIntro.mat"));
varargout={Signal,SamplingFrequency};
end
function varargout=NewAudioPlayer(varargin)
disp("Create audio player")
varargout={1};
end
