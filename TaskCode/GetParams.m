function Params = GetParams(Params)
% Experimental Parameters
% These parameters are meant to be changed as necessary (day-to-day,
% subject-to-subject, experiment-to-experiment)
% The parameters are all saved in 'Params.mat' for each experiment

%% Experiment
Params.Task = 'Center-Out';
switch Params.ControlMode,
    case 1, Params.ControlModeStr = 'MousePosition';
    case 2, Params.ControlModeStr = 'MouseVelocity';
    case 3, Params.ControlModeStr = 'ReFit';
    case 4, Params.ControlModeStr = 'Open';
end

%% Current Date and Time
% get today's date
now = datetime;
Params.YYYYMMDD = sprintf('%i',yyyymmdd(now));
Params.HHMMSS = sprintf('%02i%02i%02i',now.Hour,now.Minute,round(now.Second));

%% Data Saving

% if Subject is 'Test' or 'test' then can write over previous test
if strcmpi(Params.Subject,'Test'),
    Params.YYYYMMDD = 'YYYYMMDD';
    Params.HHMMSS = 'HHMMSS';
end

projectdir = fullfile('C:\Users\ganguly-lab2\Documents\MATLAB\Center-Out');
datadir = fullfile(projectdir,'Data',Params.Subject,Params.YYYYMMDD,Params.HHMMSS);

% create folders for saving
Params.datadir = datadir;
Params.imagined_datadir = fullfile(datadir,'Imagined');
if ~exist(Params.datadir,'dir'), mkdir(Params.datadir); end
if ~exist(Params.imagined_datadir,'dir'), mkdir(Params.imagined_datadir); end

%% Timing
Params.RefreshRate = 50; % Hz
Params.NeuralRefreshRate = 10; % Hz
Params.BaselineTime = 1;

%% Targets
Params.TargetSize = 30;
Params.OutTargetColor = [0,255,0];
Params.InTargetColor = [255,0,0];

Params.StartTargetPosition  = Params.Center;
Params.TargetRect = ...
    [-Params.TargetSize -Params.TargetSize +Params.TargetSize +Params.TargetSize];

Params.ReachTargetAngles = (0:45:315)';
Params.ReachTargetRadius = 400;
Params.ReachTargetPositions = ...
    Params.StartTargetPosition ...
    + Params.ReachTargetRadius ...
    * [cosd(Params.ReachTargetAngles) sind(Params.ReachTargetAngles)];

%% Cursor
Params.CursorColor = [0,0,255];
Params.CursorSize = 5;
Params.CursorRect = [-Params.CursorSize -Params.CursorSize ...
    +Params.CursorSize +Params.CursorSize];

%% Trial and Block Types
Params.NumBlocks = 1;
Params.NumImaginedBlocks = 0;
Params.NumTrialsPerBlock = length(Params.ReachTargetAngles);
Params.NumTrials = Params.NumBlocks*Params.NumTrialsPerBlock;
Params.NumImaginedTrials = Params.NumImaginedBlocks*Params.NumTrialsPerBlock;

%% Hold Times
Params.TargetHoldTime = .4;
Params.InterTrialInterval = .5;
Params.InstructedDelayTime = 1;
Params.MaxStartTime = 15;
Params.MaxReachTime = 15;
Params.InterBlockInterval = 1;

%% Feedback
Params.FeedbackSound = 1;
Params.ErrorWaitTime = 2;
Params.ErrorSound = 1000*audioread('buzz.wav');
Params.RewardSound = 1000*audioread('smw_coin.wav');
% play sounds silently once so Matlab gets used to it
sound(0*Params.ErrorSound)

%% Control
Params.Gain = 1;
Params.CenterReset = false;
Params.Assistance = .5; % value btw 0 and 1, 1 full assist

%% BlackRock Params
Params.Fs = 1000;
Params.NumChannels = 128;
Params.BufferTime = 4; % secs longer for better phase estimation of low frqs
Params.BufferSamps = Params.BufferTime * Params.Fs;
Params.BadChannels = [];

% filter bank - each element is a filter bank
% fpass - bandpass cutoff freqs
% feature - # of feature (can have multiple filters for a single feature
% eg., high gamma is composed of multiple freqs)
Params.FilterBank = [];
Params.FilterBank(end+1).fpass = [.5,4];    % delta
Params.FilterBank(end).feature = 1;
Params.FilterBank(end+1).fpass = [4,8];     % theta
Params.FilterBank(end).feature = 2;
Params.FilterBank(end+1).fpass = [8,13];    % alpha
Params.FilterBank(end).feature = 3;
Params.FilterBank(end+1).fpass = [13,19];   % beta1
Params.FilterBank(end).feature = 4;
Params.FilterBank(end+1).fpass = [19,30];   % beta2
Params.FilterBank(end).feature = 4;
Params.FilterBank(end+1).fpass = [30,36];   % low gamma1 
Params.FilterBank(end).feature = 5;
Params.FilterBank(end+1).fpass = [36,42];   % low gamma2 
Params.FilterBank(end).feature = 5;
Params.FilterBank(end+1).fpass = [42,50];   % low gamma3
Params.FilterBank(end).feature = 5;
Params.FilterBank(end+1).fpass = [70,77];   % high gamma1
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [77,85];   % high gamma2
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [85,93];   % high gamma3
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [93,102];  % high gamma4
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [102,113]; % high gamma5
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [113,124]; % high gamma6
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [124,136]; % high gamma7
Params.FilterBank(end).feature = 6;
Params.FilterBank(end+1).fpass = [136,150]; % high gamma8
Params.FilterBank(end).feature = 6;

Params.NumFeatures = length(unique([Params.FilterBank.feature])) + 1;

%% Save Parameters
save(fullfile(Params.datadir,'Params.mat'),'Params');

end % GetParams

