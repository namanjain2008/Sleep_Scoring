%%
clc;
clearvars -except PC1 emg_thresh sleep_score;
close all; 
format long;

%%
%Initialization and Data Loading%

[Filename,Pathname] = (uigetfile('*.mat','Select the MATLAB file'));
Filename            = Filename(1:end-4);
Data                = load(Filename);   
 
% Data_all = art_det (Data);
 
Variables = fields(Data);                                                  % Extract the data...
EEG_Data  = Data.(Variables{menu('Select EEG_data',Variables{:})});
EMG_Data  = Data.(Variables{menu('Select EMG_data',Variables{:})});

if isfield (Data,'Startle')
Startle  = Data.(Variables{menu('Startle Data',Variables{:})});
Audpre_S = Data.(Variables{menu('SAudpre_S',Variables{:})});
Audpre   = Data.(Variables{menu('Auditory Data',Variables{:})});
end

Raw_data_prelim = EEG_Data.values;                                         % all data values
Interval=EEG_Data.interval; 
Scale = EEG_Data.scale;
Offset = EEG_Data.offset;
Start = EEG_Data.start;
Len_Values = EEG_Data.length;                                              % data length

Raw_data_emg = EMG_Data.values;                                            % all data values
Interval_emg = EMG_Data.interval; 
Scale_emg = EMG_Data.scale;
Offset_emg = EMG_Data.offset;
Start_emg = EMG_Data.start;
Len_Values_emg = EMG_Data.length;     
 
sig_emg_auditory = Raw_data_emg;
fs_emg  = 1/Interval_emg;
len_emg = length(sig_emg_auditory);

Raw_data = (Raw_data_prelim - EEG_Data.offset); 
 
%%
%Parameters Specification%

fs = 1/Interval;                                                           % Sampling frequency
time_stamp = Len_Values/fs;                                                % Total time taken
fr = 1/fs; 
Samples =(0:length(Raw_data))';   
time = Samples/fs; 
 
% Time duration x-axis

if length(Raw_data) == length(time)

    Values = Raw_data;
elseif length(Raw_data) > length(time)
  
   Values = Raw_data(1:end-1);
   
elseif length(Raw_data) < length(time)

    time = time(1:end-1);
    Values = Raw_data;

end

%%
%Removing Auditory Simulation%
if isfield (Data,'Startle')
times = [Startle.times;Audpre_S.times];
times = sort(times);
win = [0,0.5];
winpnts = round(win/EMG_Data.interval);
floor_n = sig_emg_auditory;
for i = 1:length(times)
    temp = round(times(i)/EMG_Data.interval) + winpnts;
    floor_n(temp(1):temp(2)) = 0;
end

sig_emg_aud_remove = floor_n;
end

%%
%EMG Singal Finalised%

presence = exist('Startle');

if presence == 1
    sig_emg = sig_emg_aud_remove;
elseif presence == 0
    sig_emg = sig_emg_auditory;
end

Samples_emg =(Start:length(sig_emg))';   
t_emg = Samples_emg/fs_emg; 
 
 
%%
%data downsampling%

data_downsample = dat_dwn_1(Values, sig_emg, fs, fs_emg, 100);

rawdata_downsample = data_downsample.eegdown;
emg_dwn            = data_downsample.emgdown;

%%
%Filters application%

sig_delta = sig_fil (data_downsample, 0.5, 4, 100); 

%%
%Epoch Formation%

frame_dur = 2.5;
frame_len = (frame_dur*ceil(fs));
frame.num = floor(length(Values)/frame_len);

frame.len_del = (frame_dur*ceil(fs/10));
frame.num_del = floor(length(data_downsample.eegdown)/frame.len_del);

frame.len_emg = (frame_dur*ceil(fs_emg/10));
frame.num_emg = floor(length(data_downsample.emgdown)/frame.len_emg);

%Every Signal Epoched%

obs_std_emg           = zeros(frame.num-1,1);
std_emg               = zeros(frame.num-1,1);
nb_theta_num          = zeros(frame.num-1,1);
nb_theta_den          = zeros(frame.num-1,1);
std_delta             = zeros(frame.num-1,1);
obs_std_delta         = zeros(frame.num-1,1);

%%
%Selecting PC1 threshhold%

