function [output] = visual_plot(input1, time_input1, input2, time_input2, time_analysis, Filename)

output.vis_plot = figure('units','normalized','outerposition',[0 0 1 1]);        
subplot 211
plot(time_input1,input1.values)
title 'EEG Signal Visual Plot'
ylim([-2 2])
xlim([0 max(time_input1)])

for ii=1:length(time_analysis)
if time_analysis(ii,1) == 0
     text(time_analysis(ii,2),0,'O','horizontalalignment','center','color','b','fontsize',12,'fontweight','bold')
%      plot(Sleep_Wake_Code(ii,2),0,'or','markersize',4,'markerfacecolor','red')
%       plot(nrem_ep_dur(ii,1),0,'or','markersize',4,'markerfacecolor','red')
elseif time_analysis(ii,1) == 1
         text(time_analysis(ii,2),0,'x','horizontalalignment','center','color','k','fontsize',12,'fontweight','bold')

%     times_aw(ii,1) = ii*2.5;
elseif time_analysis(ii,1) == 2 
         text(time_analysis(ii,2),0,'O','horizontalalignment','center','color','r','fontsize',12,'fontweight','bold')

%     times_qw(ii,1) = ii*2.5;
end
end


subplot 212
plot(time_input2(1:end-1),input2)
title 'EMG Signal Visual Plot'
ylim([-0.5 0.5])
xlim([0 max(time_input2)])

for ii=1:length(time_analysis)
if time_analysis(ii,1) == 0
     text(time_analysis(ii,2),0,'O','horizontalalignment','center','color','b','fontsize',12,'fontweight','bold')
%      plot(Sleep_Wake_Code(ii,2),0,'or','markersize',4,'markerfacecolor','red')
%       plot(nrem_ep_dur(ii,1),0,'or','markersize',4,'markerfacecolor','red')
elseif time_analysis(ii,1) == 1
         text(time_analysis(ii,2),0,'x','horizontalalignment','center','color','k','fontsize',12,'fontweight','bold')

%     times_aw(ii,1) = ii*2.5;
elseif time_analysis(ii,1) == 2 
         text(time_analysis(ii,2),0,'O','horizontalalignment','center','color','r','fontsize',12,'fontweight','bold')
         
         

%     times_qw(ii,1) = ii*2.5;
end
end

savefig(output.vis_plot, strcat('D:\Toolbox Based Results\Visual Plotting\', Filename, '_vis_plot'))

end