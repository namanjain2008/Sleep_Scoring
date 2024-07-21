% This function has been created to analyse the principal component analysis.
% First the spectrogram was done on raw EEG Signal on the desired epoch. Then on 
% the data obtained after spectrogram, PCA was applied and the PC1 was extracted.
% Then the signal was smoothed and histogram for PC1 was plotted. Once plotted,
% then the user is given the option to select the desired threshhold value.
% The function has been created by Naman Jain (naman.jain@tuebingen.mpg.de)
% funcion used will be:
% 
%         pc_analysis(input, epoch_dur, time, fs)
%         
% where; input is the Raw EEG signal whose PC1 you want to analyse
%        epoch_dur is the duration of each epoch you wish to analyse
%        time is the entire time duration of the whole signal
%        fs is raw EEG signal sampling frequency

function [output] = pc_analysis (input, epoch_dur, time, fs, Filename)

eeg_data = input.values;
%Spectrogram and PCA application%

no_samples = epoch_dur*fs;
%Performing Spectrogram on the Raw Data%

[s,f,t,p] = spectrogram(eeg_data, no_samples, 00, 2048, fs, 'yaxis');  %Spectrogram

mydata = abs(s);            %Calculating the magnitude of the spectral data
result = mean(mydata, 2);   %Calculating the mean of the magnitude of spectral data

%Princiapl Component Analysis%
mydata_2 = abs(s);
[coeff score latent] = pca (mydata_2');  %Applying PCA on magnitude of spectral data

output.data = score;

mov = movmean(score(:,1), 20);           %Smoothening of PC1 by applying moving mean

output.smooth_pc1 = mov;

figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
plot (time, eeg_data)
xlim ([0 max(time)])
title 'Raw EEG Signal Plot'
subplot 212
plot(score(:,1))                         %Poltting the first principal component
xlim ([0 max(length(score(:,1)))])
title 'Plot of PC1'

figu = figure
h = histogram (mov, 250)                 %Plotting histogram for final PC1
title 'Histogram of smoothed PC1'
waitfor (h)
pri_comp_thresh = inputdlg({'PC1 Threshhold Value'},...
               'Value', [1 50]); 
pc1_threshhold = str2num(pri_comp_thresh{:}); 
 
 
val_thresh_pc1 = [];

for ii = 1:length (score(:,1))
    val_thresh_pc1(ii,1) = pc1_threshhold;
end

output.threshhold_fig = figu;
output.threshold_val  = pc1_threshhold;

pc_fig = figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
plot (time, eeg_data)
xlim ([0 max(time)])
title 'Raw EEG Signal Plot'
subplot 212
plot(score(:,1))                         %Plotting the first principal component
xlim ([0 max(length(score(:,1)))])
title 'Plot of PC1'
hold on
plot (val_thresh_pc1)

output.fig = pc_fig


savefig(pc_fig, strcat('D:\Toolbox Based Results\Graphs for PC1\', Filename, '_pc1'))



end