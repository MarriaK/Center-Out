function [Params] = MakeSelection(Params)
% [Params] = MakeSelection(Params)
%
% Extended description

KP = Params.Keyboard;

if any(KP.State.InText)
    KP.History.State = [KP.History.State, KP.State];
    KP.History.Trajectory = [KP.History.Trajectory, KP.State];
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
            KP.State.NextWordSet = KP.Text.WordSet(1:KP.State.NText);
        otherwise
            % Null
    end
elseif any(KP.State.InArrow)
    if Params.DEBUG
        fprintf('Selected arrow: ')
        fprintf('%s ', KP.Pos.ArrowLabels{KP.State.InArrow})
        fprintf('\n');
    end
    KP.History.Trajectory = [KP.History.Trajectory, KP.State];
    switch KP.Pos.ArrowLabels{KP.State.InArrow}
    case 'Forward'
        KP.History.State = [KP.History.State, KP.State];
        KP.State.Mode = 'Word';
        % TODO: select next alternate word set
    case 'Back'
        if length(KP.History.State) >= 1
            KP.State = KP.History.State{end};
            KP.History.State = KP.History.State(1:end-1);
        else
            % NOTE: do a noop or prompt to end
            % KP = SetKeyboardParams(Params);
        end % if length(History) >= 1
    end % switch arrow label
end % if InTarget or InArrow
Params.Keyboard = KP;
end  % MakeSelection
