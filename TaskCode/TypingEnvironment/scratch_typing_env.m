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

% find word targets
% KP.Text.SelectedCharacters = {'ABCD'};
% c_dim = length(KP.Text.SelectedCharacters);
% word_len = cellfun(@length, KP.Text.WordMatches);
% KP.Text.WordMatches(word_len < c_dim) = [];
% b_matches = false(length(KP.Text.WordMatches), 1);
% for i_c = 1:length(KP.Text.SelectedCharacters{end})
%     t_char = {KP.Text.SelectedCharacters{c_dim}(i_c)};
%     t_matches = cellfun(@(x) startsWith(x(c_dim:end), t_char, 'IgnoreCase', true), KP.Text.WordMatches);
%     b_matches = or(b_matches, t_matches);
% end
% t_matches = KP.Text.WordMatches(b_matches);
% KP.Text.WordMatches = t_matches;
%
% KP.Text.SelectedCharacters = [KP.Text.SelectedCharacters, 'MNOPQ'];
% c_dim = length(KP.Text.SelectedCharacters);
% word_len = cellfun(@length, KP.Text.WordMatches);
% KP.Text.WordMatches(word_len < c_dim) = [];
% b_matches = false(length(KP.Text.WordMatches), 1);
% for i_c = 1:length(KP.Text.SelectedCharacters{end})
%     t_char = {KP.Text.SelectedCharacters{c_dim}(i_c)};
%     t_matches = cellfun(@(x) startsWith(x(c_dim:end), t_char, 'IgnoreCase', true), KP.Text.WordMatches);
%     b_matches = or(b_matches, t_matches);
% end
% t_matches = KP.Text.WordMatches(b_matches);
% % TODO: implement other sorting algorigthms
% KP.Text.WordMatches = sort(t_matches);
% if length(KP.Text.WordMatches) >= KP.State.NText
%     KP.Text.NextWordSet = KP.Text.WordMatches(1:KP.State.NText);
% else
%     KP.Text.NextWordSet = KP.Text.WordMatches;
% end

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

% Cursor = struct('State', [0, 0, 100, 100]);
% Cursor.State = [KP.Pos.TextTargets(3, :) - KP.TargetWidth / 4, [100, 100]];
% Cursor.State = [KP.Pos.ArrowTargets(1, :) - KP.TargetWidth / 4, [100, 100]];
% Cursor.State = [KP.Pos.ArrowTargets(2, :) - KP.TargetWidth / 4, [100, 100]];
% [KP, inFlag] = CheckKeys(KP, Cursor);
% KP = MakeSelection(KP);
% Params.Keyboard = KP;
% UpdateKeyboard(Params);
% Screen('Flip', Params.WPTR);
%
% KP.State
% KP.Text
%
% KP.Pos
%
% Screen('CloseAll');
%
% KP.Pos.TargetEdges
% KP.TargetPosition
% islogical
% -KP.TargetHeight * 3
