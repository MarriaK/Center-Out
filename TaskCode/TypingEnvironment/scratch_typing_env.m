addpath(genpath('../'))
Params.Subject = 'test';
Params.ControlMode = 2;
Params.BLACKROCK = 0;
Params.DEBUG = 0;

Params = GetParams(Params);
[Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [2200 0 4000 1200]); % Left, Top, Right, Bottom
Params.Center = [mean(Params.ScreenRectangle([1,3])),mean(Params.ScreenRectangle([2,4]))];
TrialData.Block = 1;
TrialData.Trial = 1;
TrialData.TargetID = 1;

% Code below to be added to CursorEnv master code
KeyboardParams = SetKeyboardParams(Params);

% Pos = KeyboardParams.Pos;
% TargetWidth = KeyboardParams.TargetWidth;
% TargetHeight = KeyboardParams.TargetHeight;
% CharacterSets = KeyboardParams.CharacterSets;
%
%
% Screen('FillRect', Params.WPTR, KP.CharColor, Pos.TargetEdges);
% DrawText(Params, KeyboardParams.CharacterSets, Pos.TextTargets)
% DrawArrow(Params, Pos.F_Arrow, 'R')
% DrawArrow(Params, Pos.B_Arrow, 'L')
%

UpdateKeyboard
Screen('Flip', Params.WPTR);

Screen('CloseAll');