PC1 = pc_analysis(EEG_Data, 2.5, time, fs, Filename);

%%
%Separating Sleep and Wake Stages%

[sleep_score, emg_thresh] = sleep (EEG_Data, frame, PC1, data_downsample, sig_delta, time, frame_dur, fs, Filename);


%%
%Combining the data for 10 sec%

epoch_10 = epochs_combined(sleep_score, 10);


%%
%Calculating episodes and episode count%

[episode_calc, episode_quant] = episode(epoch_10);

%%
%Percentage Calculation and Duration for Each Stages%

[Percentage_and_Duration, time_analysis] = per_dur (epoch_10, 10); 

%%
%Visual Data Plotting%

vis_markers = visual_plot (EEG_Data, time, sig_emg, t_emg, time_analysis, Filename);

%%
%Data Creation for Power Spectrum Analysis%

Active_wake_val  = data_power(Values, time_analysis, 0, fs);
Quiet_wake_val   = data_power(Values, time_analysis, 1, fs);
Sleep_val        = data_power(Values, time_analysis, 2, fs);

%%
%Plotting Power Spectrum% 
 
Nfft = 1024;
speci_fig = figure('units','normalized','outerposition',[0 0 1 1]);

[Pxx,f] = pwelch(Sleep_val,gausswin(Nfft),Nfft/2,Nfft,fs);
plot(f,Pxx);
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on;
% [~,loc] = max(Pxx);
% FREQ_ESTIMATE_SLEEP = f(loc);
% title(['Frequency estimate = ',num2str(FREQ_ESTIMATE_SLEEP),' Hz']);
hold on

clear Pxx f loc
[Pxx,f] = pwelch(Quiet_wake_val,gausswin(Nfft),Nfft/2,Nfft,fs);
plot(f,Pxx);
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on;
% [~,loc] = max(Pxx);
% FREQ_ESTIMATE_QUIET = f(loc);
% title(['Frequency estimate = ',num2str(FREQ_ESTIMATE_QUIET),' Hz']);
hold on

clear Pxx f loc
[Pxx,f] = pwelch(Active_wake_val,gausswin(Nfft),Nfft/2,Nfft,fs);
plot(f,Pxx);
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on;
% [~,loc] = max(Pxx);
% FREQ_ESTIMATE_ACTIVE = f(loc);
% title(['Frequency estimate = ',num2str(FREQ_ESTIMATE_ACTIVE),' Hz']);
hold off
title ('Power Spectrogram')
legend ('NREM','Quiet Wake','Active Wake')

savefig(speci_fig, strcat('D:\Toolbox Based Results\Spectrograms\', Filename, '_Spectrogram'))

%%
%Startle, Auditory and Auditory+Startle Data match%

[audpre_data]   = classify (Audpre, epoch_10);
[audpre_S_data] = classify (Audpre_S, epoch_10);
[startle_data]  = classify (Startle, epoch_10);

%%
%Floor Response%

Startle.active = startle_data.classified_data(startle_data.classified_data (:,2) == 0, :);
Startle.quiet  = startle_data.classified_data(startle_data.classified_data(:,2) == 1, :);
Startle.sleep  = startle_data.classified_data(startle_data.classified_data (:,2) == 2, :);

Audpre.active = audpre_data.classified_data(audpre_data.classified_data(:,2) == 0, :);
Audpre.quiet  = audpre_data.classified_data(audpre_data.classified_data(:,2) == 1, :);
Audpre.sleep  = audpre_data.classified_data(audpre_data.classified_data(:,2) == 2, :);

Audpre_S.active = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 0, :);
Audpre_S.quiet  = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 1, :);
Audpre_S.sleep  = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 2, :);

 
ts{1}= Startle.active(:,1) ;
ts{2}= Startle.quiet(:,1) ;
ts{3}= Startle.sleep(:,1) ;

ts{4}= Audpre.active(:,1) ;
ts{5}= Audpre.quiet(:,1) ;
ts{6}= Audpre.sleep(:,1) ;

ts{7}= Audpre_S.active(:,1) ;
ts{8}= Audpre_S.quiet(:,1) ;
ts{9}= Audpre_S.sleep(:,1) ;


fl_re = floorresponse(EMG_Data,ts);

