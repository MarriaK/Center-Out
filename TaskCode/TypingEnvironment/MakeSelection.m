function [KP] = MakeSelection(KP)
% [KP] = MakeSelection(KP)
%
% Extended description

if any(KP.State.InText)
    KP.State.History = [KP.State.History, KP.State.Mode];
    switch KP.State.Mode
        case 'Character'
            KP.Text.SelectedCharacters = [KP.Text.SelectedCharacters, KP.State.SelectableText(KP.State.InText)];
        case 'Word'
            KP.Text.SelectedWords = [KP.Text.SelectedWords, KP.State.SelectableText(KP.State.InText)];
            % TODO: change this to a cell of cells
            % KP.State.CharSetHistory = [KP.State.CharSetHistory; KP.Text.SelectedCharacters];
            KP.State.CharSetHistory = {KP.State.CharSetHistory; KP.Text.SelectedCharacters};
            KP.Text.SelectedCharacters = {};
            KP.State.Mode = 'Character';
            KP.State.SelectableText = KP.Text.CharacterSets;
            KP.Text.WordMatches = KP.Text.WordSet;
            KP.Text.NextWordSet = KP.Text.WordSet(1:KP.State.NText);
        otherwise
            % Null
    end
elseif any(KP.State.InArrow)
    switch KP.Pos.ArrowLabels{KP.State.InArrow}
    case 'Forward'
        % KP.State.History = [KP.State.History, KP.State.Mode];
        KP.State.Mode = 'Word';
        % TODO: select next alternate word set
        KP.State.SelectableText = KP.Text.NextWordSet;
    case 'Back'
        if length(KP.State.History) > 1
            switch KP.State.Mode
            case 'Word'
                KP.Text.SelectedWords = KP.Text.SelectedWords(1:end-1);
            case 'Character'
                switch KP.State.History{end}
                case 'Character'
                    KP.Text.SelectedCharacters = KP.Text.SelectedCharacters(1:end-1);
                    KP.Text.WordMatches = KP.State.WordSetHistory{end};
                case 'Word'
                    KP.Text.SelectedWords = KP.Text.SelectedWords(1:end-1);
                    if size(KP.State.CharSetHistory, 1) > 1
                        KP.Text.SelectedCharacters = KP.State.CharSetHistory{end};
                        KP.State.CharSetHistory = KP.State.CharSetHistory{1:end-1};
                    elseif size(KP.State.CharSetHistory, 1) == 1
                        KP.Text.SelectedCharacters = KP.State.CharSetHistory(end);
                        KP.State.CharSetHistory = {};
                    else
                        KP.Text.SelectedCharacters = {};
                        KP.State.CharSetHistory = {};
                    end
                end
            end % switch Mode
            KP.State.Mode = KP.State.History{end};
            KP.State.History = KP.State.History(1:end-1);
        else
            KP.State.History = {};
            KP.State.Mode = 'Character';
            KP.Text.SelectedCharacters = {};
            KP.Text.SelectedWords = {};
         end % if length(History) >= 1
    end % switch arrow label
end % if InTarget or InArrow

end  % MakeSelection
