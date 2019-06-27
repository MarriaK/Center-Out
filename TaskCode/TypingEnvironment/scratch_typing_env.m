addpath(genpath('../'))
Params.Subject = 'test';
Params.ControlMode = 2;
Params.BLACKROCK = 0;
Params.DEBUG = 0;

Params = GetParams(Params);
[Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [1500 0 4000 2000]); % Left, Top, Right, Bottom
Params.Center = [mean(Params.ScreenRectangle([1,3])),mean(Params.ScreenRectangle([2,4]))];
TrialData.Block = 1;
TrialData.Trial = 1;
TrialData.TargetID = 1;

% Code below to be added to CursorEnv master code
KP = SetKeyboardParams(Params); % proabably add this to ExperimentStart
Params.Keyboard = KP;
UpdateKeyboard(Params);
Screen('Flip', Params.WPTR);

Cursor = struct('State', [0, 0, 100, 100]);
Cursor.State = [KP.Pos.TextTargets(3, :) - KP.TargetWidth / 4, [100, 100]];
Cursor.State = [KP.Pos.ArrowTargets(1, :) - KP.TargetWidth / 4, [100, 100]];
Cursor.State = [KP.Pos.ArrowTargets(2, :) - KP.TargetWidth / 4, [100, 100]];
[KP, inFlag] = CheckKeys(KP, Cursor);
KP = MakeSelection(KP);
Params.Keyboard = KP;
UpdateKeyboard(Params);
Screen('Flip', Params.WPTR);

KP.State
KP.Text

KP.Pos

Screen('CloseAll');

KP.Pos.TargetEdges
KP.TargetPosition
islogical
% -KP.TargetHeight * 3
