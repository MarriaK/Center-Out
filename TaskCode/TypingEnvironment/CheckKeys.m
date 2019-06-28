function [Params, inFlag] = CheckKeys(Params, Cursor)
% [b_in_text, b_in_arrow] = CheckKeys(KP, Cursor)

% TODO: change to accurate check
KP = Params.Keyboard;
Targets = [KP.Pos.ArrowTargets; KP.Pos.TextTargets];
pos_curosr = real(Cursor.State(1:2)') + Params.Center;
target_dist = sqrt(sum(...
                (Targets - pos_curosr).^2, ...
               2));
b_In_Target = target_dist <= KP.TargetWidth / 2;

if sum(b_In_Target) > 1
    min_dist = min(target_dist);
    b_In_Target(target_dist > min_dist) = false;
end

KP.State.InArrow = b_In_Target(1:size(KP.Pos.ArrowTargets, 1));
KP.State.InText = b_In_Target(size(KP.Pos.ArrowTargets, 1) + 1:end);

inFlag = any([KP.State.InArrow; KP.State.InText]);
Params.Keyboard = KP;
end  % CheckKeys
