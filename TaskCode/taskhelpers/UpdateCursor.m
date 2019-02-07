function UpdateCursor(Params,Neuro,TaskFlag)
% UpdateCursor(Params,Neuro)
% Updates the state of the cursor using the method in Params.ControlMode
%   1 - position control
%   2 - velocity control
%   3 - kalman filter  velocity
% 
% Cursor - global structure with state of cursor [px,py,vx,vy,1]
% TaskFlag - 0-imagined mvmts, 1-clda, 2-fixed decoder

global Cursor

if TaskFlag>1, % do nothing during imagined movements
    
    % find vx and vy using control scheme
    switch Cursor.ControlMode,
        case 1, % Move to Mouse
            [x,y] = GetMouse();
            vx = (x - Params.Center(1) - Cursor.State(1));
            vy = (y - Params.Center(2) - Cursor.State(2));
            Cursor.State(3) = vx;
            Cursor.State(4) = vy;
            
        case 2, % Use Mouse Position as a Velocity Input (Center-Joystick)
            [x,y] = GetMouse();
            vx = Params.Gain * (x - Params.Center(1));
            vy = Params.Gain * (y - Params.Center(2));
            Cursor.State(3) = vx;
            Cursor.State(4) = vy;
            
        case 3, % Kalman Filter Velocity Input
            % copy structs to vars for better legibility
            P = Cursor.P;
            Y = Neuro.NeuralFeatures;
            C = Neuro.KF.C;
            Q = Neuro.KF.Q;
            
            if Neuro.CLDA.Type==3 && TaskFlag==2, % RML & CLDA block
                % copy structs to vars for better legibility
                X = Cursor.IntendedState; % *note, using intended state for updates
                R = Neuro.KF.R;
                S = Neuro.KF.S;
                T = Neuro.KF.T;
                Tinv = Neuro.KF.Tinv;
                ESS = Neuro.KF.ESS;
                Lambda = Neuro.CLDA.Lambda;
                
                % update sufficient stats
                R  = Lambda*R  + X*X';
                S  = Lambda*S  + Y*X';
                T  = Lambda*T  + Y*Y';
                ESS= Lambda*ESS+ 1;
                
                % update inverses
                Tinv = Tinv/Lambda + (Tinv*(Y*Y')*Tinv)/(Lambda*(Lambda + Y'*Tinv*Y)); % ~35ms
                Qinv = ESS * (Tinv - Tinv*S/(S'*Tinv*S - R)*S'*Tinv); % ~15ms
                
                % RML Kalman Gain eq (~8ms)
%                 Pinv = inv(P);
%                 K = P*C'*Qinv*(eye(size(Y,1)) - C/(Pinv+C'*Qinv*C)*(C'*Qinv)); % RML Kalman Gain eq (edit by DBS)
                K = P*C'*Qinv*(eye(size(Y,1)) - C/(P + C'*Qinv*C)*(C'*Qinv)); 
                
                % update kalman matrices (neural mapping matrices)
                C = S/R;
                Q = (1/ESS) * (T - S/R*S');
                
                % store params
                Neuro.KF.R = R;
                Neuro.KF.S = S;
                Neuro.KF.T = T;
                Neuro.KF.Tinv = Tinv;
                Neuro.KF.ESS = ESS;
                Neuro.KF.Lambda = Lambda;
                Neuro.KF.C = C;
                Neuro.KF.Q = Q;
            else, % normal kalman filter (faster since not updating params)
                K = (P * C') / (C*P*C' + Q); % original Kalman Gain eq
            end
            
            % state update
            X = Cursor.State; % *note using true cursor state
            Cursor.State = X + K*(Y - C*X);
            Cursor.P = P - K*C*P;

            
            
        case 4,
    end
    
    % decrease assistance during adaptation block
    if Cursor.Assistance>0,
        Cursor.Assistance = Cursor.Assistance - Cursor.DeltaAssistance;
        Cursor.Assistance = max([Cursor.Assistance,0]);
    end
end % TaskFlag

end % UpdateCursor