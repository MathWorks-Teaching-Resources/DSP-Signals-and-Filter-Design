%  Initialization script for FilterDesign.m
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
play = @(x) disp("Playing audio");
audioread = @(x) NewAudioRead(x);

% <matlab:ShareFeedback Share your feedback>
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests","PreFiles","PreFilterDesign.mat"));
varargout={Signal,SamplingFreq};
end
