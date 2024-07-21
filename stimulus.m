%input1 referes to the type of stimuli i.e. Auditory, Auditory + Startle
%and Startle
%input2 refers to scored matrix.

function [output] = stimulus (EMG_Data, input1, input2, fs)

input1.new    = input1.times(input1.times(:,1) < 3600, :);

data_new = input1.new;

for ii = 1:size(data_new, 1)-1
    
    aa_avg_emg_new = EMG_Data.values(floor((data_new(ii,1))*floor(fs)):floor((data_new(ii,1)+2)*floor(fs)));
    aa_ep_startle(:,ii)= aa_avg_emg_new;
   
end

for ii = 1:length (aa_ep_startle)-1
    aa_av_new(ii,1) = mean(aa_ep_startle(ii,:));
end

output.outliers.stimuli = aa_ep_startle;
output.outliers.average = aa_av_new;


for ii = 1:size(output.outliers.stimuli, 2)
    
[acor ,lag] = xcorr(output.outliers.average, output.outliers.stimuli(ii, :));
output.acor (ii,:) = mean(acor);


end



corr_fig = figure
h = histogram (output.acor, 25)
title 'Histogram for Correlation' 
waitfor (h)
thresh = inputdlg({'Correlation Threshhold Value'},...
               'Value', [1 50]); 
val_thresh = str2num(thresh{:}); 


%%d

data_entry = input1;
scored_data = input2;

naman = classify (data_entry, scored_data);

%%finding outliers based on cross-correlation

output.data(:,1) = input1.new(:,1);
output.data(:,2) = output.acor(:,1);
output.data(:,3) = naman.classified_data(:,2);

output.fault = output.data(output.data(:,2) < val_thresh, :);
output.clear = output.data(output.data(:,2) > val_thresh, :);

data_clean = output.clear(:,1);

for ii = 1:size(data_clean, 1)-1
    
    clean_signal = EMG_Data.values(floor((data_clean(ii,1))*floor(fs)):floor((data_clean(ii,1)+2)*floor(fs)));
    clean_data(:,ii)= clean_signal;
   
end

for ii = 1:length (clean_data)-1
    clean_data_average(ii,1) = mean(clean_data(ii,:));
end


output.clean_erp.stimuli = clean_data;
output.clean_erp.average = clean_data_average; 

plot_data = output.clean_erp.average;

val_dat     =(0:length(plot_data))';   
time_dat    = val_dat/fs;

figure
plot (time_dat(1:end-1), plot_data)
ylim ([-1 1])

%%classification in AW, QW, Sleep%%

%%AW%%
naman_classify_data = output.data;

output.classfied.outliers.AW    = naman_classify_data(naman_classify_data(:,3) == 0, :);
output.classfied.outliers.QW    = naman_classify_data(naman_classify_data(:,3) == 1, :);
output.classfied.outliers.Sleep = naman_classify_data(naman_classify_data(:,3) == 2, :);

naman_clean_data = output.clear;

output.classfied.clean.AW    = naman_clean_data(naman_clean_data(:,3) == 0, :);
output.classfied.clean.QW    = naman_clean_data(naman_clean_data(:,3) == 1, :);
output.classfied.clean.Sleep = naman_clean_data(naman_clean_data(:,3) == 2, :);

naman_fault_data = output.fault;

output.classfied.fault.AW    = naman_fault_data(naman_fault_data(:,3) == 0, :);
output.classfied.fault.QW    = naman_fault_data(naman_fault_data(:,3) == 1, :);
output.classfied.fault.Sleep = naman_fault_data(naman_fault_data(:,3) == 2, :);

% for ii = 1:length (active, )
% 
% %%QW%%
% %%SLEEP%%
% for ii = 1:size(data_clean, 1)-1
%     
%     clean_signal = EMG_Data.values(floor((data_clean(ii,1))*floor(fs)):floor((data_clean(ii,1)+2)*floor(fs)));
%     clean_data(:,ii)= clean_signal;
%    
% end
% 
% for ii = 1:length (clean_data)-1
%     clean_data_average(ii,1) = mean(clean_data(ii,:));
% end

%%Active Wake%%

data_active_clean = output.classfied.clean.AW;

for ii = 1:size(data_active_clean, 1)

    clean_aw = EMG_Data.values(floor((data_active_clean(ii,1))*floor(fs)):floor((data_active_clean(ii,1)+2)*floor(fs)));
    clean_aw_data(:,ii)= clean_aw;
   
end

for ii = 1:length (clean_aw_data)-1
    clean_aw_data_average(ii,1) = mean(clean_aw_data(ii,:));
end

output.ERP.Active.Stimuli = clean_aw_data;
output.ERP.Active.Average = clean_aw_data_average;


%%Quiet Wake%%

data_quiet_clean = output.classfied.clean.QW;

for ii = 1:size(data_quiet_clean, 1)

    clean_qw = EMG_Data.values(floor((data_quiet_clean(ii,1))*floor(fs)):floor((data_quiet_clean(ii,1)+2)*floor(fs)));
    clean_qw_data(:,ii)= clean_qw;
   
end

for ii = 1:length (clean_qw_data)-1
    clean_qw_data_average(ii,1) = mean(clean_qw_data(ii,:));
end

output.ERP.Quiet.Stimuli = clean_qw_data;
output.ERP.Quiet.Average = clean_qw_data_average;



%%Sleep%%

data_sleep_clean = output.classfied.clean.Sleep;

for ii = 1:size(data_sleep_clean, 1)

    clean_sleep = EMG_Data.values(floor((data_sleep_clean(ii,1))*floor(fs)):floor((data_sleep_clean(ii,1)+2)*floor(fs)));
    clean_sleep_data(:,ii)= clean_sleep;
   
end

for ii = 1:length (clean_sleep_data)-1
    clean_sleep_data_average(ii,1) = mean(clean_sleep_data(ii,:));
end

output.ERP.Sleep.Stimuli = clean_sleep_data;
output.ERP.Sleep.Average = clean_sleep_data_average;

end
