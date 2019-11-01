

%C matrix input from KF for manipulation
C_old=KF.C;
C_old_delta=C_old(129:256,:);
C_old_beta=C_old(513:640,:);
C_old_hg=C_old(769:896,:);

% organizing the weight for plotting
ch_layout = [
    96    84    76    95    70    82    77    87    74    93    66    89    86    94    91    79
    92    65    85    83    68    75    78    81    72    69    88    71    80    73    90    67
    62    37    56    48    43    44    60    33    49    64    58    59    63    61    51    34
    45    53    55    52    35    57    38    50    54    39    47    42    36    40    46    41
    19    2    10    21    30    23    17    28    18    1    8    15    32    27    9    3
    24    13    6    4    7    16    22    5    20    14    11    12    29    26    31    25
    124    126    128    119    110    113    111    122    117    125    112    98    104    116    103    106
    102    109    99    101    121    127    105    120    107    123    118    114    108    115    100    97];

ch_layout_1=ch_layout';
ch_layout_2=ch_layout_1(:);

NCh=128;

for j=1:NCh
    C_old_delta_brain(j,:)=C_old_delta(ch_layout_2(j),:);
    C_old_beta_brain(j,:)=C_old_beta(ch_layout_2(j),:);
    C_old_hg_brain(j,:)=C_old_hg(ch_layout_2(j),:);
end

% I have old_brain for this structure for each feature:
% 1 2 3 ..
% 17 18....
% ........128

%% plotting the old ones on grid for only Velocity weights
% code to plot kalman c matrix (preferred dirs)

[R,Col] = size(ch_layout);

feature_strs = {'delta-phase','delta-pwr','theta-pwr','mu-pwr',...
    'beta-pwr','low-gamma-pwr','high-gamma-pwr'};
% features
for feature=[2,5,7]
    if feature==2
        Cx_feature = C_old_delta_brain(:,3);
        Cy_feature =-1* C_old_delta_brain(:,4);
    elseif feature==5
        Cx_feature = C_old_beta_brain(:,3);
        Cy_feature =-1* C_old_beta_brain(:,4);
    elseif feature==7
        Cx_feature = C_old_hg_brain(:,3);
        Cy_feature =-1* C_old_hg_brain(:,4);
    end
    
    fig = figure('position',[100, 100, 2400, 1200],...
        'name',feature_strs{feature});
    
    set(gca,'NextPlot','add');
    xx = [min(Cx_feature),max(Cx_feature)];
    yy = [min(Cy_feature),max(Cy_feature)];
    xy = [min([xx,yy]),max([xx,yy])];
    w = mean(abs(xy));
    %     w = 6e-4; % manual for low gamma fig
    %     w = 25e-4; % manual for high gamma fig
    
    Cvec = [Cx_feature,Cy_feature];
    for ch=1:NCh
        [r,c] = find(ch_layout == ch);
        x = w*c;
        y = w*(R-r);
        % clean plot
        plot(x+[0,Cvec(find(ch_layout_2==ch),1)],y+[0,Cvec(find(ch_layout_2==ch),2)],...
            'linewidth',1.5,'color','b')
        hold on
        plot(x,y,'ok')
    end
    
    title(strrep(...
        sprintf('Old Values: kalman_%s_pref_dir',...
        feature_strs{feature}),...
        '_',' '))
    axis equal
    box on
    
    %HighQualityFigs(['OldC_',feature_strs{feature}])
    
end


%% Generating the new C
C_new_delta_brain=C_old_delta_brain;
C_new_beta_brain=C_old_beta_brain;
C_new_hg_brain=C_old_hg_brain;

%% manipulating the delta values

for i=1:8
    C_new_delta_brain(1+(i-1)*16:(i-1)*16+10,:)=0;
end


%% manipulating the beta values

for i=1:8
    C_new_beta_brain(1+(i-1)*16:(i-1)*16+10,:)=0;
end

band=mean(mean(abs(C_new_beta_brain(:,[3,4]))));
for i=1:4
  C_new_beta_brain(11+(i-1)*16:(i-1)*16+11+5,4)=band;
  C_new_beta_brain(11+(i-1)*16:(i-1)*16+11+5,3)=0;
end 

