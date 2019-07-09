function [Params] = MakeSelection(Params)
% [Params] = MakeSelection(Params)
%
% Extended description

KP = Params.Keyboard;

if any(KP.State.InText)
    KP.State.StateHistory = [KP.State.StateHistory, KP];
    switch KP.State.Mode
        case 'Character'
            KP.State.SelectedCharacters = [KP.State.SelectedCharacters, KP.State.SelectableText(KP.State.InText)];
        case 'Word'
            if Params.DEBUG
                fprintf('Selectable text: ');
                fprintf('%s ', KP.State.SelectableText{:});
                fprintf('\n');
            end
            KP.State.SelectedWords = [KP.State.SelectedWords, KP.State.SelectableText(KP.State.InText)];
            KP.State.SelectedCharacters = {};
            KP.State.Mode = 'Character';
            KP.State.WordMatches = KP.Text.WordSet;
            KP.Text.NextWordSet = KP.Text.WordSet(1:KP.State.NText);
        otherwise
            % Null
    end
elseif any(KP.State.InArrow)
    if Params.DEBUG
        fprintf('Selected arrow: ')
        fprintf('%s ', KP.Pos.ArrowLabels{KP.State.InArrow})
        fprintf('\n');
    end
    switch KP.Pos.ArrowLabels{KP.State.InArrow}
    case 'Forward'
        KP.State.StateHistory = [KP.State.StateHistory, KP];
        KP.State.Mode = 'Word';
        % TODO: select next alternate word set
    case 'Back'
        if length(KP.State.StateHistory) > 1
            KP = KP.State.StateHistory{end};
        else
            KP = SetKeyboardParams(Params);
        end % if length(History) >= 1
    end % switch arrow label
end % if InTarget or InArrow
Params.Keyboard = KP;
end  % MakeSelection
