function [ Params ] = MatchWords( Params )
% [ Params ] = MatchWords( Params )

KP = Params.Keyboard;

c_dim = length(KP.Text.SelectedCharacters);
if c_dim > 0
    KP.State.WordSetHistory = {KP.State.WordSetHistory; KP.Text.WordMatches};
    word_len = cellfun(@length, KP.Text.WordMatches);
    KP.Text.WordMatches(word_len < c_dim) = [];
    b_matches = false(length(KP.Text.WordMatches), 1);
    for i_c = 1:length(KP.Text.SelectedCharacters{c_dim})
        t_char = {KP.Text.SelectedCharacters{c_dim}(i_c)};
        t_matches = cellfun(@(x) startsWith(x(c_dim:end), t_char, 'IgnoreCase', true), KP.Text.WordMatches);
        b_matches = or(b_matches, t_matches);
    end
    t_matches = KP.Text.WordMatches(b_matches);
    % TODO: implement other sorting algorigthms
    KP.Text.WordMatches = sort(t_matches);
    if length(KP.Text.WordMatches) >= KP.State.NText
        KP.Text.NextWordSet = KP.Text.WordMatches(1:KP.State.NText);
    else
        KP.Text.NextWordSet = KP.Text.WordMatches;
        KP.Text.NextWordSet(end+1:KP.State.NText) = {' '};
    end
else
    KP.Text.WordMatches = KP.Text.WordSet;
    KP.Text.NextWordSet = KP.Text.WordMatches(1:KP.State.NText);
    KP.State.WordSetHistory = {};
end
Params.Keyboard = KP;
end  % MatchWords
