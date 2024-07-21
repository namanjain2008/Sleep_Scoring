%input1 belongs to the matrix created from epoch formation,
%input2 is the matrix created from PC analysis,
%input3 is the matrix created from downsampled data,
%input4 is the filtered signal (delta signal in this case)
%output1 is the  matrix containing scored data,
%output2 is the matrix containing data for setting floor channel based
%threshhold values for AW Classification.

function [output1, output2] = sleep (eegdata, input1, input2, input3, input4, time, frame_dur, fs, Filename)

num_frame_del = input1.num_del;
frame_len_del = input1.len_del;
num_frame_emg = input1.num_emg;
frame_len_emg = input1.len_emg;
num_frame     = input1.num;

mov = input2.smooth_pc1;
pc1_threshhold = input2.threshold_val;

SW_Classification     = strings(num_frame-1,2);
Sleep_Wake_Code_1     = strings(num_frame-1,1);

%Separating Sleep and Wake Stages%

for ii = 1:(num_frame_del)-1
    
    if mov(ii) > pc1_threshhold
       Sleep_Wake_Code  (ii,1)         = 2; 
       Sleep_Wake_Code  (ii,2)         = (((ii)*(frame_dur))-frame_dur);
       SW_Classification(ii,1)         = 'NREM';
       SW_Classification(ii,2)         = num2str(((ii)*(frame_dur))-frame_dur);
       Sleep_Wake_Code_1(ii,1)         = 2;
       
    else   Sleep_Wake_Code  (ii,1)     = 4;
           Sleep_Wake_Code  (ii,2)     = (((ii)*(frame_dur))-frame_dur);
           SW_Classification(ii,1)     = 'Wake';
           SW_Classification(ii,2)     = num2str(((ii)*(frame_dur))-frame_dur);
           Sleep_Wake_Code_1(ii,1)     = 4;
    end
end


%EMG Threshhold Extraction%

emg_dwn_2 = input3.emgdown;

for ii= 1:length(emg_dwn_2)-250
      
    frame_emg              = emg_dwn_2(((ii):(ii)+249));
    std_emg(ii)            = std(frame_emg);
    
end

 
for ii= 1:(num_frame_emg)-1
    
    frame_emg_2            = std_emg((ii-1)*frame_len_emg+1:frame_len_emg*ii);
    obs_std_emg(ii)        = max(frame_emg_2);

end

eeg_data = eegdata.values;

emg_fig = figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
plot (time, eeg_data)
xlim ([0 max(time)])
title ('Raw EEG signal plot')
subplot 212
plot (obs_std_emg)
xlim ([0 max(length(obs_std_emg))])
title ('EMG Signal Standard Deviation plot')


figu = figure('units','normalized','outerposition',[0 0 1 1])
h = histogram (obs_std_emg, 250)                 
title 'Histogram of smoothed std of Floor Channel'
waitfor (h)
aw_thresh = inputdlg({'EMG Threshhold Value for Active Wake'},...
               'Value', [1 50]); 
aw_threshhold = str2num(aw_thresh{:}); 
 
 
val_thresh_aw = []

for ii = 1:length (obs_std_emg)
    val_thresh_aw(ii,1) = aw_threshhold;
end



emg_fig = figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
plot (time, eeg_data)
xlim ([0 max(time)])
title ('Raw EEG signal plot')
subplot 212
plot (obs_std_emg)
hold on
plot (val_thresh_aw)
xlim ([0 max(length(obs_std_emg))])
title ('EMG Signal Standard Deviation plot')


savefig(emg_fig, strcat('D:\Toolbox Based Results\Graphs for EMG\', Filename, '_emg_thresh'))


output2.threshold_fig  = figu;
output2.threshold      = aw_threshhold;
output2.std_emg_epochs = obs_std_emg;
output2.comment        = 'std_emg_epochs contains the std of each frame of floor channel for 2.5 sec based on moving window.';
output2.fig            = emg_fig;

%Classification into Active Wake and Quiet Wake%

 
for ii = 1:length(Sleep_Wake_Code_1)-1
       if Sleep_Wake_Code (ii,1) == 4
           if obs_std_emg(ii)   > aw_threshhold
              Sleep_Wake_Code  (ii,1)         = 0; 
              Sleep_Wake_Code  (ii,2)         = (((ii)*(frame_dur))-frame_dur);
              SW_Classification(ii,1)         = 'Active Wake';
              SW_Classification(ii,2)         = num2str(((ii)*(frame_dur))-frame_dur);
              Sleep_Wake_Code_1(ii,1)         = 0;
           
           else   Sleep_Wake_Code  (ii,1)     = 5;
                  Sleep_Wake_Code  (ii,2)     = (((ii)*(frame_dur))-frame_dur);
                  SW_Classification(ii,1)     = 'To be calculated';
                  SW_Classification(ii,2)     = num2str(((ii)*(frame_dur))-frame_dur);
                  Sleep_Wake_Code_1(ii,1)     = 5;
           end
       end
end


%%Classification for Quiet Wake%%

del_signal = input4;

%%Selecting the lower delta threshold value%% 
for ii = 1:length(Sleep_Wake_Code)-1
    if Sleep_Wake_Code (ii,1) == 0
       delta_wake((ii-1)*frame_len_del+1:frame_len_del*ii) = del_signal((ii-1)*frame_len_del+1:frame_len_del*ii);
    end
end
  
del_lower_thresh = std(delta_wake);

%%calculating the moving std of delta%%
for ii= 1:length(del_signal)-250
      
    frame_delta              = del_signal(((ii):(ii)+249));
    std_delta(ii)            = std(frame_delta);
end

 
%%calculating the maximum std of delta frame by frame%% 
for ii= 1:(num_frame_del)-1
    
    frame_del                = std_delta((ii-1)*frame_len_emg+1:frame_len_emg*ii);
    obs_std_delta(ii)        = max(frame_del);

end

%%Calculating Quiet Wake Stages

for ii = 1:length(Sleep_Wake_Code_1)-1
       if Sleep_Wake_Code (ii,1) == 5
           if obs_std_emg(ii)< aw_threshhold && obs_std_delta(ii) > del_lower_thresh
              Sleep_Wake_Code  (ii,1)         = 1; 
              Sleep_Wake_Code  (ii,2)         = (((ii)*(frame_dur))-frame_dur);
              SW_Classification(ii,1)         = 'Quiet Wake';
              SW_Classification(ii,2)         = num2str(((ii)*(frame_dur))-frame_dur);
              Sleep_Wake_Code_1(ii,1)         = 1;
              
           else Sleep_Wake_Code  (ii,1)       = 8; 
              Sleep_Wake_Code  (ii,2)         = (((ii)*(frame_dur))-frame_dur);
              SW_Classification(ii,1)         = 'Doubt';
              SW_Classification(ii,2)         = num2str(((ii)*(frame_dur))-frame_dur);
              Sleep_Wake_Code_1(ii,1)         = 8;
           
           end
       end
end

output1.sw_code           = Sleep_Wake_Code;
output1.sw_classification = SW_Classification;
output1.sw_code1          = Sleep_Wake_Code_1;

end