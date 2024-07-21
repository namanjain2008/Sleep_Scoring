%input referes to the stimuli (original names) i.e. Startle, Audpre,
%Audpre_S
%data_feed refers to either EEG Values or EMG values/ Floor Channel

function [output] = ERP_calc(data_feed, input)

fs = 1/data_feed.interval;
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

for ii = 1:size(data_qw, 1)
    
    input_quiet = data_feed.values(floor((data_qw(ii,1))*floor(fs)):floor((data_qw(ii,1)+2)*floor(fs)));
    ep_quiet_input(:,ii)= input_quiet;
   
end

for ii = 1:size(ep_quiet_input, 1)-1
    average_input_quiet(ii,1) = mean(ep_quiet_input(ii,:));
end

output.Quiet.Stimuli = ep_quiet_input;
output.Quiet.Average = average_input_quiet;

%Active Wake
data_aw = input.active;

for ii = 1:size(data_aw, 1)
    
    input_active = data_feed.values(floor((data_aw(ii,1))*floor(fs)):floor((data_aw(ii,1)+2)*floor(fs)));
    ep_active_input(:,ii)= input_active;
   
end

for ii = 1:size(ep_active_input, 1)-1
    average_input_active(ii,1) = mean(ep_active_input(ii,:));
end

output.Active.Stimuli = ep_active_input;
output.Active.Average = average_input_active;


%Sleep
data_sleep = input.sleep;
% data = Startle.input;

for ii = 1:size(data_sleep, 1)
    
    input_sleep = data_feed.values(floor((data_sleep(ii,1))*floor(fs)):floor((data_sleep(ii,1)+2)*floor(fs)));
    ep_sleep_input(:,ii)= input_sleep;
   
end

for ii = 1:size (ep_sleep_input, 1)-1
    average_input_sleep(ii,1) = mean(ep_sleep_input(ii,:));
end

output.Sleep.Stimuli = ep_sleep_input;
output.Sleep.Average = average_input_sleep;
end 