function [ score ] = autoscore( data )
%AUTOSCORE Automatic sleep scorer

%   This function automatically classifies different sleep
%   stages (wake, NREM, REM) from the given EEG and EMG
%   data and a set of initial manual scoring results.
%
%   Input data:
%   data.eeg   = EEG data (samples per epoch x epoch count)
%   data.eeg_f = EEG sampling frequency
%   data.emg   = EMG data (samples per epcoh x epoch count)
%   data.emg_f = EMG sampling frequency
%   data.score = Manually scored training data (epoch count x 1)
%                0 = Wake, 1 = NREM, 2 = REM, 8 = not scored
%
%   Output data:
%   score      = Automatic scoring results

n = size(data.eeg.values, 2);

% Transform EEG and EMG signals to frequency domain
eegN = size(data.eeg.values, 1);
[~, eegF, ~, eegP] = spectrogram( ...
    reshape(data.eeg.values, 1, n * eegN), ...
    eegN, 0.0, 2 ^ nextpow2(eegN), data.eeg_f);
emgN = size(data.emg.values, 1);
[~, emgF, ~, emgP] = spectrogram( ...
    reshape(data.emg.values, 1, n * emgN), ...
    emgN, 0.0, 2 ^ nextpow2(emgN), data.emg_f);

% Split data into logarithmic frequency bands
bands = logspace(log10(0.5), log10(100), 331);
input = zeros(n, 331);
for i = 1 : 330
    input(i, :) = sum(eegP(and(eegF >= bands(i), eegF < bands(i + 1)), :), 1);
end
input(331, :) = sum(emgP(and(emgF >= 4, emgF < 40), :));

% Normalize using a log transformation and smooth over time
input = conv2(max(log(input), -20), fspecial('gaussian', [ 5 1 ], 0.75), 'same');

% Automatically classify data based on the given training epochs
training = (data.score(:,1) <=8); % 0-2 = Wake/NREM/REM, 8 = not scored
score = classify(...
    input, input(training, :), data.score(training), ...
     'diaglinear', 'empirical'); % Naive Bayes