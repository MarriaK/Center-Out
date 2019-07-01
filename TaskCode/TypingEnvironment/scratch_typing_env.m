% TODO: fix bug in word update
addpath(genpath('../'))p
Params.Subject = 'test';
Params.ControlMode = 2;
Params.BLACKROCK = 0;
Params.DEBUG = 0;

Params = GetParams(Params);
[screen_w, screen_h] = Screen('WindowSize', 0);
% [Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [670 80 3170 2080]); % Left, Top, Right, Bottom
[Params.WPTR, Params.ScreenRectangle] = Screen('OpenWindow', 0, 0, [50 50 2000 1000]);

Params.Center = [mean(Params.ScreenRectangle([1,3])),mean(Params.ScreenRectangle([2,4]))];
TrialData.Block = 1;
TrialData.Trial = 1;
TrialData.TargetID = 1;

% Code below to be added to CursorEnv master code
KP = SetKeyboardParams(Params); % proabably add this to ExperimentStart
Params.Keyboard = KP;

KP.Text.SelectedCharacters = {'ABCD'};
Params.Keyboard = KP;
Params = MatchWords(Params);
KP = Params.Keyboard;

KP.Text.SelectedCharacters = [KP.Text.SelectedCharacters, 'MNOPQ'];
Params.Keyboard = KP;
Params = MatchWords(Params);
KP = Params.Keyboard;

Params.Keyboard = KP;
UpdateKeyboard(Params);
Screen('Flip', Params.WPTR);
