function [ Params ] = MatchWords( Params )
% [ Params ] = MatchWords( Params )

KP = Params.Keyboard;

c_dim = length(KP.State.SelectedCharacters);
if c_dim > 0
    word_len = cellfun(@length, KP.State.WordMatches);
    KP.State.WordMatches(word_len < c_dim) = [];
    b_matches = false(length(KP.State.WordMatches), 1);
    for i_c = 1:length(KP.State.SelectedCharacters{c_dim})
        t_char = {KP.State.SelectedCharacters{c_dim}(i_c)};
        t_matches = cellfun(@(x) startsWith(x(c_dim:end), t_char, 'IgnoreCase', true), KP.State.WordMatches);
        b_matches = or(b_matches, t_matches);
    end
    t_matches = KP.State.WordMatches(b_matches);
    % TODO: implement other sorting algorigthms
    KP.State.WordMatches = sort(t_matches);
    if length(KP.State.WordMatches) >= KP.State.NText
        KP.State.NextWordSet = KP.State.WordMatches(1:KP.State.NText);
    else
        KP.State.NextWordSet = KP.State.WordMatches;
        KP.State.NextWordSet(end+1:KP.State.NText) = {' '};
    end
else
    KP.State.WordMatches = KP.Text.WordSet;
    KP.State.NextWordSet = KP.State.WordMatches(1:KP.State.NText);
end
Params.Keyboard = KP;
end  % MatchWords