for i=5:8
  C_new_beta_brain(11+(i-1)*16:(i-1)*16+11+1,4)=band;
  C_new_beta_brain(11+(i-1)*16:(i-1)*16+11+1,3)=0;
end 

for i=5:8
  C_new_beta_brain(13+(i-1)*16:(i-1)*16+13+3,3)=band;
  C_new_beta_brain(13+(i-1)*16:(i-1)*16+13+3,4)=0;
end 


%% manipulating the hg values
for i=1:8
    C_new_hg_brain(1+(i-1)*16:(i-1)*16+10,:)=0;
end

band=2*mean(mean(abs(C_new_hg_brain(:,[3,4]))));
for i=1:3
  C_new_hg_brain(11+(i-1)*16:(i-1)*16+11+5,3)=-band;
  C_new_hg_brain(11+(i-1)*16:(i-1)*16+11+5,4)=0;
end 


%% plotting the new ones on grid for only Velocity weights
% code to plot kalman c matrix (preferred dirs)

[R,Col] = size(ch_layout);

feature_strs = {'delta-phase','delta-pwr','theta-pwr','mu-pwr',...
    'beta-pwr','low-gamma-pwr','high-gamma-pwr'};
% features
for feature=[2,5,7]
    if feature==2
        Cx_feature = C_new_delta_brain(:,3);
        Cy_feature =-1* C_new_delta_brain(:,4);
    elseif feature==5
        Cx_feature = C_new_beta_brain(:,3);
        Cy_feature =-1* C_new_beta_brain(:,4);
    elseif feature==7
        Cx_feature = C_new_hg_brain(:,3);
        Cy_feature =-1* C_new_hg_brain(:,4);
    end
    
    fig = figure('position',[100, 100, 2400, 1200],...
        'name',feature_strs{feature});
    
    set(gca,'NextPlot','add');
    xx = [min(Cx_feature),max(Cx_feature)];
    yy = [min(Cy_feature),max(Cy_feature)];
    xy = [min([xx,yy]),max([xx,yy])];
    w = mean(abs(xy));
    %     w = 6e-4; % manual for low gamma fig
    %     w = 25e-4; % manual for high gamma fig
    
    Cvec = [Cx_feature,Cy_feature];
    for ch=1:NCh
        [r,c] = find(ch_layout == ch);
        x = w*c+w;
        y = w*(R-r)+w;
        % clean plot
        plot(x+[0,Cvec(find(ch_layout_2==ch),1)],y+[0,Cvec(find(ch_layout_2==ch),2)],...
            'linewidth',1.5,'color','b')
        hold on
        plot(x,y,'ok')
    end
    
    title(strrep(...
        sprintf('New Values: kalman_%s_pref_dir',...
        feature_strs{feature}),...
        '_',' '))
    axis equal
    box on
    
    %HighQualityFigs(['NewC_',feature_strs{feature}])
    
end



%% bring back to blackrock map
NCh=128;
C_new_delta=zeros(NCh,5);
C_new_beta=zeros(NCh,5);
C_new_hg=zeros(NCh,5);

for j=1:NCh
    C_new_delta(ch_layout_2(j),:)=C_new_delta_brain(j,:);
    C_new_beta(ch_layout_2(j),:)=C_new_beta_brain(j,:);
    C_new_hg(ch_layout_2(j),:)=C_new_hg_brain(j,:);
end 

C_new=zeros(896,5);

C_new(129:256,:)=C_new_delta;
C_new(513:640,:)=C_new_beta;
C_new(769:896,:)=C_new_hg;
KF.C=C_new;

%% generating Q matrix
if 0
Q=KF.Q;
q1=Q(129:256,129:256);
q2=Q(129:256,513:640);
q3=Q(129:256,769:end);

q4=Q(513:640,129:256);
q5=Q(513:640,513:640);
q6=Q(513:640,769:end);

q7=Q(769:end,129:256);
q8=Q(769:end,513:640);
q9=Q(769:end,769:end);

KF.Q=[q1 q2 q3; q4 q5 q6; q7 q8 q9];

end 

%% masking
FeatureMask([1:128,257:512,641:768])=0;

%% saving

save('kf_params.mat','KF','FeatureMask')

clear all
