function Neuro = RunLoop(Params,Neuro,TaskFlag,datadir)
% Defines the structure of collected data on each trial
% Loops through blocks and trials within blocks

global Cursor

%% Start Experiment
DataFields = struct(...
    'Block',NaN,...
    'Trial',NaN,...
    'TrialStartTime',NaN,...
    'TrialEndTime',NaN,...
    'TargetID',NaN,...
    'TargetAngle',NaN,...
    'TargetPosition',NaN,...
    'Time',[],...
    'CursorAssist',[],...
    'CursorState',[],...
    'IntendedCursorState',[],...
    'NeuralTime',[],...
    'NeuralTimeBR',[],...
    'NeuralSamps',[],...
    'NeuralFeatures',{{}},...
    'ProcessedData',{{}},...
    'ErrorID',0,...
    'ErrorStr','',...
    'Events',[]...
    );

switch TaskFlag,
    case 1, NumBlocks = Params.NumImaginedBlocks;
    case 2, NumBlocks = Params.NumAdaptBlocks;
    case 3, NumBlocks = Params.NumFixedBlocks;
end

%%  Loop Through Blocks of Trials
Trial = 0;
TrialBatch = {};
tlast = GetSecs;
Cursor.LastPredictTime = tlast;
Cursor.LastUpdateTime = tlast;
Cursor.State = [0,0,0,0,1]';
Cursor.IntendedState = [0,0,0,0,1]';
for Block=1:NumBlocks, % Block Loop

    % random order of reach targets for each block
    TargetOrder = Params.TargetFunc(Params.NumTrialsPerBlock);

    for TrialPerBlock=1:Params.NumTrialsPerBlock, % Trial Loop
        % update trial
        Trial = Trial + 1;
        TrialIdx = TargetOrder(TrialPerBlock);
        
        % if smooth batch on & enough time has passed, update KF btw trials
        if TaskFlag==2 && Neuro.CLDA.Type==2,
            TrialBatch{end+1} = sprintf('Data%04i.mat', Trial);
            if (GetSecs-tlast)>Neuro.CLDA.UpdateTime,
                Neuro.KF.CLDA = Params.CLDA;
                Neuro.KF = FitKF(fullfile(Params.Datadir,'BCI_CLDA'),2,...
                    Neuro.KF,TrialBatch);
                tlast = GetSecs;
                TrialBatch = {};
            end
        end
        
        % set up trial
        TrialData = DataFields;
        TrialData.Block = Block;
        TrialData.Trial = Trial;
        TrialData.TargetID = TrialIdx;
        TrialData.TargetAngle = Params.ReachTargetAngles(TrialIdx);
        TrialData.TargetPosition = Params.ReachTargetPositions(TrialIdx,:);
        
        % Run Trial
        TrialData.TrialStartTime  = GetSecs;
        [TrialData,Neuro] = RunTrial(TrialData,Params,Neuro,TaskFlag);
        TrialData.TrialEndTime    = GetSecs;
                
        % Save Data from Single Trial
        save(...
            fullfile(datadir,sprintf('Data%04i.mat',Trial)),...
            'TrialData',...
            '-v7.3','-nocompression');
        
    end % Trial Loop
    
    % Give Feedback for Block
    WaitSecs(Params.InterBlockInterval);
    
end % Block Loop

end % RunLoop



