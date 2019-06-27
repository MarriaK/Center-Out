addpath(genpath('../'))
Params.Subject = 'test';
Params.ControlMode = 2;
Params.BLACKROCK = 0;
Params.DEBUG = 0;
Params = GetParams(Params);

TrialData.Block = 1;
TrialData.Trial = 1;
TrialData.TargetID = 1;
TrialData.TargetAngle = Params.ReachTargetAngles;
TrialData.TargetPosition = Params.ReachTargetPositions;

Params.TargetRect % Left, Top, Right, Bottom

% [Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [50 50 1000 1000]);
[Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [2000 50 2950 1000]);
Params.Center = [mean(Params.ScreenRectangle([1,3])),mean(Params.ScreenRectangle([2,4]))];
TrialData.TargetPosition = TrialData.TargetPosition + Params.Center;
TargetEdges = (repmat(TrialData.TargetPosition, 1, 2) + Params.TargetRect)';
Screen('FillOval', Params.WPTR, [0, 255, 0], TargetEdges)
Screen('Flip', Params.WPTR)
Screen('CloseAll');
