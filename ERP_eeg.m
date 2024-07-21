%input referes to the stimuli (original names) i.e. Startle, Audpre,
%Audpre_S

function [output] = ERP_eeg(EEG_Data, input)

fs = 1/EEG_Data.interval;
Variables = fields(input);
% data =menu('Select var',Var(:))


ep_quiet_input    = [];
ep_active_input   = [];
ep_sleep_input    = [];
ep_quiet_audpre     = [];
ep_active_audpre    = [];
ep_sleep_audpre     = [];
ep_quiet_audpre_S   = [];
ep_active_audpre_S  = [];
ep_sleep_audpre_S   = [];


%Quiet Wake
data_qw = input.quiet;

for ii = 1:length(data_qw)
    
    input_quiet = EEG_Data.values(floor((data_qw(ii,1))*floor(fs)):floor((data_qw(ii,1)+2)*floor(fs)));
    ep_quiet_input(:,ii)= input_quiet;
   
end

for ii = 1:length (ep_quiet_input)-1
    average_input_quiet(ii,1) = mean(ep_quiet_input(ii,:));
end

output.Quiet.Stimuli = ep_quiet_input;
output.Quiet.Average = average_input_quiet;

%Active Wake
data_aw = input.active;

for ii = 1:length(data_aw)
    
    input_active = EEG_Data.values(floor((data_aw(ii,1))*floor(fs)):floor((data_aw(ii,1)+2)*floor(fs)));
    ep_active_input(:,ii)= input_active;
   
end

for ii = 1:length (ep_active_input)-1
    average_input_active(ii,1) = mean(ep_active_input(ii,:));
end

output.Active.Stimuli = ep_active_input;
output.Active.Average = average_input_active;


%Sleep
data_sleep = input.sleep;
% data = Startle.input;

for ii = 1:length(data_sleep)
    
    input_sleep = EEG_Data.values(floor((data_sleep(ii,1))*floor(fs)):floor((data_sleep(ii,1)+2)*floor(fs)));
    ep_sleep_input(:,ii)= input_sleep;
   
end

for ii = 1:length (ep_sleep_input)-1
    average_input_sleep(ii,1) = mean(ep_sleep_input(ii,:));
end

output.Sleep.Stimuli = ep_sleep_input;
output.Sleep.Average = average_input_sleep;
end 