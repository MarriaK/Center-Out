function UpdateKeyboard(Params)
% function: Short description
%
% Extended description

p = inputParser;
p.addRequired('Params', @(x) isstruct(x) && isfield(x, 'Keyboard'))
p.CaseSensitive = false;
parse(p, Params)

KP = Params.Keyboard;
Pos = KP.Pos;

switch KP.State.Mode
    case 'Character'
        targ_text = KP.Text.CharacterSets;
        targ_color = KP.CharColor;
    case 'Word'
        targ_text = KP.Text.NextWordSet;
        targ_color = KP.WordColor;
    otherwise
        targ_text = KP.Text.CharacterSets;
        targ_color = KP.CharColor;
end

Screen('FillRect', Params.WPTR, targ_color, Pos.TargetEdges);
DrawText(Params, targ_text, Pos.TextTargets)
DrawText(Params, join(KP.Text.SelectedCharacters, '-'), KP.Pos.CharDisplay,  KP.Text.CharDisplayOpts{:})
DrawText(Params, join(KP.Text.SelectedWords, ' '), KP.Pos.WordDisplay,  KP.Text.WordDisplayOpts{:})
DrawWordBox(Params, 'DrawTitle', false);
DrawArrow(Params, Pos.F_Arrow, 'R')
DrawArrow(Params, Pos.B_Arrow, 'L')
end  % function
