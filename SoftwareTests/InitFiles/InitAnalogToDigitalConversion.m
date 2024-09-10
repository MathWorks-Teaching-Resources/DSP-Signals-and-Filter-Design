%  Initialization script for AnalogToDigitalConversion.mlx
% ---- Known Issues     -----
KnownIssuesID = "MATLAB:minrhs";
% ---- Pre-run commands -----
audioread = @(x) NewAudioRead();
function varargout=NewAudioRead(varargin)
load(fullfile(currentProject().RootFolder,"SoftwareTests\InitFiles\InitAnalogToDigitalConversion.mat"));
varargout={JazzSignal,JazzSamplingFreq};
end