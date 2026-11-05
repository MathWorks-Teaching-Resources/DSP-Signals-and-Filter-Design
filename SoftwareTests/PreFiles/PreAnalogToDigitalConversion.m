%  Initialization script for AnalogToDigitalConversion.m
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
stop = @(x) disp("Stop audio player");
audioread = @(x) NewAudioRead(x);
audioplayer = @(x,y) NewAudioPlayer(x,y);

% <matlab:ShareFeedback Share your feedback>
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests","PreFiles","PreAnalogToDigitalConversion.mat"));
varargout={JazzSignal,JazzSamplingFreq};
end
function varargout=NewAudioPlayer(varargin)
disp("Create audio player")
varargout={1};
end