function varargout = InstructionScreen(Params,tex,Neuro)
% Display text then wait for subject to resume experiment

global Cursor

% determine whether to update stats during break
if Params.BLACKROCK ...
        && (Params.UpdateChStatsFlag || Params.UpdateFeaturesFlag) ...
        && exist('Neuro','var'),
    UpdateFlag = 1;
else
    UpdateFlag = 0;
end

% Pause Screen
DrawFormattedText(Params.WPTR, tex,'center','center',255);
Screen('Flip', Params.WPTR);

WaitSecs(.05);

while (1) % pause until subject presses spacebar to continue
    tim = GetSecs;
    [~, ~, keyCode, ~] = KbCheck;
    if keyCode(KbName('space'))==1,
        keyCode(KbName('space'))=0;
        break;
    elseif keyCode(KbName('escape'))==1,
        ExperimentStop(1);
    end
    
    % if update ch/feature stats flags are true,
    % collect neural and update stats
    if UpdateFlag,
        if ((tim-Cursor.LastUpdateTime)>1/Params.UpdateRate),
            Cursor.LastUpdateTime = tim;
            Neuro = NeuroPipeline(Neuro);
        end
    end
end

% return Neuro, which contains updated stats
if UpdateFlag,
    varargout{1} = Neuro;
end

Screen('Flip', Params.WPTR);
WaitSecs(.05);

end % InstructionScreen