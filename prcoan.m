function [mov] = prcoan(data)

%Performing SPectrogram on the Raw Data%
[s,f,t,p] = spectrogram(data,2500, 100, 2048,1000, 'yaxis');  %Spetrogram

mydata = abs(s);            %Calculating the magnitude of the spectral data
result = mean(mydata, 2);   %Calculating the mean of the magnitude of spectral data
figure
plot (f, result)            %Plotting freq v/s mean
title 'Plot of Spectral Density v/s Frequency'

%Princiapl Component Analysis%
mydata_2 = abs(s);
[coeff score latent] = pca (mydata_2');  %Applying PCA on magnitude of spectral data

figure
subplot 212
plot(score(:,1))                         %Poltting the first principal component
title 'Plot of PC1'
subplot 211
plot (time, data)
title 'Raw EEG Signal Plot'

mov = movmean(score(:,1), 20);           %Smoothening of PC1 by applying moving mean

figure
subplot 211
plot (mov)                               %Plooting final PC1
title 'Smoothed PC1 Plot'
subplot 212                                 
histogram (mov, 100)                     %Plotting histogram for final PC1
title 'Histogram of smoothed PC1'
end
