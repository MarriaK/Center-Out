function [KP] = MakeSelection(KP)
% [KP] = MakeSelection(KP)
%
% Extended description

if any(KP.State.InText)
    switch KP.State.Mode
        case 'Character'
            KP.Text.SelectedCharacters = [KP.Text.SelectedCharacters, KP.State.SelectableText(KP.State.InText)];
        case 'Word'
            KP.Text.SelectedWords = [KP.Text.SelectedWords, KP.State.SelectableText(KP.State.InText)];
        otherwise
            % Null
    end
    KP.State.History = [KP.State.History, KP.State.Mode];
elseif any(KP.State.InArrow)
    switch KP.Pos.ArrowLabels{KP.State.InArrow}
    case 'Forward'
        KP.State.Mode = 'Word';
        % TODO: select next word set
        KP.State.SelectableText = KP.Text.NextWordSet;
        KP.State.History = [KP.State.History, KP.State.Mode];
    case 'Back'
        if length(KP.State.History) > 1
            switch KP.State.Mode
            case 'Word'
                KP.Text.SelectedWords = KP.Text.SelectedWords(1:end-1);
            case 'Character'
                KP.Text.SelectedCharacters = KP.Text.SelectedCharacters(1:end-1);
            end % switch Mode
            KP.State.History = KP.State.History(1:end-1);
            KP.State.Mode = KP.State.History{end};
        else
            KP.State.History = {};
            KP.State.Mode = 'Character';
            KP.Text.SelectedCharacters = {};
            KP.Text.SelectedWords = {};
        end % if length(History) >= 1
    end % switch arrow label
end % if InTarget or InArrow

end  % MakeSelection
