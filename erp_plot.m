function [h1] = erp_plot(emg_ep_active_startle,fs) 

clear frames std_aaa xxx yyy erp_time dat
dat = emg_ep_active_startle(2001:end,:);
erp_time = (1:length(dat))'/fs;


for jj = 1:size (dat,2)
for ii = 1:size (dat,1)-2
    frames = dat(ii:ii+2,jj);
    std_aaa(ii,jj) = std(frames);
end
end


for jj = 1:size (std_aaa,2)
for ii = 1:size (std_aaa,1)
%     if std_aaa(ii,jj) == max(std_aaa(:,jj));
%     yyy(jj) = ii/1000;
  if std_aaa(ii,jj) >= 2*std(std_aaa(:,jj))
      xxx(jj) = ii/1000;
  end
end
end

figure
h1 =  plot(xxx,dat(xxx*1000),'ro')
xlabel 'time of startle'
ylabel 'amplitude'
% xlim([0 10])
% ylim([-3 1])
figure
for jj = 1:size (std_aaa,2)
    x = round(size (std_aaa,2)/3);
    subplot (x,3,jj)
    plot(erp_time,dat(:,jj))
    title(jj)
end

jj=1;
for ii=1:size(h1.XData,2)
    if h1.XData(ii) < 0.5
        tn(jj) = ii;
        jj=jj+1;
    end
end


for jj=tn
for ii = 1:length (dat)
    
    av_dat(ii,1) = mean(dat(ii,jj));
end
end

figure
plot(erp_time,av_dat)
 ylim([-1 1])
 
end