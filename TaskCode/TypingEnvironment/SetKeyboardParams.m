function [ KP ] = SetKeyboardParams(Params)
% [ KP ] = SetKeyboardParams(Params)

KP = struct();

% debugging
KP.Verbose = false;
% Targets
KP.TargetWidth = 150;
KP.TargetHeight = 75;
% TrialData.TargetPosition normally set in RunLoop.m
KP.TargetPosition = Params.ReachTargetPositions + Params.Center;
% Params.TargetRect normally set in GetParams.m
KP.TargetRect = [-KP.TargetWidth / 2, -KP.TargetHeight / 2, KP.TargetWidth / 2, KP.TargetHeight / 2]; % Left, Top, Right, Bottom
KP.CharColor = [255, 255, 0];
KP.WordColor = [0, 150, 255];

%% Text
KP.Text.CharacterSets = {'ABCD', 'MNOPQ', 'EFGH', 'RSTU', 'IJKL', 'VWXYZ'};
KP.Text.CharDisplayOpts = {'FontSize', 25,...
                            'Offset', [10, 18],...
                             'Color', [170, 170, 170]};
KP.Text.WordDisplayOpts = {'FontSize', 32,...
                            'Offset', [10, 15],...
                             'Color', [170, 170, 170]};
KP.Text.WordBox.Title = 'Next Words';
KP.Text.WordBox.TextOpts = {'FontSize', 25,...
                            'Offset', [0, 0],...
                            'Color', [0, 0, 0],};
% TODO: implement select smaller sample
KP.Text.CorpusSize = 200;
KP.Text.WordSet = GetCorpus('N', KP.Text.CorpusSize);

%% Keyboard layout
KP.Pos = struct();
KP.Pos.ArrowTargets = KP.TargetPosition([1, 5], :);
KP.Pos.ArrowLabels = {'Forward', 'Back'};
KP.Pos.TextTargets = sortrows([KP.TargetPosition(2:4, :); KP.TargetPosition(6:8, :)]);
KP.Pos.F_Arrow = KP.TargetPosition(1, :) + [0.9 * KP.TargetWidth / 2, 0];
KP.Pos.B_Arrow = KP.TargetPosition(5, :) - [0.9 * KP.TargetWidth / 2, 0];
KP.Pos.TargetEdges = (repmat(KP.TargetPosition, 1, 2) + KP.TargetRect)';
[~, ix_top_targ] = min(KP.TargetPosition(:, 2));
[~, ix_right_targ] = max(KP.TargetPosition(:, 1));
KP.Pos.CharDisplay = KP.TargetPosition(ix_top_targ, :) - [0, KP.TargetHeight * 0.75];
KP.Pos.WordDisplay = KP.Pos.CharDisplay - [0, KP.TargetHeight];

% Word Box
KP.Pos.WordBox.H = KP.TargetHeight * 4;
KP.Pos.WordBox.W = KP.TargetWidth;
KP.Pos.WordBox.O = [KP.TargetPosition(ix_right_targ, 1), KP.TargetPosition(ix_top_targ, 2)] + [KP.TargetWidth, 0];
KP.Pos.WordBox.Edges = [KP.Pos.WordBox.O, KP.Pos.WordBox.O + [KP.Pos.WordBox.W, KP.Pos.WordBox.H]];
KP.Pos.WordBox.Color = KP.WordColor;
KP.Pos.WordBox.FirstEntry = KP.Pos.WordBox.O + [10, 10];
KP.Pos.WordBox.WordSpacing = [0, 40];

%% State
n_text = size(KP.Pos.TextTargets, 1);
n_arrow = size(KP.Pos.ArrowTargets, 1);
KP.State = struct();
KP.State.InText = false(n_text, 1);
KP.State.InArrow = false(n_arrow, 1);
KP.State.Mode = 'Character'; % or 'Word' - set during task
KP.State.Select = false; % indicates selection has been made
KP.State.SelectableText = KP.Text.CharacterSets;
KP.State.NText = n_text;
KP.State.NArrow = n_arrow;
KP.State.NextWordSet = KP.Text.WordSet(1:n_text); % NOTE: text here, not well organized
KP.State.CurrentColor = KP.WordColor;
KP.State.SelectedCharacters = {};
KP.State.SelectedWords = {};
KP.State.WordMatches = KP.Text.WordSet;

% Keyboard State History
KP.History.State = {};
KP.History.Trajectory = {};


end  % function
