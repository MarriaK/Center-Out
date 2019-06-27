function [ KP ] = SetKeyboardParams(Params)
% function: Short description
%
% Extended description

% Targets
KP = struct();
KP.TargetWidth = 250;
KP.TargetHeight = 150;
% TrialData.TargetPosition normally set in RunLoop.m
KP.TargetPosition = Params.ReachTargetPositions + Params.Center;
% Params.TargetRect normally set in GetParams.m
KP.TargetRect = [-KP.TargetWidth / 2, -KP.TargetHeight / 2, KP.TargetWidth / 2, KP.TargetHeight / 2]; % Left, Top, Right, Bottom
KP.CharColor = [255, 255, 0];
KP.WordColor = [0, 255, 255];

% Keyboard layout
KP.Pos = struct();
KP.Pos.TextTargets = sortrows([KP.TargetPosition(2:4, :); KP.TargetPosition(6:8, :)]);
KP.Pos.F_Arrow = KP.TargetPosition(1, :) + [0.9 * KP.TargetWidth / 2, 0];
KP.Pos.B_Arrow = KP.TargetPosition(5, :) - [0.9 * KP.TargetWidth / 2, 0];
KP.Pos.TargetEdges = (repmat(KP.TargetPosition, 1, 2) + KP.TargetRect)';

% Text
KP.CharacterSets = {'ABCD', 'MNOPQ', 'EFGH', 'RSTU', 'IJKL', 'VWXYZ'};



end  % function
