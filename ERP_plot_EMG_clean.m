function [output] = ERP_plot_EMG_clean(input, ll, ul, fr, Filename)


time_erp_eeg = 0:fr:2;

startle_aw     = input.startle.Active.Average;
startle_qw     = input.startle.Quiet.Average;
startle_sleep  = input.startle.Sleep.Average;

audpre_aw      = input.audpre.Active.Average;
audpre_qw      = input.audpre.Quiet.Average;
audpre_sleep   = input.audpre.Sleep.Average;

audpre_S_aw    = input.audpre_S.Active.Average;
audpre_S_qw    = input.audpre_S.Quiet.Average;
audpre_S_sleep = input.audpre_S.Sleep.Average;

output.erp_fig = figure('units','normalized','outerposition',[0 0 1 1])

subplot 331
plot (time_erp_eeg(1:end-1), audpre_aw)
ylim ([ll ul])
title 'pre - Active Wake'
legend (strcat('No. of Trials - ', num2str(size (input.audpre.Active.Stimuli, 2))))

subplot 332
plot (time_erp_eeg(1:end-1), audpre_S_qw)
ylim ([ll ul])
title 'pre - Quiet Wake'
legend (strcat('No. of Trials - ', num2str(size (input.audpre.Quiet.Stimuli, 2))))

subplot 333
plot (time_erp_eeg(1:end-1), audpre_sleep)
ylim ([ll ul])
title 'pre - Sleep'
legend (strcat('No. of Trials - ', num2str(size (input.audpre.Sleep.Stimuli, 2))))

subplot 334
plot (time_erp_eeg(1:end-1), startle_aw)
ylim ([ll ul])
title 'Startle - Active Wake'
legend (strcat('No. of Trials - ', num2str(size (input.startle.Active.Stimuli, 2))))

subplot 335
plot (time_erp_eeg(1:end-1), startle_qw)
ylim ([ll ul])
title 'Startle - Quiet Wake'
legend (strcat('No. of Trials - ', num2str(size (input.startle.Quiet.Stimuli, 2))))

subplot 336
plot (time_erp_eeg(1:end-1), startle_sleep)
ylim ([ll ul])
title 'Startle - Sleep'
legend (strcat('No. of Trials - ', num2str(size (input.startle.Sleep.Stimuli, 2))))

subplot 337
plot (time_erp_eeg(1:end-1), audpre_S_aw)
ylim ([ll ul])
title 'pre + Startle - Active Wake'
legend (strcat('No. of Trials - ', num2str(size (input.audpre_S.Active.Stimuli, 2))))
subplot 338
plot (time_erp_eeg(1:end-1), audpre_S_qw)
ylim ([ll ul])
title 'pre + Startle - Quiet Wake'
legend (strcat('No. of Trials - ', num2str(size (input.audpre_S.Quiet.Stimuli, 2))))

subplot 339
plot (time_erp_eeg(1:end-1), audpre_S_sleep)
ylim ([ll ul])
title 'pre + Startle - Sleep'
legend (strcat('No. of Trials - ', num2str(size (input.audpre_S.Sleep.Stimuli, 2))))

savefig(output.erp_fig, strcat('D:\Toolbox Based Results\Graphs for ERP - EMG\Clean\', Filename, '_erp_emg_clean'))

end