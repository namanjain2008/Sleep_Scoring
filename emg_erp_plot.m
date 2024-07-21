function [erp_emg] = emg_erp_plot(time_erp_emg, EMG_Data, emg_av_aaud, emg_av_qaud, emg_av_saud, emg_av_as, emg_av_qs, emg_av_ss, emg_av_aaud_S, emg_av_qaud_S, emg_av_saud_S)

fr = EMG_Data.interval;
time_erp_emg = 0:fr:2

epr_fig = figure('units','normalized','outerposition',[0 0 1 1])

subplot 331
plot (time_erp_emg(1:end-1), emg_av_aaud)
title 'pre - Active Wake'

subplot 332
plot (time_erp_emg(1:end-1), emg_av_qaud)
title 'pre - Quiet Wake'

subplot 333
plot (time_erp_emg(1:end-1), emg_av_saud)
title 'pre - Sleep'

subplot 334
plot (time_erp_emg(1:end-1), emg_av_as)
title 'Startle - Active Wake'

subplot 335
plot (time_erp_emg(1:end-1), emg_av_qs)
title 'Startle - Quiet Wake'

subplot 336
plot (time_erp_emg(1:end-1), emg_av_ss)
title 'Startle - Sleep'

subplot 337
plot (time_erp_emg(1:end-1), emg_av_aaud_S)
title 'pre + Startle - Active Wake'

subplot 338
plot (time_erp_emg(1:end-1), emg_av_qaud_S)
title 'pre + Startle - Quiet Wake'

subplot 339
plot (time_erp_emg(1:end-1), emg_av_saud_S)
title 'pre + Startle - Sleep'

end