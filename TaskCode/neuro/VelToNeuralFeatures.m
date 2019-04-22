function varargout = VelToNeuralFeatures(Params,Data,noise,PLOT)
% function [Z,Data] = VelToNeuralFeatures(Params,noise,PLOT)
% Use a 2D gaussian function to generate neural features vector
% neural features change depending input velocity
%
% INPUT:
% noise - % noise in % of centroid peak value (default=100)
% PLOT - 0-no plot, 1-plot (default=1)
%
% OUTPUT: 
% Z - neural features vector with size of 128 x num_features 
% Data - Data structure updated with neural features
% 
% CREATED: G. Nootz  May 2012
% 
%  Modifications:
%  Reza Abiri Feb 2019
%  Daniel Silversmith Feb 2019
% 
% ---------User Input---------------------

global Cursor
% inputs
if ~exist('noise','var'), noise=150; end
if ~exist('PLOT','var'), PLOT = 0; end
if ~isfield(Cursor,'MousePos'), Cursor.MousePos = [0,0]; end

% compute velocities
x1 = Cursor.MousePos(1);
y1 = Cursor.MousePos(2);
[x2,y2] = GetMouse();
x2 = x2 - Params.Center(1);
y2 = y2 - Params.Center(2);
Cursor.MousePos(1) = x2;
Cursor.MousePos(2) = y2;
Vx = Params.Gain * (x2 - x1) * Params.UpdateRate;
Vy = Params.Gain * (y2 - y1) * Params.UpdateRate;

% rescaling to matrix map
MdataSizeY=16;
MdataSizeX=8*Params.NumFeatures;

Vx=MdataSizeX/2 + Vx*(MdataSizeX/(2*250));
Vy=MdataSizeY/2 + Vy*(MdataSizeY/(2*250));

% generate centroid
[X,Y] = meshgrid(1:MdataSizeX,1:MdataSizeY);

xdata = zeros(size(X,1),size(Y,2),2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;

x = [2,Vx,7,Vy,4.5,+0.02*2*pi]; % centroid parameters
Z = D2GaussFunction(x,xdata);

% add noise
noise = noise/100 * x(1);
% Z = noise*(rand(size(X,1),size(Y,2))-0.5);
Z = Z + noise*(rand(size(X,1),size(Y,2))-0.5);

% feature plot
if PLOT,
	imagesc(X(1,:),Y(:,1)',Z)
	set(gca,'YDir','reverse')
	colormap('jet')
end

% vectorize output
Z = Z(:);

% zero out "bad channels"
Z(~Params.FeatureMask) = 0;

% update data structure if given
if exist('Data','var')
    Data.NeuralFeatures{end+1} = Z;
    Data.NeuralTime(1,end+1) = GetSecs;
end

% outputs
varargout{1} = Z;
if nargout==2,
    varargout{2} = Data;
end

end % VelToNeuralFeatures

function F = D2GaussFunction(x,xdata)
F = x(1)*exp(-((xdata(:,:,1)-x(2)).^2/(2*x(3)^2) ...
    + (xdata(:,:,2)-x(4)).^2/(2*x(5)^2)));
end % D2GaussFunction
 