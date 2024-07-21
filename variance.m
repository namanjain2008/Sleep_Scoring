%input1 referes to the type of stimuli i.e. audpre_data, audpre_S_data
%and startle_data


function [output] = variance (EMG_Data, input1, fs)

data_new   = input1.classified_data;


%%Calculating the values for all trials and their average in a particular
%%stimuli%%
for ii = 1:size(data_new, 1)
    
    aa_avg_emg_new = EMG_Data.values(floor((data_new(ii,1))*floor(fs)):floor((data_new(ii,1)+2)*floor(fs)));
    aa_ep_startle(:,ii)= aa_avg_emg_new;
   
end

for ii = 1:length (aa_ep_startle)-1
    aa_av_new(ii,1) = mean(aa_ep_startle(ii,:));
end

output.with_outliers.trials = aa_ep_startle; %calculating the floor values for all trials
output.with_outliers.average = aa_av_new;    %calculating the average floor values for all trials

%%Calculating the correlation and time lag values%%

for ii=1:size(aa_ep_startle,2)
    
[var_val(:,ii)] = var(aa_ep_startle(:,ii));
%finding the variance of all trials and each trial
%in a stimuli

end

output.outlier_data(:,1) = data_new(:,1);
output.outlier_data(:,2) = data_new(:,2);
output.outlier_data(:,3) = var_val;


%%Figure plot for Coefficient Correlation - Threshold Estimation%%
figure('units','normalized','outerposition',[0 0 1 1])
plot(var_val)
title 'Variance vs Trial No'
xlabel 'No of Trials'
ylabel 'Variance Values'

figure
e = histogram (var_val, 50)
waitfor (e)
coeff_cor= inputdlg({'Variance based Threshhold Value'},...
               'Value', [1 50]); 
coeff_cor_threshhold = str2num(coeff_cor{:}); 
 
output.without_outliers.variance_based_threshold = output.outlier_data(output.outlier_data(:,3) < coeff_cor_threshhold, :);


output.clean_data = output.without_outliers.variance_based_threshold;



end
