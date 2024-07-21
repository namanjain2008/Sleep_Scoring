% input is the EEG rawdata_downsample,
% Fs is the sampling frequency of the downsampled data,
% ll is the lower frequency for BP Filter
% ul is the upper frequency for BP Filter

function [output] = sig_fil (input, ll, ul, Fs) 

naman = input;

rawdata_downsample = naman.eegdown;
t_dwn              = naman.time.eeg;

% Fs = 100;     % Sampling Frequency (Hz) 
Fn = Fs / 2;  % Nyquist Frequency (Hz) 
Rp = 1;       % Passband Ripple (dB) 
Rs = 150;     % Stopband Ripple (dB) 
 
%%%%Delta Signal%%%%

delta    = [ll ul] / Fn;                                   % Passband Frequency (Normalized) 
del_norm = [ll-0.1 ul+0.1] / Fn;                                % Stopband Frequency (Normalized) 
 
[n, del_norm] = cheb2ord (delta, del_norm, Rp, Rs);        % Filter Order 
[z, p, k]     = cheby2 (n, Rs, del_norm);                  % Filter Design 
[delbp, dbp]  = zp2sos (z, p, k); 
 
% Convert To Second-Order Section For Stability figure 
 
sig_del = filtfilt (delbp, dbp, rawdata_downsample);     % Filter Signal

sig_raw   = rawdata_downsample;

%%% 
if length(sig_del) == length(t_dwn)                %Calculating the length for delta signal after 
    output = sig_del;                           %downsampling of data 
elseif length(sig_del) > length(t_dwn)
    output = sig_del(1:end-1);
elseif length(sig_del) < length(t_dwn)
    t_dwn = t_dwn(1:end-1);
    output = sig_del;
end

end