%%
%Detection and Removal of Outliers%

Startle_clean  = correlation (EMG_Data, startle_data, fs_emg);
Audpre_clean   = variance (EMG_Data, audpre_data, fs_emg);
Audpre_S_clean = correlation (EMG_Data, audpre_S_data, fs_emg);

%%
%ERP Plots%

clear my_data

%%Clean Data - Outliers Removed%%
Startle.clean.active = Startle_clean.clean_data(Startle_clean.clean_data (:,2) == 0, :);
Startle.clean.quiet  = Startle_clean.clean_data(Startle_clean.clean_data(:,2) == 1, :);
Startle.clean.sleep  = Startle_clean.clean_data(Startle_clean.clean_data (:,2) == 2, :);

Audpre.clean.active = Audpre_clean.clean_data(Audpre_clean.clean_data(:,2) == 0, :);
Audpre.clean.quiet  = Audpre_clean.clean_data(Audpre_clean.clean_data(:,2) == 1, :);
Audpre.clean.sleep  = Audpre_clean.clean_data(Audpre_clean.clean_data(:,2) == 2, :);

Audpre_S.clean.active = Audpre_S_clean.clean_data(Audpre_S_clean.clean_data (:,2) == 0, :);
Audpre_S.clean.quiet  = Audpre_S_clean.clean_data(Audpre_S_clean.clean_data (:,2) == 1, :);
Audpre_S.clean.sleep  = Audpre_S_clean.clean_data(Audpre_S_clean.clean_data (:,2) == 2, :);

%%EEG ERP Calculcation%%

my_data.EEG.startle  = ERP_calc(EEG_Data, Startle.clean);
my_data.EEG.audpre   = ERP_calc(EEG_Data, Audpre.clean);
my_data.EEG.audpre_S = ERP_calc(EEG_Data, Audpre_S.clean);

%Plotting of Evoked Potentials - EEG%

figure_erp_eeg = ERP_plot_EEG(my_data.EEG, -0.5, 0.5, Interval, Filename);

% -----------------------------------------------------------------------------------------------------------------------

%%Faulty Data - With Outliers%%

Startle.fault.active = startle_data.classified_data(startle_data.classified_data (:,2) == 0, :);
Startle.fault.quiet  = startle_data.classified_data(startle_data.classified_data(:,2) == 1, :);
Startle.fault.sleep  = startle_data.classified_data(startle_data.classified_data (:,2) == 2, :);

Audpre.fault.active = audpre_data.classified_data(audpre_data.classified_data(:,2) == 0, :);
Audpre.fault.quiet  = audpre_data.classified_data(audpre_data.classified_data(:,2) == 1, :);
Audpre.fault.sleep  = audpre_data.classified_data(audpre_data.classified_data(:,2) == 2, :);

Audpre_S.fault.active = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 0, :);
Audpre_S.fault.quiet  = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 1, :);
Audpre_S.fault.sleep  = audpre_S_data.classified_data(audpre_S_data.classified_data (:,2) == 2, :);

%%Floor Channel ERP Calculation%%

my_data.EMG.clean.startle  = ERP_calc(EMG_Data, Startle.clean);
my_data.EMG.clean.audpre   = ERP_calc(EMG_Data, Audpre.clean);
my_data.EMG.clean.audpre_S = ERP_calc(EMG_Data, Audpre_S.clean);

my_data.EMG.fault.startle  = ERP_calc(EMG_Data, Startle.fault);
my_data.EMG.fault.audpre   = ERP_calc(EMG_Data, Audpre.fault);
my_data.EMG.fault.audpre_S = ERP_calc(EMG_Data, Audpre_S.fault);

%Plotting of Evoked Potentials - EEG%

figure_erp_emg_clean = ERP_plot_EMG_clean(my_data.EMG.clean, -1, 1, Interval_emg, Filename);
figure_erp_emg_fault = ERP_plot_EMG_fault(my_data.EMG.fault, -1, 1, Interval_emg, Filename);

%%
%Combining data in a string%

final_data = data_compilation (Percentage_and_Duration, startle_data, audpre_data, audpre_S_data, fl_re, Filename);

save (strcat('D:\Toolbox Based Results\Strings - Project 2\', Filename, '_workspace'))

