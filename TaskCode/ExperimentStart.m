function ExperimentStart(Subject,ControlMode,BLACKROCK,DEBUG)
% function ExperimentStart(Subject,ControlMode)
% Subject - string for the subject id
% ControlMode - [1,2,3,4] for mouse pos, mouse vel, refit, & open control
% BLACKROCK - [0,1] if 1, collects, processes, and saves neural data
% DEBUG - [0,1] if 1, enters DEBUG mode in which screen is small and cursor
%   remains unhidden

%% Clear All and Close All
clearvars -global -except Subject ControlMode DEBUG
clc
warning off

if ~exist('Subject','var'), Subject = 'Test'; DEBUG = 1; end
if ~exist('ControlMode','var'), ControlMode = 1; end
if ~exist('BLACKROCK','var'), BLACKROCK = 0; end
if ~exist('DEBUG','var'), DEBUG = 0; end

% addpath(genpath('/Applications/Psychtoolbox'));
AssertOpenGL;
KbName('UnifyKeyNames');

if strcmpi(Subject,'Test'), Subject = 'Test'; end

%% Initialize Window
% Screen('Preference', 'SkipSyncTests', 0);
if DEBUG
    [Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [50 50 1000 1000]);
else
    [Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [10 30 1900 1000]);
end
Params.Center = [mean(Params.ScreenRectangle([1,3])),mean(Params.ScreenRectangle([2,4]))];
if ~DEBUG, HideCursor; end

%% Font
Screen('TextFont',Params.WPTR, 'Arial');
Screen('TextSize',Params.WPTR, 28);

%% Retrieve Parameters from Params File
Params.Subject = Subject;
Params.ControlMode = ControlMode;
Params.BLACKROCK = BLACKROCK;
Params.DEBUG = DEBUG;
Params = GetParams(Params);

%% Blackrock System
addpath('C:\Program Files (x86)\Blackrock Microsystems\NeuroPort Windows Suite')
cbmex('close'); % always close
if BLACKROCK,
    cbmex('open'); % open library
    cbmex('trialconfig', 1); % empty the buffer
end

%% Neural Signal Processing
% filter coeffs
for i=1:length(Params.FilterBank),
    [b,a] = butter(3,Params.FilterBank(i).fpass/(Params.Fs/2));
    Params.FilterBank(i).b = b;
    Params.FilterBank(i).a = a;
    Params.FilterBank(i).state = [];
end
% initialize stats for each channel for z-scoring
Params.NeuralStats.wSum1  = 0; % count
Params.NeuralStats.wSum2  = 0; % squared count
Params.NeuralStats.mean   = zeros(1,Params.NumChannels); % estimate of mean for each channel
Params.NeuralStats.S      = zeros(1,Params.NumChannels); % aggregate deviation from estimated mean for each channel
Params.NeuralStats.var    = zeros(1,Params.NumChannels); % estimate of variance for each channel

%% Start
try
    % Baseline 
    Params = RunBaseline(Params);
    
    % Experiment Loop with Imagined Cursor Movements
    RunImaginedTask(Params);
    
    % Experiment Loop
    RunTask(Params);
catch ME
    Screen('CloseAll')
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    fprintf(1,'\n%s\n', errorMessage);
end

end % ExperimentStart
