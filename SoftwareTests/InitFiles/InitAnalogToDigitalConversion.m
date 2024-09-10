%  Initialization script for AnalogToDigitalConversion.mlx
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
stop = @(x) disp("Stop audio player");
audioread = @(x) NewAudioRead(x);
audioplayer = @(x,y) NewAudioPlayer(x,y);
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests\InitFiles\InitAnalogToDigitalConversion.mat"));
varargout={JazzSignal,JazzSamplingFreq};
end
function varargout=NewAudioPlayer(varargin)
disp("Create audio player")
varargout={1};
end