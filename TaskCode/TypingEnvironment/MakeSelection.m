function [Params] = MakeSelection(Params)
% [KP] = MakeSelection(KP)
%
% Extended description

KP = Params.Keyboard;

if any(KP.State.InText)
    KP.State.History = [KP.State.History, KP.State.Mode];
    switch KP.State.Mode
        case 'Character'
            KP.Text.SelectedCharacters = [KP.Text.SelectedCharacters, KP.State.SelectableText(KP.State.InText)];
        case 'Word'
            if Params.DEBUG
                fprintf('%s \n', KP.State.SelectableText{:});
            end
            KP.Text.SelectedWords = [KP.Text.SelectedWords, KP.State.SelectableText(KP.State.InText)];
            KP.State.CharSetHistory = {KP.State.CharSetHistory; KP.Text.SelectedCharacters};
            KP.Text.SelectedCharacters = {};
            KP.State.Mode = 'Character';
            % KP.State.SelectableText = KP.Text.CharacterSets;
            KP.Text.WordMatches = KP.Text.WordSet;
            KP.Text.NextWordSet = KP.Text.WordSet(1:KP.State.NText);
        otherwise
            % Null
    end
elseif any(KP.State.InArrow)
    if Params.DEBUG
        fprintf('%s\n', KP.Pos.ArrowLabels{KP.State.InArrow})
    end
    switch KP.Pos.ArrowLabels{KP.State.InArrow}
    case 'Forward'
        KP.State.History = [KP.State.History, KP.State.Mode];
        KP.State.Mode = 'Word';
        % TODO: select next alternate word set
        % KP.State.SelectableText = KP.Text.NextWordSet;
    case 'Back'
        if length(KP.State.History) > 1
            switch KP.State.Mode
            case 'Word'
                switch KP.State.History{end}
                case 'Character'
                    % noop
                case 'Word'
                    KP.Text.SelectedWords = KP.Text.SelectedWords(1:end-1);
                end  % switch KP.State.History{end}
            case 'Character'
                switch KP.State.History{end}
                case 'Character'
                    KP.Text.SelectedCharacters = KP.Text.SelectedCharacters(1:end-1);
                    KP.State.WordSetHistory = KP.State.WordSetHistory{1:end-1};
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
                end % switch KP.State.History{end}
            end % switch KP.State.Mode
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
Params.Keyboard = KP;
end  % MakeSelection
