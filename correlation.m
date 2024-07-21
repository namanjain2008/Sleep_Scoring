%input1 referes to the type of stimuli i.e. audpre_data, audpre_S_data
%and startle_data


function [output] = correlation (EMG_Data, input1, fs)

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
    
[corr_a(:,ii),lag_a(ii,:)] = xcorr(aa_av_new, aa_ep_startle(:,ii));
%finding the correlation between the average of all trials and each trial
%in a stimuli

end

[~,III] = max(corr_a(:,1:end)) ;
%finding indexes where the peak coefficient correlation occured

lag_x = lag_a';

lagdff_1 = lag_x(III(1,:));
%find the lag difference values based on indices and lag caclulation

output.lagdff = lagdff_1';
output.lagdff(:,2) = (output.lagdff(:,1));
output.lagdff(:,3) = abs(output.lagdff(:,2)/fs);

output.correaltion_coefficients(:,1) =  max(abs(corr_a(:,1:end))) 

output.outlier_data(:,1) = data_new(:,1);
output.outlier_data(:,2) = data_new(:,2);
output.outlier_data(:,3) = max(corr_a(:,1:end))
output.outlier_data(:,4) = output.lagdff(:,3)


%%Figure plot for Time Lags - Threshold Estimation%%
figure('units','normalized','outerposition',[0 0 1 1])
h = plot(output.lagdff(:,3))
title 'Time Lag vs Trial No'
xlabel 'No of Trials'
ylabel 'Time Lag Values'

figure
h = histogram (output.lagdff(:,3), 100)
title 'Histograms for Time Lag'
waitfor (h)

time_lag = inputdlg({'Time Lag based Threshhold Value'},...
               'Value', [1 50]); 
time_lag_threshold = str2num(time_lag{:}); 

output.without_outliers.time_lag_based_threshold = output.outlier_data (output.outlier_data(:,4) < time_lag_threshold, :);


%%Figure plot for Coefficient Correlation - Threshold Estimation%%
figure('units','normalized','outerposition',[0 0 1 1])
plot(output.correaltion_coefficients(:,1))
title 'Correlation Coefficient vs Trial No'
xlabel 'No of Trials'
ylabel 'Coefficient Correlation Values'

figure
e = histogram (output.correaltion_coefficients(:,1), 100)
title 'Histogram for Correlation Coefficients'
waitfor (e)
coeff_cor= inputdlg({'Correlation Coefficients based Threshhold Value'},...
               'Value', [1 50]); 
coeff_cor_threshhold = str2num(coeff_cor{:}); 
 
output.without_outliers.correlation_based_threshold = output.without_outliers.time_lag_based_threshold(output.without_outliers.time_lag_based_threshold(:,3) > coeff_cor_threshhold, :);

output.clean_data = output.without_outliers.correlation_based_threshold;

for ii = 1:size (output.correaltion_coefficients(:,1))
    naman(ii,1) = coeff_cor_threshhold;
end
% 
% threshold.input1.time_lag = time_lag_threshold;
% threshold.input1.correlation_coefficient = coeff_cor_threshhold;

close all

figure('units','normalized','outerposition',[0 0 1 1])
plot(output.correaltion_coefficients(:,1))
hold on
plot (naman)
title 'Correlation Coefficient vs Trial No'
xlabel 'No of Trials'
ylabel 'Coefficient Correlation Values'

end
