function [EEG_artfree] = art_free_dat(EEG_Data)

win = chebwin(150,150);
thres = 0.5;

fs = 1/EEG_Data.interval;
values = EEG_Data.values;
dat_1 = zeros(length(EEG_Data.values),1);
dat_1(find(abs(EEG_Data.values)>= thres),1) = EEG_Data.values(find(abs(EEG_Data.values)>= thres));
dat = conv(abs(dat_1),win,'same');
clear idx_on idx_off

for ii=2:size(dat,1)-1
    if dat(ii)==0
if dat(ii+1)~=0
    idx_on(ii,1) = (ii)/fs;
elseif dat(ii-1)~= 0
    idx_off(ii,1) = (ii)/fs;
end
    end
end

idx_on = idx_on(any(idx_on,2),:);
idx_off = idx_off(any(idx_off,2),:);

EEG_arti.times = zeros(length(idx_on)*2,1);
EEG_arti.times(1:2:end-1) = idx_on;
EEG_arti.times(2:2:end) = idx_off;
sig_clean = art_remove(EEG,EEG_arti);

EEG_artfree.values = sig_clean.dat;

% 
% times_1 = (1:length(EEG.values))*EEG.interval;
% figure
% subplot 211
% plot(times_1,EEG.values)
% subplot 212
% 
% plot(times_1,sig_clean.dat)
% xlim([29 33])