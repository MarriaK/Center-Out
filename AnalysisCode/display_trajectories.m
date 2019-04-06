function display_trajectories()

% ask user for files
[files,datadir] = uigetfile('*.mat','Select the INPUT DATA FILE(s)','MultiSelect','on');
if ~iscell(files),
    tmp = files;
    clear files;
    files{1} = tmp;
    clear tmp;
end
disp(datadir)
disp(files{1})
disp(files{end})

% get params
load(fullfile(datadir,files{1}))
target_sz = 4*TrialData.Params.TargetSize;
target_col = TrialData.Params.OutTargetColor;
target_rad = TrialData.Params.ReachTargetRadius;

% set up figure
figure('units','normalized','position',[.1,.1,.6,.8]);

% screen output
hold on
plot(0,0,'.','MarkerSize',target_sz,'color',target_col/255);
plot(target_rad*cosd(0:45:360-45),target_rad*sind(0:45:360-45),'.','MarkerSize',target_sz,'color',target_col/255);
axis equal
xlim([-300,+300])
ylim([-300,+300])
set(gca,'YDir','reverse')

% plot each trajectory
cc = brewermap(8,'Paired');
for n=1:length(files),
    load(fullfile(datadir,files{n}))
    cc_idx = TrialData.TargetID;
    
    % plot after instructed delay
    tidx = TrialData.Time > TrialData.Events(2).Time;
    plot([TrialData.CursorState(1,tidx)],[TrialData.CursorState(2,tidx)],'-','color',cc(cc_idx,:))
end

end
