% This function has been created for downsampling of EEG Data and 
% floor response. The function has been created by Naman Jain
% (naman.jain@tuebingen.mpg.de)


function [output] = dat_dwn_1(input1, input2, fs, fs_emg, fs_dwn)

          
offset = menu ('Are the sampling frequencies of EEG and Floor Channel Same ?', 'Yes', 'No');


if offset == 1
    factor = round(fs/fs_dwn);
    rawdata_downsample = decimate (input1, factor, 'fir');
    emg_dwn = downsample (input2, factor);

elseif offset == 2
    eeg_upsample = upsample (input1, 10);
    rawdata_downsample = decimate (eeg_upsample, round(fs/10), 'fir');
    emg_upsample = upsample (input2, 10);
    emg_dwn = decimate (emg_upsample, round(fs_emg/10), 'fir');
    
    if size(rawdata_downsample, 1) > size(emg_dwn, 1)
       diff = size(rawdata_downsample, 1) - size(emg_dwn, 1);
       rawdata_downsample(end-diff:end) = [];
       emg_dwn = emg_dwn(1:end-1);
    elseif size(emg_dwn, 1) > size(rawdata_downsample, 1)
           diff = size(emg_dwn, 1) - size(rawdata_downsample, 1);
           emg_dwn(end-diff:end) = [];
           rawdata_downsample = rawdata_downsample(1:end-1);
    end
end

Samples_dwn =(1:length(rawdata_downsample))';   
time_down = Samples_dwn/100; 
 
Samples_dwn_emg =(1:length(emg_dwn))';   
time_emg_down = Samples_dwn_emg/100; 

output.time.eeg = time_down;
output.time.emg = time_emg_down;
 
if length(rawdata_downsample) == length(time_down)

    output.eegdown = rawdata_downsample;
    
elseif length(rawdata_downsample) > length(time_down)
  
   output.eegdown = rawdata_downsample(1:end-1);
   
elseif length(rawdata_downsample) < length(time_down)

    time_down = time_down(1:end-1);
    output.eegdown = rawdata_downsample;

end

 
 
if length(emg_dwn) == length(time_emg_down)

    output.emgdown = emg_dwn;
elseif length(emg_dwn) > length(time_emg_down)
  
   output.emgdown = emg_dwn(1:end-1);
   
elseif length(emg_dwn) < length(time_emg_down)

    time_emg_down = time_emg_down(1:end-1);
    output.emgdown = emg_dwn;
end

end
