function UpdateKeyboard(Params, KeyboardParams)
% function: Short description
%
% Extended description

Pos = KeyboardParams.Pos;

Screen('FillRect', Params.WPTR, KeyboardParams.CharColor, KeyboardParams.TargetEdges);
DrawText(Params, KeyboardParams.CharacterSets, Pos.TextTargets)
DrawArrow(Params, Pos.F_Arrow, 'R')
DrawArrow(Params, Pos.B_Arrow, 'L')

end  % function
