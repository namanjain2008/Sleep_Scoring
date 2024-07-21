%This function has been created to calculate the ERP values from the raw
%EMG Data (floor channel). This includes calculation of the average ERP values from 3
%different brain states (Quiet Wake, Active Wake and Sleep) and includes 3
%different types of stimuli (Startle, Preauditory and Preauditory + Startle)
%Created by: Naman Jain
%Created on: 23.07.2018
%naman.jain@tuebingen.mpg.de


function [emg_ep_quiet_startle, emg_av_qs, emg_ep_active_startle, emg_av_as, emg_ep_sleep_startle, emg_av_ss] = erp_emg(Startle, EMG_Data)

fs = 1/EMG_Data.interval;
Variables = fields(Startle);
% data =menu('Select var',Var(:))

emg_ep_quiet_startle    = [];
emg_ep_active_startle   = [];
emg_ep_sleep_startle    = [];
emg_ep_quiet_audpre     = [];
emg_ep_active_audpre    = [];
emg_ep_sleep_audpre     = [];
emg_ep_quiet_audpre_S   = [];
emg_ep_active_audpre_S  = [];
emg_ep_sleep_audpre_S   = [];


%Quiet Wake
data_qw = Startle.quiet;
% data = Startle.input;

for ii = 1:length(data_qw)
    
    emg_avg_eeg_qs = EMG_Data.values(floor((data_qw(ii,1))*floor(fs)):floor((data_qw(ii,1)+2)*floor(fs)));
    emg_ep_quiet_startle(:,ii)= emg_avg_eeg_qs;
   
end

for ii = 1:length (emg_ep_quiet_startle)-1
    emg_av_qs(ii,1) = mean(emg_ep_quiet_startle(ii,:));
end


%Active Wake
data_aw = Startle.active;
% data = Startle.input;

for ii = 1:length(data_aw)
    
    emg_avg_eeg_as = EMG_Data.values(floor((data_aw(ii,1))*floor(fs)):floor((data_aw(ii,1)+2)*floor(fs)));
    emg_ep_active_startle(:,ii)= emg_avg_eeg_qs;
   
end

for ii = 1:length (emg_ep_active_startle)-1
    emg_av_as(ii,1) = mean(emg_ep_active_startle(ii,:));
end


%Sleep
data_sleep = Startle.sleep;
% data = Startle.input;

for ii = 1:length(data_sleep)
    
    emg_avg_eeg_ss = EMG_Data.values(floor((data_sleep(ii,1))*floor(fs)):floor((data_sleep(ii,1)+2)*floor(fs)));
    emg_ep_sleep_startle(:,ii)= emg_avg_eeg_ss;
   
end

for ii = 1:length (emg_ep_sleep_startle)-1
    emg_av_ss(ii,1) = mean(emg_ep_sleep_startle(ii,:));
end

end