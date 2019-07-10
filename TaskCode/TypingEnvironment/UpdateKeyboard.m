function [Params] = UpdateKeyboard(Params)
% function: Short description
%
% Extended description

p = inputParser;
p.addRequired('Params', @(x) isstruct(x) && isfield(x, 'Keyboard'))
p.CaseSensitive = false;
parse(p, Params)

KP = Params.Keyboard;
Pos = KP.Pos;

switch Params.Keyboard.State.Mode
    case 'Character'
        Params.Keyboard.State.SelectableText = Params.Keyboard.Text.CharacterSets;
        Params.Keyboard.State.CurrentColor = Params.Keyboard.CharColor;
    case 'Word'
        Params.Keyboard.State.SelectableText = Params.Keyboard.State.NextWordSet;
        Params.Keyboard.State.CurrentColor = Params.Keyboard.WordColor;
    otherwise
        Params.Keyboard.State.SelectableText = Params.Keyboard.Text.CharacterSets;
        Params.Keyboard.State.CurrentColor = Params.Keyboard.CharColor;
end

Params = MatchWords(Params);
Pos = Params.Keyboard.Pos;
Screen('FillRect', Params.WPTR, Params.Keyboard.State.CurrentColor, Pos.TargetEdges);
DrawText(Params, Params.Keyboard.State.SelectableText, Pos.TextTargets)
DrawText(Params, join(Params.Keyboard.State.SelectedCharacters, '-'), Params.Keyboard.Pos.CharDisplay,  Params.Keyboard.Text.CharDisplayOpts{:})
DrawText(Params, join(Params.Keyboard.State.SelectedWords, ' '), Params.Keyboard.Pos.WordDisplay,  Params.Keyboard.Text.WordDisplayOpts{:})
DrawWordBox(Params, 'DrawTitle', false);
DrawArrow(Params, Pos.F_Arrow, 'R')
DrawArrow(Params, Pos.B_Arrow, 'L')

end  % function
